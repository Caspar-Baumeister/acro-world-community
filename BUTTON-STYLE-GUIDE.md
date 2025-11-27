# AcroWorld App Button Style Guide

This document outlines the official style guide for buttons within the AcroWorld mobile and web application. Consistent button design ensures a clear, intuitive, and accessible user experience, aligning with the overall visual language defined in the main [AcroWorld App Style Guide](Style-Guide.md).

## 1. Principles of Button Design

Buttons are interactive elements that trigger actions. Their design should clearly communicate their purpose and state, guiding users effectively.

*   **Clarity:** The button's text and visual appearance should immediately convey its action.
*   **Consistency:** Buttons should look and behave predictably across the application.
*   **Feedback:** Buttons must provide clear visual feedback for different states (hover, pressed, disabled, loading).
*   **Hierarchy:** Visual prominence should match the importance of the action.
*   **Accessibility:** Buttons must be easily tappable and understandable for all users.

## 2. Button Types

AcroWorld utilizes a set of distinct button types, each serving a specific purpose and visual hierarchy. We primarily leverage Flutter's Material Design buttons, customizing them to fit the AcroWorld aesthetic.

### 2.1 Primary Action Buttons (ElevatedButton)

Used for the most important actions on a screen, drawing maximum attention.

*   **Appearance:** Filled background with `Primary` color, contrasting text.
*   **States:**
    *   **Normal:** `Primary` background, `onPrimary` text.
    *   **Pressed:** Slightly darker `Primary` background, `onPrimary` text.
    *   **Disabled:** `disabledColor` background, `textMuted` text.
    *   **Loading:** Displays a `CircularProgressIndicator` centered, replacing text/icon.
*   **Usage:** Confirmations, form submissions, main calls-to-action (e.g., "Book Now", "Create Event").
*   **Reference (Current Implementation):** `StandartButton` (when `isFilled` is true), `LoadingButton`.

### 2.2 Secondary Action Buttons (OutlinedButton)

Used for important but less prominent actions, or as an alternative to a primary action.

*   **Appearance:** Transparent background, outlined border with `Primary` color, `Primary` colored text.
*   **States:**
    *   **Normal:** Transparent background, `Primary` border, `Primary` text.
    *   **Pressed:** Slightly filled background with `Primary` color (low opacity), `Primary` border, `Primary` text.
    *   **Disabled:** Transparent background, `textMuted` border, `textMuted` text.
    *   **Loading:** Displays a `CircularProgressIndicator` centered, replacing text/icon.
*   **Usage:** "Cancel", "Back", "Edit", or alternative actions.
*   **Reference (Current Implementation):** `StandartButton` (when `isFilled` is false), `FramedButton`.

### 2.3 Text Buttons (TextButton)

Used for less prominent actions, typically within dialogs, cards, or inline with other text. They do not have a background or border.

*   **Appearance:** Text only, `Primary` colored text.
*   **States:**
    *   **Normal:** `Primary` text.
    *   **Pressed:** Slightly darker `Primary` text.
    *   **Disabled:** `textMuted` text.
*   **Usage:** "Learn More", "Dismiss", "Forgot Password".
*   **Reference (Current Implementation):** `LinkButtonComponent`.

### 2.4 Icon Buttons (IconButton)

Used for concise actions represented by an icon.

*   **Appearance:** Icon only.
*   **States:**
    *   **Normal:** `icon` color.
    *   **Pressed:** Slightly darker `icon` color.
    *   **Disabled:** `textMuted` icon.
*   **Usage:** Navigation (back, close), settings, favorites, share.
*   **Reference (Current Implementation):** `CustomIconButton`, `BackButtonWidget`.

### 2.5 Specialized Buttons

These buttons have unique visual or functional requirements that may warrant custom implementations, but should still adhere to general styling principles.

*   **Floating Action Buttons (FABs):** For the primary action on a screen, typically circular and positioned prominently.
    *   **Appearance:** Circular, `Accent` color background, `onPrimary` icon.
    *   **Usage:** "Add New", "Compose".
*   **Custom Content Buttons:** Buttons that contain complex layouts or multiple widgets.
    *   **Appearance:** Flexible, often with custom backgrounds and shadows.
    *   **Usage:** Location pickers, profile cards that act as buttons.
    *   **Reference (Current Implementation):** `FloatingButton`, `PlaceButton`.

## 3. Styling Guidelines

All button styling should be derived from the main [AcroWorld App Style Guide](Style-Guide.md) and implemented using Flutter's `ThemeData` and `ThemeExtension` where appropriate.

### 3.1 Colors

*   **Primary Actions:** `colorScheme.primary` for background, `colorScheme.onPrimary` for text/icon.
*   **Secondary Actions:** `colorScheme.surface` for background, `colorScheme.primary` for border and text/icon.
*   **Text/Link Actions:** `colorScheme.primary` for text.
*   **Disabled State:** `disabledColor` for background, `textMuted` for text/icon.
*   **Error State (e.g., Report Button):** `colorScheme.error` for icon/text, or `colorScheme.error.withOpacity(0.2)` for background.

### 3.2 Typography

Button text should use `textTheme.labelLarge` by default, with adjustments for specific button types as needed. Font weights should align with the [Typography section](Style-Guide.md#2-typography) of the main style guide.

### 3.3 Spacing and Padding

*   **Internal Padding:** Buttons should have consistent internal padding. Refer to `AppDimensions.spacingMedium` for general padding.
*   **Icon-Text Spacing:** A small horizontal space (`AppDimensions.spacingSmall`) should separate icons from text within a button.

### 3.4 Roundness

Buttons should use `AppDimensions.radiusMedium` for their `borderRadius`.

### 3.5 Elevation and Shadows

*   **ElevatedButton:** Should have a subtle shadow (`elevationSmall` or `elevationMedium`).
*   **OutlinedButton/TextButton:** Typically have `elevationNone`.
*   **Specialized Buttons:** May have custom shadows as defined in their specific implementation (e.g., `FloatingButton` uses a `BoxShadow`).

## 4. Button States

Visual feedback for button states is crucial for user experience.

*   **Normal:** Default appearance.
*   **Hover:** Subtle visual change (e.g., slight background color change, border highlight) when a pointer hovers over the button (primarily for web/desktop).
*   **Pressed:** Distinct visual change (e.g., darker background, slight scale down) when the button is tapped or clicked.
*   **Disabled:** Reduced opacity and non-interactive. The `onPressed` callback should be `null`.
*   **Loading:** Replaces the button's content with a `CircularProgressIndicator`. The button should be non-interactive (`IgnorePointer`).

## 5. Usage Guidelines

*   **One Primary Action per Screen:** Limit each screen to one visually prominent primary action button.
*   **Clear Labeling:** Button labels should be concise, action-oriented verbs (e.g., "Save", "Submit", "Add").
*   **Consistency in Placement:** Place similar actions in consistent locations across the app.
*   **Avoid Overuse:** Do not use buttons for purely informational purposes.

## 6. Accessibility

*   **Minimum Tap Target:** All interactive buttons must have a minimum tap target size of 48x48 dp.
*   **Semantic Labels:** Provide meaningful `Semantics` labels for icon-only buttons.
*   **Color Contrast:** Ensure sufficient color contrast between button background and text/icon.

## 7. Recommendations for Refactoring

Based on the current implementation and Material Design best practices:

*   **Consolidate `BackButtonWidget` and `CustomIconButton`:** Replace these with direct usage of Flutter's `IconButton`. The `BlurIconButton` in `CustomSliverAppBar` is a good example of a custom wrapper that adds specific visual effects, but the underlying interaction should still be `IconButton`.
*   **Refactor `FramedButton`:** Replace with `OutlinedButton` and apply the desired border and padding through its `style` property.
*   **Re-evaluate `StandartButton`:** While highly flexible, consider if its core functionality can be achieved by extending `ElevatedButton` or `OutlinedButton` and applying custom styles via `ThemeData` or `ButtonStyle`. This would leverage Flutter's built-in accessibility and interaction behaviors. The loading state management is a good pattern to keep.
*   **Maintain `LinkButtonComponent`:** This component provides a specific visual style (underlined text) that is distinct from standard `TextButton` and is useful for its purpose.
*   **Maintain `FloatingButton` and `PlaceButton`:** These are specialized components that encapsulate more complex layouts and logic beyond simple button interactions. Their custom implementation is justified.
