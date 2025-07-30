# Styling and Theming Refactoring Plan

This document outlines a detailed, incremental plan to refactor the application's styling and theming to align with the `Style-Guide.md`. The core principle is to ensure the application remains **runnable and testable after every single step**.

## Core Principles:

- **Incremental Migration**: Changes are broken down into the smallest possible, verifiable steps.
- **No Downtime**: The application must compile and run without errors after each step.
- **Single Source of Truth**: All styling (colors, typography, dimensions) will eventually be defined in a centralized theme.
- **Thematic Consistency**: Components will consistently retrieve styling information from `Theme.of(context)`.

---

## TODO

### Phase 0: Preparation - Create New Theme Structure
- [x] Create `lib/theme/` directory.
- [x] Create `lib/theme/app_theme.dart` with placeholder `ThemeData`.
- [x] Create `lib/theme/app_colors.dart` with the color palette from the style guide.
- [x] Create `lib/theme/app_dimensions.dart` with spacing and size constants from the style guide.
- [x] Create `lib/theme/app_text_styles.dart` with font styles from the style guide (without color).

### Phase 1: Consolidate Theme Definitions
- [x] Populate `lib/theme/app_theme.dart` with `ThemeData` for light and dark modes, using the new theme files.
- [x] Update `router_app.dart` to use the new `AppTheme`.
- [x] Visually verify that the app's appearance is consistent with the previous version.

### Phase 2: Refactor Core Components
- [x] Refactor `AppBar` components (`BaseAppbar`, `CustomAppbarSimple`, `StandardAppBar`).
- [x] Refactor `BottomNavigationBar` components (`BaseBottomNavigationBar`, `BBottomNavigationBar`, `PrimaryBottomNavbarItem`, `ShellBottomNavigationBar`, `ShellCreatorBottomNavigationBar`).
- [x] Refactor all `Button` components (`StandartButton`, `LoadingButton`, `LinkButtonComponent`, etc.).
- [x] Refactor `InputFieldComponent`.
- [x] Refactor `CustomCheckBox`.
- [x] Refactor `CustomDivider`.

### Phase 3: Refactor Pages and Sections
- **Authentication Screens**
    - [x] Refactor `Authenticate` screen.
    - [x] Refactor `SignIn` screen.
    - [x] Refactor `SignUp` screen and its widgets.
    - [x] Refactor `ForgotPassword` screen.
    - [x] Refactor `ForgotPasswordSuccess` screen.
    - [x] Refactor `ConfirmEmailPage`.
- **User Mode Screens**
    - **Events**
        - [ ] Refactor `DiscoverPage` and `DiscoverBody`.
        - [ ] Refactor `DiscoveryAppBar`.
        - [ ] Refactor `FilterOnDiscoveryBody`.
        - [ ] Refactor `SliderRowDashboardDiscovery`.
        - [ ] Refactor `DiscoverySliderCard`.
        - [ ] Refactor `FilterPage` and its components.
    - **Activities**
        - [ ] Refactor `ActivitiesPage` and `ActivitiesBody`.
        - [ ] Refactor `CalendarAppBar` and `CalendarComponent`.
        - [ ] Refactor `ClassesView` and `ClassEventExpandedTile`.
    - **Community**
        - [ ] Refactor `TeacherPage` and `CommunityBody`.
        - [ ] Refactor `TeacherAppBar`.
        - [ ] Refactor `TeacherCard`.
    - **Profile**
        - [ ] Refactor `ProfilePage` and `ProfileBody`.
        - [ ] Refactor `HeaderWidget`.
        - [ ] Refactor `UserBookings` and `UserBookingsCard`.
        - [ ] Refactor `UserFavoriteClasses` and `ClassTemplateCard`.
    - **Map**
        - [ ] Refactor `MapPage` and its components.
    - **Single Class Page**
        - [ ] Refactor `SingleClassPage` and its components.
        - [ ] Refactor `SingleClassBody`.
        - [ ] Refactor `BookingQueryHoverButton`.
- **Creator Mode Screens**
    - **Dashboard**
        - [ ] Refactor `DashboardPage` and its components.
    - **My Events**
        - [ ] Refactor `MyEventsPage` and its sections.
    - **Invites**
        - [ ] Refactor `InvitesPage` and its components.
    - **Creator Profile**
        - [ ] Refactor `CreatorProfilePage` and its components.
    - **Create/Edit Event**
        - [ ] Refactor `CreateAndEditEventPage` and all its steps and components.
- **Account Settings**
    - [ ] Refactor `AccountSettingsPage`.
    - [ ] Refactor `EditUserdataPage`.
    - [ ] Refactor `DeleteAccount`.
- **System Pages**
    - [ ] Refactor `ErrorPage`.
    - [ ] Refactor `LoadingPage`.
    - [ ] Refactor `VersionToOldPage`.

### Phase 4: Cleanup
- [ ] Perform a global search for any remaining direct usages of old constants.
- [ ] Replace all remaining old constants with `Theme.of(context)` equivalents.
- [ ] Delete `lib/constants/` directory.
- [ ] Delete `lib/utils/colors.dart`.
- [ ] Delete `lib/utils/constants.dart`.
- [ ] Delete `lib/utils/text_constants.dart`.
- [ ] Delete `lib/utils/theme.dart`.
- [ ] Run `flutter analyze` to find and remove all unused imports.
- [ ] Final review of the new theme files for consistency and completeness.