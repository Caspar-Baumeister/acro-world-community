# AcroWorld App Button Migration Plan

This plan outlines a step-by-step process to refactor the button implementations in the AcroWorld application, aligning them with the new `BUTTON-STYLE-GUIDE.md`. The goal is to centralize button logic, improve consistency, and leverage Flutter's Material Design system more effectively.

**Important:** After each step, the application **must** remain runnable. If any errors occur, they must be fixed immediately before proceeding to the next step.

---

## Phase 1: Preparation

### ✅ Step 1.1: Review Existing Button Components

*   **Action:** Familiarize yourself with the current custom button implementations in `lib/presentation/components/buttons/`.
*   **Verification:** Confirm understanding of each button's purpose and implementation details.

### ☐ Step 1.2: Identify Core Material Button Replacements

*   **Action:** Determine which Flutter Material buttons (`ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`) will replace the custom components.
*   **Verification:** Create a mapping of old custom buttons to new Material button types.

---

## Phase 2: Core Button Refactoring

This phase focuses on refactoring the existing custom button components into more idiomatic Flutter Material buttons.

### ✅ Step 2.1: Refactor `BackButtonWidget` to `IconButton`

*   **Action:**
    *   Open `lib/presentation/components/buttons/back_button.dart`.
    *   Replace the `BackButtonWidget` implementation with a direct usage of `IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())`.
    *   Ensure the color is set correctly (e.g., `color: Theme.of(context).iconTheme.color`).
    *   Remove the `back_button.dart` file after all usages are updated.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Navigate to screens that previously used `BackButtonWidget` (e.g., `CustomAppbarSimple`).
    *   Confirm the back button functions correctly and visually matches the style guide.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

### ☐ Step 2.2: Refactor `CustomIconButton` to `IconButton`

*   **Action:**
    *   Open `lib/presentation/components/buttons/custom_icon_button.dart`.
    *   Replace the `CustomIconButton` implementation with a direct usage of `IconButton`.
    *   Ensure `icon` and `onPressed` properties are correctly mapped.
    *   Adjust icon size using `iconSize` property if necessary (e.g., `iconSize: AppDimensions.iconSizeSmall`).
    *   Remove the `custom_icon_button.dart` file after all usages are updated.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Navigate to screens that previously used `CustomIconButton` (e.g., `CategoryCreationCard`).
    *   Confirm all icon buttons function correctly and visually match the style guide.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

### ☐ Step 2.3: Refactor `FramedButton` to `OutlinedButton`

*   **Action:**
    *   Open `lib/presentation/components/buttons/framed_button.dart`.
    *   Replace the `FramedButton` implementation with `OutlinedButton`.
    *   Map `child` to the `OutlinedButton`'s child.
    *   Map `onPressed` to the `OutlinedButton`'s `onPressed`.
    *   Apply the border and `borderRadius` using `OutlinedButton.styleFrom`.
    *   Remove the `framed_button.dart` file after all usages are updated.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Navigate to screens that previously used `FramedButton`.
    *   Confirm the buttons function correctly and visually match the style guide.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

### ☐ Step 2.4: Enhance `StandartButton` to use Material Buttons internally

*   **Action:**
    *   Open `lib/presentation/components/buttons/standart_button.dart`.
    *   Modify `StandartButton` to internally use `ElevatedButton` (for `isFilled = true`) or `OutlinedButton` (for `isFilled = false`).
    *   Map `text`, `icon`, `onPressed`, `loading`, `disabled` properties to the internal Material buttons.
    *   Ensure `buttonFillColor`, `borderColor`, and `textColor` are correctly applied via `ButtonStyle` or `Theme.of(context).colorScheme`.
    *   Keep the loading indicator logic.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Navigate to various screens using `StandartButton` (e.g., authentication, event creation).
    *   Confirm all `StandartButton` instances function correctly and visually match the style guide for both filled and outlined variants.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

### ☐ Step 2.5: Review `LoadingButton` for Redundancy

*   **Action:**
    *   Open `lib/presentation/components/buttons/loading_button.dart`.
    *   Since `StandartButton` now handles loading states, assess if `LoadingButton` is still necessary.
    *   If `LoadingButton` offers no unique functionality beyond `StandartButton`, replace its usages with `StandartButton` and remove `loading_button.dart`.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Confirm any replaced `LoadingButton` instances function correctly.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

---

## Phase 3: App-Wide Button Centralization

This phase involves finding and replacing any ad-hoc button definitions throughout the application with the newly refactored `StandartButton`, `IconButton`, `TextButton`, or `LinkButtonComponent`.

### ☐ Step 3.1: Search for `ElevatedButton` usages

*   **Action:**
    *   Perform a global search for `ElevatedButton` within the `lib/` directory (excluding `lib/presentation/components/buttons/`).
    *   For each instance, replace it with `StandartButton(isFilled: true, ...)` or another appropriate Material button if the context requires it (e.g., `TextButton` for less prominent actions).
    *   Ensure all styling and functionality are preserved.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Test each screen where `ElevatedButton` was replaced.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

### ☐ Step 3.2: Search for `TextButton` usages

*   **Action:**
    *   Perform a global search for `TextButton` within the `lib/` directory (excluding `lib/presentation/components/buttons/`).
    *   For each instance, replace it with `LinkButtonComponent` if it's meant to look like a link, or a standard `TextButton` with explicit styling if it's a regular text button.
    *   Ensure all styling and functionality are preserved.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Test each screen where `TextButton` was replaced.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

### ☐ Step 3.3: Search for `OutlinedButton` usages

*   **Action:**
    *   Perform a global search for `OutlinedButton` within the `lib/` directory (excluding `lib/presentation/components/buttons/`).
    *   For each instance, replace it with `StandartButton(isFilled: false, ...)` or a standard `OutlinedButton` with explicit styling.
    *   Ensure all styling and functionality are preserved.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Test each screen where `OutlinedButton` was replaced.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

### ☐ Step 3.4: Search for `GestureDetector` and `InkWell` wrapping `Text` or `Icon`

*   **Action:**
    *   Perform a global search for `GestureDetector` and `InkWell` that directly wrap `Text` or `Icon` widgets (excluding `lib/presentation/components/buttons/`).
    *   For each instance, assess if it should be an `IconButton`, `TextButton`, or `LinkButtonComponent`.
    *   Replace with the appropriate standardized button component.
    *   Ensure all styling and functionality are preserved.
*   **Verification:**
    *   **STOP HERE.** Run the app manually (`flutter run --flavor dev`).
    *   Test each screen where these replacements were made.
    *   If there are errors, fix them before proceeding. If it looks good, check off this step.

---

## Phase 4: Final Verification and Cleanup

### ☐ Step 4.1: Comprehensive Button Review

*   **Action:** Manually review all screens and interactive elements to ensure all buttons adhere to the `BUTTON-STYLE-GUIDE.md`.
*   **Verification:** Check for correct styling, states (normal, disabled, loading), and functionality.

### ☐ Step 4.2: Remove Obsolete Button Files

*   **Action:** Delete any remaining custom button files in `lib/presentation/components/buttons/` that have been fully replaced (e.g., `back_button.dart`, `custom_icon_button.dart`, `framed_button.dart`, `loading_button.dart`).
*   **Verification:** Ensure the project builds and runs without errors after deletion.

### ☐ Step 4.3: Update Documentation

*   **Action:** Update any internal documentation or READMEs that reference the old button components.
*   **Verification:** Confirm all documentation is up-to-date.
