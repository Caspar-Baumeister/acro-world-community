# Stripe Booking System Documentation

This document provides a comprehensive overview of how the Stripe booking system works in AcroWorld, including all mutations, queries, fragments, permissions, roles, and the web booking flow.

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Mutations](#mutations)
4. [Queries](#queries)
5. [Fragments](#fragments)
6. [Permissions & Roles](#permissions--roles)
7. [Mobile Booking Flow](#mobile-booking-flow)
8. [Web Booking Flow](#web-booking-flow)
9. [Cash Payment Flow](#cash-payment-flow)
10. [Stripe Account Setup](#stripe-account-setup)

---

## Overview

The AcroWorld booking system supports three payment methods:
1. **Stripe Payment** (Mobile & Web) - Online payment via Stripe Connect
2. **Cash Payment** - Payment at the event location
3. **Direct Charge** - For event highlighting (creator feature)

The system uses Stripe Connect to enable direct charges from customers to teachers/organizers, with automatic commission handling.

---

## Architecture

### Key Components

- **StripeRepository** (`lib/data/repositories/stripe_repository.dart`) - Handles all Stripe-related GraphQL operations
- **StripeService** (`lib/services/stripe_service.dart`) - Wraps Stripe SDK operations for mobile
- **CheckoutStep** (`lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/checkout_step.dart`) - UI component for checkout process
- **Web Checkout** (`web/booking/checkout.js` & `checkout.html`) - Web-based Stripe Embedded Checkout

### Data Models

- **BookingOption** - Represents a ticket/booking option with price, currency, discount, etc.
- **ClassEventBooking** - Represents a completed booking with status, payment info, etc.
- **Teacher** - Contains Stripe account information (`stripe_id`, `is_stripe_enabled`)

---

## Mutations

### 1. `createPaymentSheet`

Creates a Stripe Payment Sheet for mobile payments.

**Location:** `lib/data/graphql/mutations.dart:537-549`

```graphql
mutation CreatePaymentSheet($bookingOptionId: String!, $classEventId: String!) {
  create_payment_sheet(
    booking_option_id: $bookingOptionId
    class_event_id: $classEventId
  ) {
    payment_intent
    ephemeral_key
    customer_id
  }
}
```

**Variables:**
- `bookingOptionId` (String!, required) - The booking option ID
- `classEventId` (String!, required) - The class event ID

**Returns:**
- `payment_intent` - Stripe Payment Intent client secret
- `ephemeral_key` - Ephemeral key for customer access
- `customer_id` - Stripe customer ID

**Usage:** Called by `StripeRepository.createPaymentSheet()` to initialize mobile payment flow.

---

### 2. `confirmPayment`

Confirms a payment after successful payment sheet presentation.

**Location:** `lib/data/graphql/mutations.dart:577-582`

```graphql
mutation confirmPayment($payment_intent_id: uuid!) {
  payment_intent_succeeded(objects: {payment_intent_id: $payment_intent_id}) {
    id
  } 
}
```

**Variables:**
- `payment_intent_id` (uuid!, required) - The Stripe Payment Intent ID

**Returns:**
- `id` - Confirmation record ID

**Usage:** Called by `StripeRepository.confirmPayment()` after `Stripe.instance.presentPaymentSheet()` succeeds.

---

### 3. `createStripeUser`

Creates a Stripe Connect account for a teacher/organizer.

**Location:** `lib/data/graphql/mutations.dart:252-258`

```graphql
mutation createStripeUser($countryCode: String, $defaultCurrency: String) {
  create_stripe_user(country_code: $countryCode, default_currency: $defaultCurrency) {
    url
  }
}
```

**Variables:**
- `countryCode` (String, optional) - Country code for Stripe account
- `defaultCurrency` (String, optional) - Default currency for the account

**Returns:**
- `url` - Stripe onboarding URL

**Usage:** Called when a teacher/organizer sets up Stripe Connect for the first time.

---

### 4. `createDirectChargePaymentSheet`

Creates a payment sheet for direct charges (e.g., event highlighting).

**Location:** `lib/data/graphql/mutations.dart:212-220`

```graphql
mutation CreateDirectChargePaymentSheet($classEventId: String!, $amount: Float!) {
  create_direct_charge_payment_sheet(class_event_id: $classEventId, amount: $amount) {
    payment_intent
    ephemeral_key
    customer_id
  }
}
```

**Variables:**
- `classEventId` (String!, required) - The class event ID
- `amount` (Float!, required) - Amount in currency units (not cents)

**Returns:**
- `payment_intent` - Stripe Payment Intent client secret
- `ephemeral_key` - Ephemeral key for customer access
- `customer_id` - Stripe customer ID

**Usage:** Used for creator features like highlighting events.

---

### 5. `verifyStripeAccount`

Verifies a Stripe Connect account after onboarding.

**Location:** `lib/data/graphql/mutations.dart:207-209`

```graphql
mutation {
  verify_stripe_account
}
```

**Returns:**
- Boolean indicating if the account is verified

**Usage:** Called after redirect from Stripe Connect onboarding to verify account status.

---

### 6. `insertClassEventBooking`

Creates a booking record (used for cash payments and after Stripe payment confirmation).

**Location:** `lib/data/graphql/mutations.dart:59-65`

```graphql
mutation InsertClassEventBooking($booking: class_event_bookings_insert_input!) {
  insert_class_event_bookings_one(object: $booking) {
    id
  }
}
```

**Variables:**
- `booking` (class_event_bookings_insert_input!, required) - Booking data including:
  - `amount` - Amount in cents
  - `booking_option_id` - Booking option ID
  - `class_event_id` - Class event ID
  - `currency` - Currency code
  - `status` - Booking status ("WaitingForPayment" for cash, "Confirmed" for Stripe)
  - `user_id` - User ID

**Returns:**
- `id` - Created booking ID

**Usage:** 
- For cash payments: Creates booking with status "WaitingForPayment"
- For Stripe payments: Backend creates booking automatically after payment confirmation

---

## Queries

### 1. `getStripeLoginLink`

Gets the Stripe Connect login link for a teacher/organizer.

**Location:** `lib/data/graphql/queries.dart:225-227`

```graphql
query GetStripeLoginLink {
  stripe_login_link
}
```

**Returns:**
- `stripe_login_link` (String) - URL to access Stripe Connect dashboard

**Usage:** Allows teachers/organizers to access their Stripe Connect dashboard.

---

### 2. `create_checkout_session` (Web Only)

Creates a Stripe Checkout Session for web payments.

**Location:** `web/booking/checkout.js:34-35` (embedded in JavaScript)

```graphql
mutation CreateCheckoutSession($booking_option_id: String!, $class_event_id: String!) {
  create_checkout_session(
    booking_option_id: $booking_option_id
    class_event_id: $class_event_id
  ) {
    client_secret
  }
}
```

**Variables:**
- `booking_option_id` (String!, required) - The booking option ID
- `class_event_id` (String!, required) - The class event ID

**Returns:**
- `client_secret` - Stripe Checkout Session client secret

**Usage:** Used exclusively for web-based payments via Stripe Embedded Checkout.

---

## Fragments

### 1. `classEventBookingFragment`

Fragment for class event booking data.

**Location:** `lib/data/graphql/fragments.dart:35-79`

```graphql
fragment classEventBookingFragment on class_event_bookings {
  id
  created_at
  amount
  status
  currency
  payment_intent_id
  user {
    id
    name
    acro_role {
      name
      id
    }
    email
    image_url
    level {
      name
      id
    }
  }
  class_event {
    id
    start_date
    class {
      url_slug
      id
      name
      image_url
      created_by {
        id
        name
        email
      }
    }
  }
  booking_option {
    # bookingOptionFragment fields
    commission
    currency
    discount
    id
    price
    subtitle
    title
    updated_at
    category_id
    category {
      id
      name
      contingent
    }
  }
}
```

**Used in:**
- `getClassEventBookings` query
- `getClassEventBookingsByClassEventId` query

---

### 2. `bookingOptionFragment`

Fragment for booking option data.

**Location:** `lib/data/graphql/fragments.dart:81-91`

```graphql
fragment bookingOptionFragment on booking_option {
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
```

**Used in:**
- `getBookingCategories` query
- `classEventBookingFragment`
- Various class fragments

---

### 3. `teacherFragmentAllInfo`

Fragment for teacher data including Stripe information.

**Location:** `lib/data/graphql/fragments.dart:288-317`

```graphql
fragment teacherFragmentAllInfo on teachers {
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
    image {
      url
    }
    is_profile_picture
  }
}
```

**Key Stripe Fields:**
- `stripe_id` - Stripe Connect account ID
- `is_stripe_enabled` - Boolean indicating if Stripe payments are enabled

**Used in:**
- Teacher profile queries
- Class owner/teacher queries

---

## Permissions & Roles

### User Permissions

1. **Authentication Required**
   - All booking operations require an authenticated user
   - User ID must be present in JWT token
   - Token is passed in GraphQL request headers: `Authorization: Bearer <token>`

2. **Booking Permissions**
   - Any authenticated user can create bookings
   - Users can only book for themselves (user_id from token)
   - No special role required for booking

### Teacher/Organizer Permissions

1. **Stripe Setup Requirements**
   - Teacher must have `stripe_id` set (Stripe Connect account ID)
   - Teacher must have `is_stripe_enabled = true`
   - Teacher must complete Stripe Connect onboarding

2. **Payment Receiver**
   - Class owners can set `is_payment_receiver = true` on `class_owners` table
   - Only one payment receiver per class (typically the class creator)
   - Payment receiver's Stripe account receives the payment

3. **Creator Mode**
   - Teachers with Stripe enabled can create events with online payments
   - Teachers can view bookings in creator dashboard
   - Teachers can manage booking options and categories

### Class/Event Permissions

1. **Payment Method Requirements**
   - For Stripe payments: At least one class owner must have `stripe_id` and `is_stripe_enabled = true`
   - For cash payments: Class must have `is_cash_allowed = true`
   - If neither condition is met, booking is not available

2. **Booking Option Requirements**
   - Class must have at least one `booking_option` to enable booking
   - Booking options can be organized into categories with contingents

### Backend Permissions (Hasura)

The following permissions are enforced at the Hasura/GraphQL level:

1. **create_payment_sheet**
   - Requires authenticated user
   - Validates booking option and class event exist
   - Checks if teacher has Stripe enabled
   - Creates Stripe Payment Intent with correct connected account

2. **confirmPayment / payment_intent_succeeded**
   - Requires authenticated user
   - Validates payment intent belongs to user
   - Creates booking record automatically
   - Updates booking status to "Confirmed"

3. **insert_class_event_bookings**
   - Requires authenticated user
   - User can only create bookings for themselves
   - Validates booking option and class event exist
   - Checks contingent limits if applicable

4. **create_checkout_session** (Web)
   - Requires authenticated user (token in URL)
   - Same validations as `create_payment_sheet`

---

## Mobile Booking Flow

### Step-by-Step Process

1. **User Selects Booking Option**
   - User navigates to class event page
   - Selects a booking option (ticket type)
   - Clicks "Book now"

2. **Checkout Step Initialization**
   - `CheckoutStep` widget is displayed
   - `_initializeAll()` is called:
     - Loads current user from `userRiverpodProvider`
     - Calls `initPaymentSheet()` to create payment sheet
     - Initializes answers provider for event questions

3. **Payment Sheet Creation**
   - `StripeService.initPaymentSheet()` is called
   - `StripeRepository.createPaymentSheet()` executes `createPaymentSheet` mutation
   - Backend creates Stripe Payment Intent with:
     - Amount from booking option (in cents)
     - Connected account (teacher's Stripe account)
     - Customer (user's Stripe customer ID)
   - Returns: `payment_intent`, `ephemeral_key`, `customer_id`

4. **Stripe SDK Initialization**
   - `Stripe.instance.initPaymentSheet()` is called with:
     - Payment intent client secret
     - Ephemeral key
     - Customer ID
     - Billing details (user email, name)
     - Apple Pay / Google Pay configuration
   - Payment intent ID is stored in component state

5. **User Completes Information**
   - User reviews booking summary
   - User answers required questions (if any)
   - User verifies their information

6. **Payment Presentation**
   - User clicks "Continue to payment"
   - Validates all required questions are answered
   - `attemptToPresentPaymentSheet()` is called
   - `Stripe.instance.presentPaymentSheet()` displays Stripe payment UI
   - User completes payment (card, Apple Pay, Google Pay, etc.)

7. **Payment Confirmation**
   - On successful payment, `StripeRepository.confirmPayment()` is called
   - `confirmPayment` mutation is executed
   - Backend:
     - Verifies payment intent succeeded
     - Creates `class_event_bookings` record with status "Confirmed"
     - Links payment intent ID to booking
   - Answers are saved via `eventAnswerProvider.mutateAnswers()`

8. **Completion**
   - Booking modal is closed
   - `fireRefetchBookingQuery()` event is fired
   - UI updates to show booking status

### Code Flow

```
CheckoutStep._initializeAll()
  └─> StripeService.initPaymentSheet()
      └─> StripeRepository.createPaymentSheet()
          └─> Mutations.createPaymentSheet (GraphQL)
              └─> Backend: create_payment_sheet resolver
                  └─> Returns: payment_intent, ephemeral_key, customer_id
      └─> Stripe.instance.initPaymentSheet()
          └─> Payment sheet ready

User clicks "Continue to payment"
  └─> CheckoutStep.attemptToPresentPaymentSheet()
      └─> StripeService.attemptToPresentPaymentSheet()
          └─> Stripe.instance.presentPaymentSheet()
              └─> User completes payment
          └─> StripeRepository.confirmPayment()
              └─> Mutations.confirmPayment (GraphQL)
                  └─> Backend: payment_intent_succeeded resolver
                      └─> Creates class_event_bookings record
```

---

## Web Booking Flow

### Step-by-Step Process

1. **User Initiates Web Booking**
   - User is on web platform (`kIsWeb == true`)
   - User selects booking option and clicks "Continue to payment"
   - `CheckoutStep` detects web platform and `isDirectPayment == true`

2. **Redirect to Checkout Page**
   - Button click constructs URL:
     ```
     /booking/checkout.html?bookingOptionId=<id>&classEventId=<id>&token=<jwt>&dev=<true|false>
     ```
   - User is redirected to checkout page
   - JWT token is passed in URL parameters

3. **Checkout Page Initialization**
   - `checkout.js` `initialize()` function runs
   - Extracts URL parameters:
     - `bookingOptionId`
     - `classEventId`
     - `token` (JWT)
     - `dev` (environment flag)

4. **Stripe Initialization**
   - Stripe.js is initialized with publishable key:
     - Test: `pk_test_51O3GqCKwmxSCW9DthK2a7OK4oT642myOk2KiiBIk8uqNturYtGiJ4Nz2IqPF67SpjESquJRjZ7I8Vyfkdzu4Knbx00lyD9wCVl`
     - Live: `pk_live_51O3GqCKwmxSCW9DtYK0YflQyi30q4q0KkzboHwaPJ4N3YXsxZ9mE9tlreE3cr6eTWPf1OjH95BvyRnsa3c8NlNzI00vW4e2xap`

5. **Checkout Session Creation**
   - `fetchClientSecret()` function is defined
   - Makes POST request to GraphQL endpoint:
     - Dev: `https://dev.acroworld.de/hasura/v1/graphql`
     - Prod: `https://bro-devs.com/hasura/v1/graphql`
   - Request includes:
     - `Authorization: Bearer <token>` header
     - `create_checkout_session` mutation
     - Variables: `booking_option_id`, `class_event_id`
   - Backend creates Stripe Checkout Session
   - Returns `client_secret`

6. **Embedded Checkout Mount**
   - `stripe.initEmbeddedCheckout()` is called with `fetchClientSecret`
   - Stripe Embedded Checkout is mounted to `#checkout` div
   - User sees Stripe payment form

7. **Payment Completion**
   - User completes payment in embedded checkout
   - Stripe handles payment processing
   - Backend webhook (not shown in frontend code) confirms payment
   - Booking is created automatically

8. **Redirect/Completion**
   - User is redirected back to app (handled by Stripe)
   - Booking status is updated

### Code Flow

```
User clicks "Continue to payment" (Web)
  └─> launchUrl() to /booking/checkout.html?params
      └─> checkout.js initialize()
          └─> Stripe() initialization
          └─> fetchClientSecret()
              └─> POST to GraphQL with create_checkout_session mutation
                  └─> Backend: create_checkout_session resolver
                      └─> Returns: client_secret
          └─> stripe.initEmbeddedCheckout({ fetchClientSecret })
              └─> checkout.mount("#checkout")
                  └─> User completes payment
                      └─> Backend webhook confirms payment
                          └─> Booking created
```

### Web Checkout Files

- **checkout.html** (`web/booking/checkout.html`)
  - Minimal HTML page with `#checkout` div
  - Loads Stripe.js and checkout.js

- **checkout.js** (`web/booking/checkout.js`)
  - Handles all checkout logic
  - Creates checkout session
  - Mounts Stripe Embedded Checkout

---

## Cash Payment Flow

### Step-by-Step Process

1. **User Selects Cash Payment**
   - Class has `is_cash_allowed = true`
   - User selects booking option
   - Clicks "Pay in cash" button

2. **Validation**
   - Validates all required questions are answered
   - No payment sheet initialization needed

3. **Booking Creation**
   - `insertClassEventBooking` mutation is called directly
   - Booking is created with:
     - `status: "WaitingForPayment"`
     - `amount`: Booking option price (in cents)
     - `currency`: Booking option currency
     - `user_id`: Current user ID
     - `booking_option_id`: Selected option ID
     - `class_event_id`: Event ID

4. **Answers Saved**
   - Event answers are saved via `eventAnswerProvider.mutateAnswers()`

5. **Completion**
   - Success toast: "Booking successful, please pay in cash at the event"
   - Modal closes
   - Booking query is refetched

### Code Flow

```
User clicks "Pay in cash"
  └─> Validates required questions
  └─> eventAnswerProvider.mutateAnswers()
  └─> Mutations.insertClassEventBooking (GraphQL)
      └─> Variables: {
            booking: {
              amount: <price in cents>,
              booking_option_id: <id>,
              class_event_id: <id>,
              currency: <currency>,
              status: "WaitingForPayment",
              user_id: <user_id>
            }
          }
      └─> Backend: Creates booking with WaitingForPayment status
  └─> Success toast
  └─> Modal closes
```

---

## Stripe Account Setup

### Teacher/Organizer Onboarding

1. **Initiate Setup**
   - Teacher navigates to creator profile
   - Clicks "Connect Stripe" or similar button
   - `StripeRepository.createStripeUser()` is called
   - `createStripeUser` mutation is executed

2. **Stripe Connect Onboarding**
   - Backend creates Stripe Connect account
   - Returns onboarding URL
   - User is redirected to Stripe onboarding page
   - User completes:
     - Business information
     - Bank account details
     - Identity verification (if required)

3. **Callback Handling**
   - After onboarding, Stripe redirects to `/stripe/callback`
   - `StripeCallbackPage` handles the callback
   - `StripeRepository.verifyStripeAccount()` is called
   - `verifyStripeAccount` mutation checks account status
   - If verified:
     - Teacher's `stripe_id` is set
     - Teacher's `is_stripe_enabled` is set to `true`
     - Success toast is shown

4. **Account Management**
   - Teachers can access Stripe dashboard via `getStripeLoginLink` query
   - Returns login link for Stripe Connect dashboard

### Code Flow

```
Teacher clicks "Connect Stripe"
  └─> StripeRepository.createStripeUser()
      └─> Mutations.createStripeUser (GraphQL)
          └─> Backend: Creates Stripe Connect account
              └─> Returns: onboarding URL
  └─> User redirected to Stripe onboarding
      └─> User completes onboarding
  └─> Stripe redirects to /stripe/callback
      └─> StripeCallbackPage._verifyStripeAccount()
          └─> StripeRepository.verifyStripeAccount()
              └─> Mutations.verifyStripeAccount (GraphQL)
                  └─> Backend: Verifies account, updates teacher record
                      └─> Returns: boolean
          └─> If verified: Updates UI, shows success
```

---

## Booking Statuses

The system uses the following booking statuses:

- **"WaitingForPayment"** - Cash payment booking, payment pending at event
- **"Confirmed"** - Stripe payment completed, booking confirmed
- **"Cancelled"** - Booking cancelled (not shown in queries)

---

## Commission & Pricing

### Booking Option Pricing

- `price` - Stored in **cents** (e.g., 10000 = €100.00)
- `discount` - Percentage discount (e.g., 10 = 10% off)
- `commission` - Platform commission percentage
- `currency` - Currency code (e.g., "EUR", "USD")

### Price Calculation

```dart
double realPriceDiscounted() {
  return (1 - (discount! * 0.01)) * price! * 0.01;
}
```

Example:
- `price = 10000` (cents)
- `discount = 10` (10%)
- Real price = (1 - 0.10) * 10000 * 0.01 = 0.90 * 100 = **€90.00**

### Commission Handling

- Commission is calculated on the backend
- Stripe Connect automatically handles split payments
- Teacher receives: `amount - (amount * commission / 100)`
- Platform receives: `amount * commission / 100`

---

## Error Handling

### Common Error Scenarios

1. **Payment Sheet Creation Fails**
   - Error: "Error initializing payment, try again later or contact support"
   - User is returned to previous step

2. **Payment Presentation Fails**
   - StripeException is caught
   - Error is logged via CustomErrorHandler
   - User can retry payment

3. **Payment Confirmation Fails**
   - Backend validation fails
   - Booking is not created
   - User may need to contact support

4. **Stripe Account Not Enabled**
   - Error: "Please enable Stripe or allow cash payments to create tickets"
   - Shown when creating event with booking options but no Stripe setup

---

## Security Considerations

1. **JWT Token Authentication**
   - All GraphQL requests require valid JWT token
   - Token is stored securely in local storage
   - Token is passed in Authorization header

2. **Payment Intent Validation**
   - Backend validates payment intent belongs to user
   - Prevents payment confirmation for other users' intents

3. **Booking Validation**
   - Users can only create bookings for themselves
   - Backend enforces user_id from token matches booking user_id

4. **Stripe Connect Security**
   - Only teachers with verified Stripe accounts can receive payments
   - Stripe handles PCI compliance
   - Sensitive payment data never touches AcroWorld servers

---

## Testing

### Test Environment

- Stripe test mode is used when `AppEnvironment.isDev == true`
- Test publishable key: `pk_test_51O3GqCKwmxSCW9DthK2a7OK4oT642myOk2KiiBIk8uqNturYtGiJ4Nz2IqPF67SpjESquJRjZ7I8Vyfkdzu4Knbx00lyD9wCVl`
- Test cards: Use Stripe test card numbers (4242 4242 4242 4242)

### Production Environment

- Stripe live mode when `AppEnvironment.isProdBuild == true`
- Live publishable key: `pk_live_51O3GqCKwmxSCW9DtYK0YflQyi30q4q0KkzboHwaPJ4N3YXsxZ9mE9tlreE3cr6eTWPf1OjH95BvyRnsa3c8NlNzI00vW4e2xap`

---

## Related Files

### Core Files
- `lib/data/repositories/stripe_repository.dart` - Stripe GraphQL operations
- `lib/services/stripe_service.dart` - Stripe SDK wrapper
- `lib/data/graphql/mutations.dart` - GraphQL mutations
- `lib/data/graphql/queries.dart` - GraphQL queries
- `lib/data/graphql/fragments.dart` - GraphQL fragments

### UI Files
- `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/checkout_step.dart` - Checkout UI
- `lib/presentation/screens/creator_mode_screens/stripe_pages/stripe_callback_page.dart` - Stripe callback handler
- `lib/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_stripe_connect_button.dart` - Stripe connect button

### Web Files
- `web/booking/checkout.html` - Web checkout page
- `web/booking/checkout.js` - Web checkout logic

### Models
- `lib/data/models/booking_option.dart` - Booking option model
- `lib/data/models/class_event_booking_model.dart` - Booking model

---

## Notes

- All amounts are stored in **cents** in the database
- Prices are converted to currency units (e.g., euros) for display
- Stripe handles currency conversion for international payments
- The system supports multiple currencies per booking option
- Commission rates can be set per booking option or per teacher

