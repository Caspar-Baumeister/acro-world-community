# Event Bookability Documentation

This document explains when an event is bookable and provides the GraphQL query to check bookability.

## When is an Event Bookable?

An event is bookable when **ALL** of the following conditions are met:

### Event-Level Conditions

1. **Booking Slots Configured**
   - `maxBookingSlots != null`
   - `availableBookingSlots != null`

2. **Available Slots**
   - `availableBookingSlots > 0` (must have at least 1 available slot)

3. **Not Cancelled**
   - `isCancelled != true`

4. **Class Model Present**
   - `classModel != null`

### Class-Level Conditions (via `classModel.isBookable`)

5. **Has Booking Options**
   - `bookingOptions.isNotEmpty`
   - This means the class must have at least one `booking_category` with at least one `booking_option`

6. **Payment Capability**
   - **Either** Stripe payment is enabled:
     - `class_owners[].teacher.stripe_id != null`
     - `class_owners[].teacher.is_stripe_enabled == true`
   - **Or** cash payment is allowed:
     - `is_cash_allowed == true`

## Bookability Logic

The bookability check is implemented in two places:

### 1. ClassEvent.isBookable

**Location:** `lib/data/models/class_event.dart:26-43`

```dart
bool get isBookable {
  // Must have booking slots configured
  if (maxBookingSlots == null || availableBookingSlots == null) {
    return false;
  }

  // Must have available slots
  if (availableBookingSlots! <= 0) {
    return false;
  }

  // Must have a class model that is bookable
  if (classModel == null) {
    return false;
  }

  return classModel!.isBookable;
}
```

### 2. ClassModel.isBookable

**Location:** `lib/data/models/class_model.dart:66-79`

```dart
bool get isBookable {
  // Must have booking options
  if (bookingOptions.isEmpty) {
    return false;
  }

  // Must have payment capability (Stripe teacher OR cash payment allowed)
  final stripeId = owner?.teacher?.stripeId;
  final isStripeEnabled = owner?.teacher?.isStripeEnabled;
  final hasStripeTeacher = stripeId != null && isStripeEnabled == true;
  final allowsCash = isCashAllowed == true;

  return hasStripeTeacher || allowsCash;
}
```

## GraphQL Query to Check Bookability

### Query: `getClassEventWithClasById`

**Location:** `lib/data/graphql/queries.dart:557-569`

This query fetches a single class event with all necessary data to determine bookability:

```graphql
query getClassEventWithClasById($class_event_id: uuid!) {
  class_events_by_pk(id: $class_event_id) {
    # Event-level fields
    class_id
    created_at
    end_date
    id
    is_cancelled
    available_booking_slots
    max_booking_slots
    start_date
    is_highlighted
    participants_aggregate {
      aggregate {
        count
      }
    }
    participants {
      user {
        id
        name
        acro_role_id
      }
    }
    
    # Class-level fields (nested)
    class {
      url_slug
      booking_email
      max_booking_slots
      city
      description
      id
      image_url
      location
      location_name
      name
      location_country
      location_city
      website_url
      is_cash_allowed
      
      # Class owners (for Stripe check)
      class_owners {
        id
        teacher_id
        is_payment_receiver
        teacher {
          created_at
          url_slug
          description
          type
          id
          location_name
          name
          user_id
          is_organization
          stripe_id          # Required for Stripe payment
          is_stripe_enabled  # Required for Stripe payment
          user {
            id
            email
            name
          }
          user_likes_aggregate {
            aggregate {
              count
            }
          }
          images {
            image {
              url
            }
            is_profile_picture
          }
        }
      }
      
      # Booking categories and options
      booking_categories {
        id
        name
        description
        contingent
        booking_options {
          commission
          currency
          discount
          id
          price
          subtitle
          title
          updated_at
          category_id
        }
      }
      
      # Other class fields...
      class_teachers {
        id
        teacher_id
        teacher {
          # teacherFragmentAllInfo
        }
        is_owner
      }
      class_levels {
        level {
          name
          id
        }
      }
      event_type
      created_by_id
      questions {
        id
        question
        title
        position
        is_required
        allow_multiple_answers
        question_type
        multiple_choice_options {
          id
          question_id
          option_text
          position
        }
      }
      class_flags {
        id
        is_active
        user_id
      }
    }
  }
}
```

### Alternative Query: `getClassBySlug`

**Location:** `lib/data/graphql/queries.dart:487-508`

This query fetches a class by URL slug with all its events. Use this when you have the class slug instead of event ID:

```graphql
query getClassById($url_slug: String!) {
  classes(where: {url_slug: {_eq: $url_slug}}) {
    # classFragmentAllInfo (same as above)
    url_slug
    booking_email
    max_booking_slots
    is_cash_allowed
    class_owners {
      teacher {
        stripe_id
        is_stripe_enabled
      }
    }
    booking_categories {
      booking_options {
        id
        price
        title
        # ... other booking option fields
      }
    }
    # ... other class fields
    
    # Events for this class
    class_events(where: {end_date: {_gte: now}}, order_by: {start_date: asc}) {
      id
      is_cancelled
      available_booking_slots
      max_booking_slots
      start_date
      end_date
      # ... other event fields
    }
  }
}
```

## How to Use the Query

### Example: Check if Event is Bookable

```dart
// Using the query
final result = await client.query(
  QueryOptions(
    document: Queries.getClassEventWithClasById,
    variables: {'class_event_id': eventId},
  ),
);

// Parse the data
final eventData = result.data?['class_events_by_pk'];
if (eventData == null) {
  return false; // Event doesn't exist
}

final classEvent = ClassEvent.fromJson(eventData);

// Check bookability
final isBookable = classEvent.isBookable;
```

### Example: Direct GraphQL Check

If you want to check bookability directly in GraphQL (without parsing in Dart), you would need to construct a query that checks all conditions:

```graphql
query CheckEventBookability($class_event_id: uuid!) {
  class_events_by_pk(id: $class_event_id) {
    id
    is_cancelled
    available_booking_slots
    max_booking_slots
    class {
      id
      is_cash_allowed
      class_owners(where: {
        teacher: {
          stripe_id: {_is_null: false},
          is_stripe_enabled: {_eq: true}
        }
      }) {
        id
      }
      booking_categories {
        booking_options {
          id
        }
      }
    }
  }
}
```

Then in your application logic, check:
- `is_cancelled == false`
- `available_booking_slots > 0`
- `max_booking_slots != null`
- `is_cash_allowed == true` OR `class_owners.length > 0`
- `booking_categories[].booking_options.length > 0`

## Summary

**An event is bookable when:**

✅ Event has `maxBookingSlots` and `availableBookingSlots` set  
✅ `availableBookingSlots > 0`  
✅ `isCancelled == false`  
✅ Class has at least one booking option  
✅ Class has payment capability (Stripe enabled OR cash allowed)

**Use this query to check:**

```graphql
query getClassEventWithClasById($class_event_id: uuid!) {
  class_events_by_pk(id: $class_event_id) {
    ${Fragments.classEventFragment}
    class {
      ${Fragments.classFragmentAllInfo}
    }
  }
}
```

The fragments include all necessary fields to determine bookability.

