# Styling and Theming Refactoring Plan

This plan outlines incremental steps to refactor the application's styling and theming, aiming for a clean, readable, and scalable architecture. Each step is designed to leave the application in a runnable state, minimizing disruption.

## Core Principles:

*   **Single Source of Truth**: All styling (colors, typography, dimensions) will be defined in a centralized theme.
*   **Thematic Consistency**: Components will consistently retrieve styling information from `Theme.of(context)`.
*   **Clear Naming Conventions**: Constants will follow a logical and predictable naming scheme.
*   **Incremental Changes**: Each step is small and verifiable, ensuring the app remains functional.

## Phase 1: Consolidate Theme Definitions

The primary goal of this phase is to merge the two existing theme definitions (`lib/presentation/theme.dart` and `lib/utils/theme.dart`) into a single, authoritative theme. We will choose `lib/presentation/theme.dart` as the canonical source due to its more modern `ThemeExtension` approach.

### Step 1.1: Migrate `AppTextStyles` and `AppTextTheme` to `lib/presentation/theme.dart`

**Description**: Move the `AppTextStyles` and `AppTextTheme` classes from `lib/constants/app_text_styles.dart` and `lib/constants/app_text_theme.dart` into `lib/presentation/theme.dart`. This centralizes typography definitions.

**Files Involved**:
*   `lib/presentation/theme.dart`
*   `lib/constants/app_text_styles.dart`
*   `lib/constants/app_text_theme.dart`
*   `lib/constants/constants.dart` (to remove exports)

**Changes**:
1.  **Open `lib/presentation/theme.dart`**:
    *   Add the content of `AppTextStyles` and `AppTextTheme` classes directly into this file.
    *   Ensure all necessary imports (e.g., `package:flutter/material.dart`, `package:acroworld/constants/app_colors.dart`) are present at the top of `lib/presentation/theme.dart`.
    *   Modify the `AppTheme._buildTheme` method to use the newly moved `AppTextTheme.getTextTheme`.
2.  **Open `lib/constants/constants.dart`**:
    *   Remove the `export 'app_text_styles.dart';` and `export 'app_text_theme.dart';` lines.
3.  **Delete Old Files**:
    *   Delete `lib/constants/app_text_styles.dart`.
    *   Delete `lib/constants/app_text_theme.dart`.

**Verification**: Run the app. There might be minor compilation errors related to imports, which should be straightforward to fix by adjusting `import` statements in files that previously relied on the deleted files. The app should launch and function as before.

### Step 1.2: Migrate `MyThemes` to `lib/presentation/theme.dart`

**Description**: Move the `MyThemes` class from `lib/utils/theme.dart` into `lib/presentation/theme.dart`. This eliminates the redundant theme definition.

**Files Involved**:
*   `lib/presentation/theme.dart`
*   `lib/utils/theme.dart`
*   `lib/router_app.dart`
*   `lib/utils/text_constants.dart` (to remove imports)

**Changes**:
1.  **Open `lib/presentation/theme.dart`**:
    *   Copy the `MyThemes` class (including `lightTheme` and `darkTheme` static members) into this file.
    *   Rename `MyThemes` to `AppThemes` to avoid naming conflicts and align with the existing `AppTheme` class.
    *   Adjust any internal references within `AppThemes` to use the `AppTheme.light()` and `AppTheme.dark()` methods.
2.  **Open `lib/router_app.dart`**:
    *   Change `import 'package:acroworld/utils/theme.dart';` to `import 'package:acroworld/presentation/theme.dart';`.
    *   Update `MyThemes.lightTheme` to `AppThemes.lightTheme`.
3.  **Open `lib/utils/theme.dart`**:
    *   Delete the entire file.
4.  **Open `lib/utils/text_constants.dart`**:
    *   Remove `import 'package:acroworld/utils/colors.dart';` and `import 'package:flutter_html/flutter_html.dart';` if they are no longer used after `MyThemes` is moved.

**Verification**: Run the app. Address any compilation errors related to `MyThemes` or `AppThemes` by ensuring all references point to the new location and name. The app should launch and function as before.

## Phase 2: Standardize Color Usage

This phase focuses on ensuring all color references in UI components correctly use the centralized theme.

### Step 2.1: Refactor `CustomColors` direct usage to `Theme.of(context)`

**Description**: Replace direct static calls to `CustomColors.someColor` with `Theme.of(context).extension<CustomColors>()!.someColor` or, where appropriate, `Theme.of(context).colorScheme.someColor`. This ensures colors are retrieved from the active theme.

**Files Involved (Examples)**:
*   `lib/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart`
*   `lib/presentation/components/buttons/floating_button.dart`
*   `lib/presentation/components/buttons/standart_button.dart`
*   `lib/presentation/components/custom_check_box.dart`
*   `lib/presentation/components/custom_easy_stepper.dart`
*   `lib/presentation/components/input/custom_option_input_component.dart`
*   `lib/presentation/components/input/input_field_component.dart`
*   `lib/presentation/components/like_teacher_mutation_widget.dart`
*   `lib/presentation/components/images/custom_avatar_cached_network_image.dart`
*   `lib/presentation/components/images/custom_cached_network_image.dart`
*   `lib/presentation/components/images/event_image_picker_component.dart`
*   `lib/presentation/components/show_more_text.dart`
*   `lib/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart`
*   `lib/presentation/screens/authentication_screens/sign_in/sign_in.dart`
*   `lib/presentation/screens/authentication_screens/signup_screen/sign_up.dart`
*   `lib/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_card.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/booking_option_creation_card.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/category_creation_card.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_status_tile.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/invites_page/invites_body.dart`
*   `lib/presentation/screens/single_class_page/single_class_body.dart`
*   `lib/presentation/screens/single_class_page/widgets/booking_query_wrapper.dart`
*   `lib/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/main_booking_modal.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/checkout_step.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/option_choosing.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/widgets/booking_option_widget.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/classes/classes_view.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/events/components/discover_appbar.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/events/components/discovery_slider_card.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_chip_cards.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart`
*   `lib/presentation/screens/user_mode_screens/map/components/map_app_bar.dart`
*   `lib/presentation/screens/user_mode_screens/map/components/marker_component.dart`
*   `lib/presentation/shells/sidebar.dart`
*   `lib/utils/decorators.dart`
*   `lib/utils/text_constants.dart`

**Changes (Example for `primary_bottom_navbar_item.dart`)**:
1.  **Open `lib/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart`**:
    *   Change `import 'package:acroworld/utils/colors.dart';` to `import 'package:acroworld/presentation/theme.dart';` (assuming `CustomColors` is now part of `lib/presentation/theme.dart`).
    *   Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.
    *   Replace `CustomColors.inactiveBorderColor` with `Theme.of(context).extension<CustomColors>()!.inactiveBorderColor` (or a suitable `colorScheme` property if it exists).
    *   Replace `CustomColors.iconColor` with `Theme.of(context).iconTheme.color`.

**Verification**: After modifying each file (or a small group of related files), run the app and visually inspect the affected components to ensure colors are rendered correctly.

### Step 2.2: Refactor hardcoded `Colors.someColor` to `Theme.of(context)`

**Description**: Systematically go through all UI components and replace hardcoded `Colors.red`, `Colors.black`, `Colors.white`, etc., with appropriate `Theme.of(context).colorScheme` properties (e.g., `Theme.of(context).colorScheme.error`, `Theme.of(context).colorScheme.onSurface`, `Theme.of(context).colorScheme.surface`).

**Files Involved (Examples)**:
*   `lib/presentation/components/buttons/back_button.dart`
*   `lib/presentation/components/custom_sliver_app_bar.dart`
*   `lib/presentation/components/users/user_list_item.dart`
*   `lib/presentation/screens/account_settings/account_settings_page.dart`
*   `lib/presentation/screens/account_settings/delete_account.dart`
*   `lib/presentation/screens/authentication_screens/forgot_password_screen/forgot_password.dart`
*   `lib/presentation/screens/authentication_screens/forgot_password_success_screen/forgot_password_success.dart`
*   `lib/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_card.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/modals/ask_question_modal.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_create_stripe_account_section.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_main_content_section.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/profile/profile_body.dart`
*   `lib/presentation/screens/single_class_page/single_class_body.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_event_tile_image.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_teacher_chips.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/community/community_app_bar.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/profile/profile_page.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings_card.dart`
*   `lib/presentation/screens/user_mode_screens/teacher_profile/screens/profile_base_screen.dart`
*   `lib/utils/theme.dart` (if any hardcoded colors remain after previous steps)

**Changes (Example for `back_button.dart`)**:
1.  **Open `lib/presentation/components/buttons/back_button.dart`**:
    *   Replace `const BackButton(color: Colors.black);` with `BackButton(color: Theme.of(context).iconTheme.color);`.

**Verification**: After each change, run the app and verify the color changes. This will be a continuous process of small adjustments and checks.

## Phase 3: Standardize Dimension Usage

This phase focuses on using theme-defined dimensions for padding, margins, and sizes.

### Step 3.1: Refactor `AppDimensions` and `AppPaddings` direct usage

**Description**: Replace direct static calls to `AppDimensions.someDimension` and `AppPaddings.somePadding` with values retrieved from the theme. This might involve creating a custom `ThemeExtension` for dimensions if `Theme.of(context).textTheme` or other existing theme properties are insufficient.

**Files Involved (Examples)**:
*   `lib/presentation/components/bottom_navbar/base_bottom_navbar.dart`
*   `lib/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart`
*   `lib/presentation/components/buttons/custom_icon_button.dart`
*   `lib/presentation/components/buttons/floating_button.dart`
*   `lib/presentation/components/custom_easy_stepper.dart`
*   `lib/presentation/components/custom_sliver_app_bar.dart`
*   `lib/presentation/components/images/custom_avatar_cached_network_image.dart`
*   `lib/presentation/components/images/event_image_picker_component.dart`
*   `lib/presentation/components/input/custom_option_input_component.dart`
*   `lib/presentation/components/input/input_field_component.dart`
*   `lib/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart`
*   `lib/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_card.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/sections/regular_event_tab_view.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/sections/single_occurence_tab_view.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_option.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_search_teacher_input_field.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/booking_option_creation_card.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_main_content_section.dart`
*   `lib/presentation/screens/single_class_page/single_class_body.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_teacher_chips.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/events/components/discovery_slider_card.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart`
*   `lib/presentation/screens/user_mode_screens/map/map_page.dart`

**Changes (Example for `primary_bottom_navbar_item.dart`)**:
1.  **Open `lib/presentation/components/bottom_navbar/primary_bottom_navbar_item.dart`**:
    *   Replace `AppDimensions.iconSizeMedium` with a theme-based equivalent. If a custom `AppDimensions` extension is created, it would be `Theme.of(context).extension<AppDimensions>()!.iconSizeMedium`. Otherwise, consider if `Theme.of(context).iconTheme.size` or a fixed value is appropriate.
    *   Replace `AppPaddings.small` and `AppPaddings.tiny` with `Theme.of(context).spacing.small` (if a spacing extension is added) or directly use `Theme.of(context).padding.small` (if a padding extension is added).

**Verification**: After each change, run the app and visually inspect the layout and sizing of components.

### Step 3.2: Rename inconsistent dimension constants

**Description**: Rename constants in `lib/constants/app_dimensions.dart` to follow a more consistent and readable pattern (e.g., `smallPadding` to `paddingSmall`, `sHeighSbox` to `spacingHeightSmall`). This will require a global find-and-replace for each renamed constant.

**Files Involved**:
*   `lib/constants/app_dimensions.dart`
*   All files that import and use constants from `lib/constants/app_dimensions.dart`.

**Changes (Example for `app_dimensions.dart` and its usages)**:
1.  **Open `lib/constants/app_dimensions.dart`**:
    *   Rename `smallPadding` to `paddingSmall`.
    *   Rename `specialSPadding` to `paddingExtraSmall`.
    *   Rename `specialmediumPadding` to `paddingMediumExtra`.
    *   Rename `mxMPadding` to `paddingMediumLarge`.
    *   Rename `xMediumPadding` to `paddingLarge`.
    *   Rename `trackWidthCalculPadding` to `paddingExtraLarge`.
    *   Rename `largePadding` to `paddingHuge`.
    *   Rename `extraLargePadding` to `paddingMassive`.
    *   Apply similar renaming for `sHeighSbox`, `smHeighSbox`, `mHeighSbox`, `specialSwitchWidthSbox`, `xxsWidthSbox`, `XLWidthSbox`, `smallRadius`, `specialsmallRadius`, `mediumRadius`, `largeRadius`, `noElevation`, `sElevation`, `elevation`, `mElevation`, `buttonHeight`, `appBarHeight`, `iconSmall`, `iconMedium`, `iconLarge`, `iconSpecialLarge`, `iconSpecialDialogLarge`, `classicFontSize`.
2.  **Globally Find and Replace**: For each renamed constant, perform a global find-and-replace operation across the entire codebase. For example, replace all occurrences of `AppDimensions.smallPadding` with `AppDimensions.paddingSmall`.

**Verification**: This is a high-risk step. After renaming each constant and performing the global replace, immediately run the app and thoroughly test all affected UI elements to ensure no layout or sizing issues have been introduced.

## Phase 4: Standardize Text Style Usage

This phase ensures all text styles are consistently applied through `Theme.of(context).textTheme`.

### Step 4.1: Refactor direct `TextStyle` definitions to `Theme.of(context).textTheme`

**Description**: Identify instances where `TextStyle` objects are directly defined within widgets (e.g., `const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)`) and replace them with appropriate `Theme.of(context).textTheme` properties (e.g., `Theme.of(context).textTheme.headlineMedium`). Use `.copyWith()` only for minor overrides.

**Files Involved (Examples)**:
*   `lib/presentation/components/appbar/custom_appbar_simple.dart`
*   `lib/presentation/components/bottom_navbar/bottom_navigation_bar.dart`
*   `lib/presentation/components/buttons/link_button.dart`
*   `lib/presentation/components/buttons/loading_button.dart`
*   `lib/presentation/components/buttons/standart_button.dart`
*   `lib/presentation/components/input/input_field_component.dart`
*   `lib/presentation/components/like_teacher_mutation_widget.dart`
*   `lib/presentation/components/show_more_text.dart`
*   `lib/presentation/screens/account_settings/delete_account.dart`
*   `lib/presentation/screens/authentication_screens/confirm_email/confirm_email_page.dart`
*   `lib/presentation/screens/authentication_screens/sign_in/sign_in.dart`
*   `lib/presentation/screens/authentication_screens/signup_screen/sign_up.dart`
*   `lib/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/class_booking_summary_body.dart`
*   `lib/presentation/screens/creator_mode_screens/class_booking_summary_page/sections/model_pie_chart.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/sections/regular_event_tab_view.dart`
*   `lib/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart`
*   `lib/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_status_tile.dart`
*   `lib/presentation/screens/single_class_page/single_class_page.dart`
*   `lib/presentation/screens/single_class_page/widgets/custom_bottom_hover_button.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/booking_step_indicator.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/header_section.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/community/community_app_bar.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/events/components/discover_appbar.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/events/components/discovery_slider_card.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_chip_cards.dart`
*   `lib/presentation/screens/user_mode_screens/main_pages/profile/profile_body.dart`
*   `lib/presentation/screens/user_mode_screens/teacher_profile/screens/profile_base_screen.dart`
*   `lib/presentation/screens/user_mode_screens/teacher_profile/widgets/profile_header_widget.dart`
*   `lib/utils/decorators.dart`

**Changes (Example for `custom_appbar_simple.dart`)**:
1.  **Open `lib/presentation/components/appbar/custom_appbar_simple.dart`**:
    *   Replace `Text(title ?? "", style: Theme.of(context).textTheme.titleLarge)` with `Text(title ?? "", style: Theme.of(context).textTheme.headlineSmall)`. (Adjust to the most semantically appropriate text style from the theme).

**Verification**: After each change, run the app and visually inspect the text styles. Pay close attention to font sizes, weights, and colors.

## Phase 5: Clean Up and Refine

### Step 5.1: Remove `lib/utils/colors.dart`

**Description**: After all color references have been migrated to the theme, the `lib/utils/colors.dart` file should be empty or only contain redundant definitions. Delete this file.

**Files Involved**:
*   `lib/utils/colors.dart`
*   All files that import `lib/utils/colors.dart` (remove the import).

**Verification**: Ensure no compilation errors arise from missing color definitions.

### Step 5.2: Remove `lib/utils/constants.dart`

**Description**: After all dimension and other constants have been migrated or refactored, the `lib/utils/constants.dart` file should be empty or only contain redundant definitions. Delete this file.

**Files Involved**:
*   `lib/utils/constants.dart`
*   All files that import `lib/utils/constants.dart` (remove the import).

**Verification**: Ensure no compilation errors arise from missing constant definitions.

### Step 5.3: Review and Refine `lib/presentation/theme.dart`

**Description**: Perform a final review of `lib/presentation/theme.dart` to ensure it is clean, well-organized, and contains all necessary styling definitions. Remove any unused or redundant properties.

**Files Involved**:
*   `lib/presentation/theme.dart`

**Changes**:
1.  Review `CustomColors` and `AppTheme` classes.
2.  Remove any unused color properties from `CustomColors`.
3.  Ensure all `TextStyle` definitions are consistent and correctly applied.
4.  Add comments where necessary to explain design decisions.

**Verification**: Thoroughly test the entire application to ensure all styling is consistent and correct.

This plan provides a detailed roadmap for refactoring your app's styling. Remember to commit frequently after each successful small step to maintain a stable codebase.
