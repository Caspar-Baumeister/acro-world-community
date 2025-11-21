## Discovery → Single Event API Flow

This document lists every network interaction that happens when a user opens the discovery/events page and then drills down into a single event. The Next.js client should replicate the same GraphQL requests and payloads. All calls use the Hasura GraphQL endpoint described below; there are no REST calls in this flow.

### Base GraphQL Endpoint
- **Method:** `POST`
- **URL (prod):** `https://bro-devs.com/hasura/v1/graphql`
- **URL (dev):** `https://dev.acroworld.de/hasura/v1/graphql`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <JWT>` (omit header if browsing anonymously)
  - `x-hasura-role: User | TeacherUser | AdminUser` (role selected from JWT claims; default `User`)
- **Transport behavior:** Standard GraphQL HTTP POST. The Flutter client relies on `cacheAndNetwork` (initial discovery fetch) and `networkOnly` (detail view) fetch policies; mimic this in Next.js if you want the same caching semantics.

---

### 1. Discovery page bootstrap
Triggered automatically when `DiscoverPage` mounts because `DiscoveryNotifier.fetchAllEventOccurences()` runs inside the provider constructor.

| Item | Value |
| --- | --- |
| **Operation Name** | `getEventOccurences` |
| **Variables** | `{}` |
| **Fetch Policy** | `cache-and-network` (first load) |
| **Purpose** | Retrieve all upcoming class events (end_date ≥ now) together with enough metadata to render cards and apply filters client-side. |

**Request body**
```graphql
query getEventOccurences {
  class_events(where: {end_date: {_gte: "now"}, class: {id: {_is_null: false}}}) {
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
      aggregate { count }
    }
    participants {
      user { id name acro_role_id }
    }
    is_highlighted
    recurring_pattern {
      is_recurring
      id
      start_date
      end_date
    }
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
      invites { id entity email invited_user_id confirmation_status created_at }
      class_teachers {
        id
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
          stripe_id
          is_stripe_enabled
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
            image { url }
            is_profile_picture
          }
        }
        is_owner
      }
      class_owners {
        teacher {
          id
          name
          user_id
          images(where: {is_profile_picture: {_eq: true}}, limit: 1) {
            image { url }
            is_profile_picture
          }
        }
        is_payment_receiver
      }
      class_levels {
        level { name id }
      }
      event_type
      created_by_id
      questions { id question title position is_required allow_multiple_answers question_type }
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
      class_flags {
        id
        is_active
        user_id
      }
      is_cash_allowed
    }
  }
}
```

**Response expectations**
- Top-level field: `data.class_events` (array).
- Each entry describes an upcoming event occurrence plus its parent class. The Flutter client caches this entire result and applies discovery filters locally; no follow-up requests occur while the user scrolls or filters.

---

### 2. User taps a discovery card
Pure navigation step handled by GoRouter (`/event/:urlSlug?event=<class_event_id>`). No HTTP request is made at this point, but the router passes both `urlSlug` and `classEventId` to the detail wrapper. The Next.js app should do the same so the detail page can decide which query to run.

---

### 3. Event detail wrapper fetch
`SingleEventQueryWrapper` runs one of the following queries depending on the inputs it receives from the router.

#### 3a. Preferred path — known `classEventId`

| Item | Value |
| --- | --- |
| **Operation Name** | `getClassEventWithClasById` |
| **Variables** | `{ "class_event_id": "<uuid>" }` |
| **Fetch Policy** | `network-only` |
| **Purpose** | Fetch the precise occurrence that was tapped (ensures up-to-date availability, cancellations, recurring metadata, etc.). |

**Request body**
```graphql
query getClassEventWithClasById($class_event_id: uuid!) {
  class_events_by_pk(id: $class_event_id) {
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
      aggregate { count }
    }
    participants {
      user { id name acro_role_id }
    }
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
      invites { id entity email invited_user_id confirmation_status created_at }
      class_teachers {
        id
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
          stripe_id
          is_stripe_enabled
          user { id email name }
          user_likes_aggregate { aggregate { count } }
          images { image { url } is_profile_picture }
        }
        is_owner
      }
      class_owners {
        teacher {
          id
          name
          user_id
          images(where: {is_profile_picture: {_eq: true}}, limit: 1) {
            image { url }
            is_profile_picture
          }
        }
        is_payment_receiver
      }
      class_levels { level { name id } }
      event_type
      created_by_id
      questions { id question title position is_required allow_multiple_answers question_type }
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
      class_flags { id is_active user_id }
      is_cash_allowed
    }
  }
}
```

**Response expectations**
- `data.class_events_by_pk` is a single object or `null` if the ID is invalid.
- The UI renders `SingleClassPage` with both the parent class and this specific occurrence.

#### 3b. Fallback path — only `urlSlug`

Used when the router only knows the class slug (for instance, deep linking or older cards).

| Item | Value |
| --- | --- |
| **Operation Name** | `getClassBySlug` |
| **Variables** | `{ "url_slug": "<string>" }` |
| **Fetch Policy** | `network-only` |
| **Purpose** | Fetch the class entity by slug along with all upcoming occurrences so the UI can display the latest schedule. |

**Request body**
```graphql
query getClassById($url_slug: String!) {
  classes(where: {url_slug: {_eq: $url_slug}}) {
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
    invites { id entity email invited_user_id confirmation_status created_at }
    class_teachers {
      id
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
        stripe_id
        is_stripe_enabled
        user { id email name }
        user_likes_aggregate { aggregate { count } }
        images { image { url } is_profile_picture }
      }
      is_owner
    }
    class_owners {
      teacher {
        id
        name
        user_id
        images(where: {is_profile_picture: {_eq: true}}, limit: 1) {
          image { url }
          is_profile_picture
        }
      }
      is_payment_receiver
    }
    class_levels { level { name id } }
    event_type
    created_by_id
    questions { id question title position is_required allow_multiple_answers question_type }
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
    class_flags { id is_active user_id }
    is_cash_allowed
    recurring_patterns {
      day_of_week
      end_date
      end_time
      is_recurring
      id
      recurring_every_x_weeks
      start_date
      start_time
      class_id
    }
    class_events(where: {end_date: {_gte: now}}, order_by: {start_date: asc}) {
      class_id
      created_at
      end_date
      id
      is_cancelled
      available_booking_slots
      max_booking_slots
      start_date
      is_highlighted
      participants_aggregate { aggregate { count } }
      participants { user { id name acro_role_id } }
    }
  }
}
```

**Response expectations**
- `data.classes` is an array; the UI uses the first element if it exists.
- Each class already carries its future events so no additional requests are necessary to render the page.

---

### 4. Flow recap
1. **Discovery load:** `POST /hasura/v1/graphql` → `getEventOccurences` with no variables (cache+network).
2. **Card tap:** Router push with `urlSlug` and `classEventId` (no network).
3. **Detail view:** `POST /hasura/v1/graphql` → either `getClassEventWithClasById` (preferred, network-only) or `getClassBySlug` (fallback, network-only).

These three GraphQL operations cover the entire “Discovery → Event detail” journey. Provide this document to the Next.js team so they can recreate the endpoints and variables exactly.

