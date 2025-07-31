# Styling and Theming Refactoring Plan

This document outlines a detailed, incremental plan to refactor the application's styling and theming to align with the `Style-Guide.md`. The core principle is to ensure the application remains **runnable and testable after every single step**.

## Recap of previous work

- **Phase 0 & 1**: A new theme structure was created in `lib/theme`, and the app was updated to use it.
- **Phase 2 & 3**: All core components, pages, and sections were refactored to use the new theme.
- **Phase 4 (partially done)**: Non-styling constants were moved to `lib/utils/app_constants.dart`, and old constant files were deleted.

## Current problem

The app is currently not runnable due to errors caused by the theme migration. The main issues are:

- Direct usages of old constants (`CustomColors`, `AppPaddings`, `AppBorders`, etc.) that need to be replaced with the new theme-based equivalents.
- Unused imports and other issues that need to be identified and fixed.

## Plan to solve the errors

I will go through the following files one by one and replace the old constants with their new theme-based equivalents.

### Files with breaking errors:

- `lib/presentation/components/buttons/floating_button.dart`
- `lib/presentation/components/custom_easy_stepper.dart`
- `lib/presentation/components/guest_profile_content.dart`
- `lib/presentation/components/images/custom_avatar_cached_network_image.dart`
- `lib/presentation/components/images/custom_cached_network_image.dart`
- `lib/presentation/components/images/event_image_picker_component.dart`
- `lib/presentation/components/input/custom_option_input_component.dart`
- `lib/presentation/components/like_teacher_mutation_widget.dart`
- `lib/presentation/components/settings_drawer.dart`
- `lib/presentation/components/show_more_text.dart`
- `lib/presentation/components/tiles/event_tiles/class_event_expanded_tile.dart`
- `lib/presentation/components/tiles/event_tiles/widgets/class_tile_next_occurence_widget.dart`
- `lib/presentation/screens/creator_mode_screens/class_occurence_page/class_occurence_body.dart`
- `lib/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_card.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/add_or_edit_recurring_pattern.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/sections/regular_event_tab_view.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_suggestions_query.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/booking_option_creation_card.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/category_creation_card.dart`
- `lib/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_main_content_section.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/checkout_step.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/option_choosing.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/booking_step_indicator.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/header_section.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/widgets/booking_option_widget.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/community/community_query.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/events/components/discovery_filter_on_card.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/events/components/event_card_image_section.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_chip_cards.dart`
- `lib/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings_card.dart`
- `lib/presentation/screens/user_mode_screens/map/components/marker_component.dart`
- `lib/presentation/screens/user_mode_screens/map/components/new_area_component.dart`
- `lib/presentation/screens/user_mode_screens/teacher_profile/screens/profile_base_screen.dart`
- `lib/presentation/shells/sidebar.dart`
- `lib/utils/decorators.dart`
- `lib/utils/helper_functions/custom_pick_date.dart`
- `lib/utils/helper_functions/custom_time_picker.dart`
- `lib/utils/helper_functions/messanges/toasts.dart`

### Step 1: Refactor `lib/presentation/components/buttons/floating_button.dart`

- [x] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.
- [x] Replace `AppDimensions.radiusSmall` with `AppDimensions.radiusMedium`.

### Step 2: Refactor `lib/presentation/components/custom_easy_stepper.dart`

- [ ] Replace `CustomColors.primaryTextColor` with `Theme.of(context).colorScheme.onPrimary`.
- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.primary`.
- [ ] Replace `CustomColors.infoBgColor` with `Theme.of(context).colorScheme.surfaceVariant`.
- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.

### Step 3: Refactor `lib/presentation/components/guest_profile_content.dart`

- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.
- [ ] Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.
- [ ] Replace `CustomColors.primaryTextColor` with `Theme.of(context).colorScheme.onSurface`.
- [ ] Replace `CustomColors.subtitleText` with `Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7)`.
- [ ] Replace `CustomColors.whiteTextColor` with `Theme.of(context).colorScheme.onPrimary`.
- [ ] Replace `CustomColors.buttonPrimaryLight` with `Theme.of(context).colorScheme.secondary`.

### Step 4: Refactor `lib/presentation/components/images/custom_avatar_cached_network_image.dart`

- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surfaceContainer`.
- [ ] Replace `CustomColors.errorTextColor` with `Theme.of(context).colorScheme.error`.

### Step 5: Refactor `lib/presentation/components/images/custom_cached_network_image.dart`

- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surfaceContainer`.
- [ ] Replace `CustomColors.errorTextColor` with `Theme.of(context).colorScheme.error`.

### Step 6: Refactor `lib/presentation/components/images/event_image_picker_component.dart`

- [ ] Replace `CustomColors.inactiveBorderColor` with `Theme.of(context).colorScheme.outline`.
- [ ] Replace `CustomColors.iconColor` with `Theme.of(context).colorScheme.onSurface`.

### Step 7: Refactor `lib/presentation/components/input/custom_option_input_component.dart`

- [ ] Replace `CustomColors.primaryTextColor` with `Theme.of(context).colorScheme.onSurface`.

### Step 8: Refactor `lib/presentation/components/like_teacher_mutation_widget.dart`

- [ ] Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.

### Step 9: Refactor `lib/presentation/components/settings_drawer.dart`

- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.
- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.
- [ ] Replace `CustomColors.errorTextColor` with `Theme.of(context).colorScheme.error`.
- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surfaceContainer`.
- [ ] Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.
- [ ] Replace `CustomColors.primaryTextColor` with `Theme.of(context).colorScheme.onSurface`.
- [ ] Replace `CustomColors.lightTextColor` with `Theme.of(context).colorScheme.onSurface.withOpacity(0.7)`.

### Step 10: Refactor `lib/presentation/components/show_more_text.dart`

- [ ] Replace `CustomColors.linkTextColor` with `Theme.of(context).colorScheme.secondary`.

### Step 11: Refactor `lib/presentation/components/tiles/event_tiles/class_event_expanded_tile.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.

### Step 12: Refactor `lib/presentation/components/tiles/event_tiles/widgets/class_tile_next_occurence_widget.dart`

- [ ] Replace `CustomColors.primaryTextColor` with `Theme.of(context).colorScheme.onSurface`.
- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.

### Step 13: Refactor `lib/presentation/screens/creator_mode_screens/class_occurence_page/class_occurence_body.dart`

- [ ] Replace `CustomColors.successBgColorSec` with `Theme.of(context).colorScheme.primary.withOpacity(0.5)`.
- [ ] Replace `CustomColors.successBgColor` with `Theme.of(context).colorScheme.primary`.
- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surface`.
- [ ] Replace `CustomColors.iconColor` with `Theme.of(context).colorScheme.outline`.

### Step 14: Refactor `lib/presentation/screens/creator_mode_screens/class_occurence_page/components/class_occurence_card.dart`

- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.
- [ ] Replace `CustomColors.successTextColor` with `Theme.of(context).colorScheme.primary`.
- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.
- [ ] Replace `CustomColors.errorTextColor` with `Theme.of(context).colorScheme.error`.

### Step 15: Refactor `lib/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/add_or_edit_recurring_pattern.dart`

- [ ] Replace `CustomColors.errorTextColor` with `Theme.of(context).colorScheme.error`.

### Step 16: Refactor `lib/presentation/screens/creator_mode_screens/create_and_edit_event/add_or_edit_recurring_pattern/sections/regular_event_tab_view.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.

### Step 17: Refactor `lib/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_suggestions_query.dart`

- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.

### Step 18: Refactor `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/booking_option_creation_card.dart`

- [ ] Replace `Theme.of(context).extension<CustomColors>()!.accent` with `Theme.of(context).colorScheme.secondary`.

### Step 19: Refactor `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/category_creation_card.dart`

- [ ] Replace `Theme.of(context).colorScheme.surface` with `Theme.of(context).colorScheme.surfaceContainer`.

### Step 20: Refactor `lib/presentation/screens/creator_mode_screens/main_pages/dashboard_page/components/dashboard_single_booking_card/sections/booking_card_main_content_section.dart`

- [ ] Replace `Theme.of(context).extension<CustomColors>()!.accent` with `Theme.of(context).colorScheme.secondary`.

### Step 21: Refactor `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/checkout_step.dart`

- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surfaceContainer`.
- [ ] Replace `CustomColors.errorBorderColor` with `Theme.of(context).colorScheme.error`.
- [ ] Replace `CustomColors.successBgColor` with `Theme.of(context).colorScheme.primary`.

### Step 22: Refactor `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/option_choosing.dart`

- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surfaceContainer`.
- [ ] Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.
- [ ] Replace `CustomColors.errorTextColor` with `Theme.of(context).colorScheme.error`.
- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.
- [ ] Replace `CustomColors.primaryTextColor` with `Theme.of(context).colorScheme.onSurface`.
- [ ] Replace `CustomColors.successTextColor` with `Theme.of(context).colorScheme.primary`.

### Step 23: Refactor `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/booking_step_indicator.dart`

- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surfaceContainer`.
- [ ] Replace `CustomColors.lightTextColor` with `Theme.of(context).colorScheme.onSurface.withOpacity(0.7)`.

### Step 24: Refactor `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/header_section.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.

### Step 25: Refactor `lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/widgets/booking_option_widget.dart`

- [ ] Replace `CustomColors.successTextColor` with `Theme.of(context).colorScheme.primary`.

### Step 26: Refactor `lib/presentation/screens/user_mode_screens/main_pages/community/community_query.dart`

- [ ] Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.

### Step 27: Refactor `lib/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart`

- [ ] Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.

### Step 28: Refactor `lib/presentation/screens/user_mode_screens/main_pages/events/components/discovery_filter_on_card.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.

### Step 29: Refactor `lib/presentation/screens/user_mode_screens/main_pages/events/components/event_card_image_section.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.
- [ ] Replace `CustomColors.whiteTextColor` with `Theme.of(context).colorScheme.onPrimary`.

### Step 30: Refactor `lib/presentation/screens/user_mode_screens/main_pages/events/filter_page/components/filter_chip_cards.dart`

- [ ] Replace `AppColors.lightGrey` with `Theme.of(context).colorScheme.outline`.

### Step 31: Refactor `lib/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings_card.dart`

- [ ] Replace `AppColors.lightGrey` with `Theme.of(context).colorScheme.outline`.

### Step 32: Refactor `lib/presentation/screens/user_mode_screens/map/components/marker_component.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.
- [ ] Replace `CustomColors.iconColor` with `Theme.of(context).colorScheme.onSurface`.

### Step 33: Refactor `lib/presentation/screens/user_mode_screens/map/components/new_area_component.dart`

- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.

### Step 34: Refactor `lib/presentation/screens/user_mode_screens/teacher_profile/screens/profile_base_screen.dart`

- [ ] Replace `CustomColors.primaryColor` with `Theme.of(context).colorScheme.primary`.

### Step 35: Refactor `lib/presentation/shells/sidebar.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.

### Step 36: Refactor `lib/utils/decorators.dart`

- [ ] Replace `CustomColors.inactiveBorderColor` with `Theme.of(context).colorScheme.outline`.
- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.

### Step 37: Refactor `lib/utils/helper_functions/custom_pick_date.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.
- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.

### Step 38: Refactor `lib/utils/helper_functions/custom_time_picker.dart`

- [ ] Replace `CustomColors.accentColor` with `Theme.of(context).colorScheme.secondary`.
- [ ] Replace `CustomColors.backgroundColor` with `Theme.of(context).colorScheme.surface`.
- [ ] Replace `CustomColors.secondaryBackgroundColor` with `Theme.of(context).colorScheme.surfaceContainer`.
- [ ] Replace `CustomColors.whiteTextColor` with `Theme.of(context).colorScheme.onPrimary`.
- [ ] Replace `CustomColors.primaryTextColor` with `Theme.of(context).colorScheme.onSurface`.

### Step 39: Refactor `lib/utils/helper_functions/messanges/toasts.dart`

- [ ] Replace `CustomColors.successBgColor` with `Theme.of(context).colorScheme.primary`.
- [ ] Replace `CustomColors.whiteTextColor` with `Theme.of(context).colorScheme.onPrimary`.
- [ ] Replace `CustomColors.errorTextColor` with `Theme.of(context).colorScheme.error`.
- [ ] Replace `CustomColors.infoBgColor` with `Theme.of(context).colorScheme.surfaceVariant`.

### Step 40: Code Analysis

- [ ] Run `flutter analyze` to find and remove all unused imports.

### Step 41: Final Review

- [ ] Final review of the new theme files for consistency and completeness.