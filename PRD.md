
# Product Requirements Document: AcroWorld Community App

## 1. Introduction & Vision

**Vision:** To create the central hub for the global acro yoga community. AcroWorld will be a one-stop mobile application for practitioners to discover events, connect with teachers, and manage their acro-related activities. It aims to foster a more connected, accessible, and vibrant global community.

**Problem:** The acro yoga community is fragmented. Events are scattered across social media, websites, and word-of-mouth, making it difficult for practitioners to find classes, workshops, and festivals. Teachers and organizers lack a dedicated platform to manage their offerings and connect with students.

## 2. Target Audience

*   **Acro Yoga Practitioners:** Individuals of all skill levels (from beginner to advanced) looking for events, teachers, and a sense of community.
*   **Acro Yoga Teachers & Organizers:** Instructors, studios, and festival organizers who want to promote their events, manage bookings, and build their following.

## 3. Core Features

### 3.1 User-Facing Features (The "Community" App)

*   **Event Discovery:**
    *   **Dashboard:** A main feed showcasing highlighted events, bookable events, and events categorized by type (e.g., Festivals, Workshops, Classes).
    *   **Advanced Filtering:** Users can filter events by date, location (country/region), category, and special criteria (e.g., "Bookable," "Highlights").
    *   **Map View:** A map-based interface to discover nearby events.
    *   **Search:** Full-text search for events and teachers.
*   **Event Details & Booking:**
    *   View detailed information for each event, including description, schedule, location, and teacher profiles.
    *   Seamless booking and payment system for events that offer it.
    *   Ability to add events to a personal calendar.
*   **Community & Profile:**
    *   **User Profiles:** Users can create a profile specifying their acro role (e.g., Base, Flyer) and skill level.
    *   **Teacher/Partner Profiles:** View detailed profiles for teachers and organizers, including their bio, gallery, and a list of their upcoming classes.
    *   **Follow/Favorite System:** Users can follow their favorite teachers and bookmark events to stay updated.
    *   **Personalized Dashboard:** View booked events and favorited classes in the profile section.

### 3.2 Creator-Facing Features (The "Creator Mode")

*   **Creator Profile Management:** Teachers and organizers can create and manage a public-facing profile with their information, photos, and links.
*   **Event Management:**
    *   Create, edit, and manage events (single or recurring).
    *   Set up detailed event information, including images, descriptions, and locations.
*   **Booking & Ticketing:**
    *   Create different ticket types and categories with set contingents.
    *   Enable online payments via Stripe integration.
    *   Option to allow cash payments.
*   **Dashboard & Analytics:**
    *   View a dashboard of all bookings.
    *   See a summary of participants for a specific event, including statistics on roles and levels.

## 4. Technical Stack

*   **Frontend:** Flutter (for cross-platform iOS & Android support)
*   **Backend:** Hasura with a PostgreSQL database (for a flexible GraphQL API)
*   **Authentication:** Firebase Authentication (integrated with Hasura via JWT)
*   **Payments:** Stripe Connect (for direct charges and creator payouts)
*   **File Storage:** Firebase Storage (for user-uploaded images)
*   **Push Notifications:** Firebase Cloud Messaging (FCM)
*   **Error Tracking & Monitoring:** Sentry

## 5. Non-Functional Requirements

*   **Performance:** The app must be fast and responsive, with smooth scrolling and quick load times, even with many images and events.
*   **Usability:** The user interface should be intuitive and easy to navigate for both technical and non-technical users.
*   **Scalability:** The backend architecture must be able to handle a growing number of users, events, and bookings.
*   **Security:** All user data, especially authentication and payment information, must be handled securely.

## 6. Success Metrics

*   Number of active monthly users.
*   Number of events created and published per month.
*   Total number of bookings processed through the platform.
*   User retention rate.
*   App Store and Play Store ratings.

## 7. Technical Refactoring Requirements

### 7.1 State Management Migration
*   **Complete Riverpod Migration:** Replace all Provider implementations with Riverpod for consistent state management
*   **Remove Provider Dependencies:** Eliminate all Provider-related code and dependencies
*   **Standardize State Patterns:** Implement consistent patterns for state management across all features

### 7.2 Navigation & UI Cleanup
*   **Fix Double Navigation Bars:** Resolve the issue of dual bottom navigation bars being displayed
*   **Remove "Around Me" Tab:** Eliminate the activities/calendar tab and all associated components
*   **Standardize Navigation:** Ensure consistent navigation patterns throughout the app
*   **Clean Up Unused Routes:** Remove all routes and components related to removed features

### 7.3 Logging & Error Handling
*   **Enhanced Logging System:** Extend Sentry integration with comprehensive logging capabilities
*   **Centralized Error Handling:** Implement robust error handling with proper logging and user feedback
*   **Performance Monitoring:** Add performance tracking and monitoring capabilities

### 7.4 Code Quality & Architecture
*   **Remove Unused Code:** Identify and eliminate all dead code and unused dependencies
*   **Standardize Design System:** Implement consistent UI components and design patterns
*   **Image Aspect Ratios:** Ensure all images have consistent landscape aspect ratios
*   **Code Organization:** Improve file structure and follow clean architecture principles

### 7.5 Testing Strategy
*   **Integration Tests:** Implement high-level tests to ensure overall app stability
*   **Unit Tests:** Add comprehensive unit tests for new components and refactored code
*   **Test Coverage:** Ensure adequate test coverage for critical functionality

## 8. Future Enhancements

*   **Direct Messaging:** Allow users to communicate with teachers and organizers directly within the app.
*   **Social Feed:** A community feed where users can share photos, videos, and updates.
*   **Offline Mode:** Allow users to access bookmarked event details even without an internet connection.
*   **Advanced Analytics for Creators:** Provide more detailed insights into booking trends and audience demographics.
