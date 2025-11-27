# AcroWorld App Style Guide

This document outlines the official style guide for the AcroWorld mobile and web application to ensure a consistent, professional, and intuitive user interface across all platforms. Adhering to these guidelines supports a clean Flutter architecture by centralizing design tokens and promoting reusability.

## 1. Color Palette

Colors are chosen to be clean, professional, and accessible. They create a clear visual hierarchy and adapt seamlessly between light and dark themes.

### 1.1 Light Theme Colors

| Role | Hex Color | Usage |
| :--- | :--- | :--- |
| Primary | #606c38 | For primary actions, links, and important informational icons. |
| Secondary | #03071e | For secondary actions, links, and important informational icons. |
| Accent | #ffba08 | For primary calls-to-action (e.g., "Book Now" buttons), highlights, and selected states (tabs, filters). |
| Background | #F5F5F5 | The main background color for all screens and pages. |
| Surface / Card | #FFFFFF | Background for cards, modals, forms, and primary content areas to make them stand out. |
| Text (Primary) | #424242 | For all primary text content, including titles, body copy, and labels. |
| Text (Secondary/Muted) | #9E9E9E | For subtitles, helper text, disabled states, and less important information. |
| Borders / Dividers | #E0E0E0 | For subtle separation between elements, like card borders or dividers in lists. |
| Success | #66BB6A | For positive feedback, successful operations, and validation messages. |
| Warning | #FFB300 | For cautionary messages, alerts, or important but non-critical information. |
| Error | #E53935 | For error messages, destructive actions, and invalid input states. |
| Disabled | #BDBDBD | For elements that are temporarily unavailable or inactive. |

### 1.2 Dark Theme Colors

| Role | Hex Color | Usage |
| :--- | :--- | :--- |
| Primary | #606c38 | For primary actions, links, and important informational icons. |
| Secondary | #03071e | For secondary actions, links, and important informational icons. |
| Accent | #ffba08 | For primary calls-to-action (e.g., "Book Now" buttons), highlights, and selected states (tabs, filters). |
| Background | #212121 | The main background color for all screens and pages. |
| Surface / Card | #424242 | Background for cards, modals, forms, and primary content areas to make them out. |
| Text (Primary) | #FFFFFF | For all primary text content, including titles, body copy, and labels. |
| Text (Secondary/Muted) | #BDBDBD | For subtitles, helper text, disabled states, and less important information. |
| Borders / Dividers | #616161 | For subtle separation between elements, like card borders or dividers in lists. |
| Success | #81C784 | For positive feedback, successful operations, and validation messages. |
| Warning | #FFD54F | For cautionary messages, alerts, or important but non-critical information. |
| Error | #EF5350 | For error messages, destructive actions, and invalid input states. |
| Disabled | #757575 | For elements that are temporarily unavailable or inactive. |

## 2. Typography

A consistent typography scale ensures readability and visual hierarchy. We use a sans-serif font family (e.g., Roboto, Open Sans) for all text.

### 2.1 Font Sizes (in dp/pt)

| Role | Size | Weight | Usage |
| :--- | :--- | :--- | :--- |
| Display Large | 57 | Regular | Large, prominent headings for key screens or sections. |
| Display Medium | 45 | Regular | Secondary large headings. |
| Display Small | 36 | Regular | Smaller display headings. |
| Headline Large | 32 | Medium | Main headings for content blocks. |
| Headline Medium | 28 | Medium | Sub-headings for content blocks. |
| Headline Small | 24 | Medium | Smaller sub-headings. |
| Title Large | 22 | Regular | Important titles within components (e.g., card titles). |
| Title Medium | 16 | Medium | Sub-titles or emphasized text. |
| Title Small | 14 | Medium | Small titles or emphasized text. |
| Body Large | 16 | Regular | Primary body text. |
| Body Medium | 14 | Regular | Secondary body text, default for most content. |
| Body Small | 12 | Regular | Fine print, captions, or less important information. |
| Label Large | 14 | Medium | Button labels, tab labels, or other interactive elements. |
| Label Medium | 12 | Medium | Smaller labels. |
| Label Small | 11 | Medium | Very small labels. |

### 2.2 Font Weights

- **Regular (400):** Standard text.
- **Medium (500):** Slightly bolder, for emphasis.
- **Semi-Bold (600):** Stronger emphasis, for important titles.
- **Bold (700):** Strongest emphasis, for critical information.

## 3. Spacing and Layout

Consistent spacing creates visual rhythm and improves readability. We follow a 4-point grid system.

### 3.1 Padding and Margins

| Role | Value (dp) | Usage |
| :--- | :--- | :--- |
| Tiny Spacing | 4 | Smallest spacing, for tight elements or internal component padding. |
| Small Spacing | 8 | Standard small spacing, for elements within a group. |
| Medium Spacing | 16 | Standard spacing between major UI elements. |
| Large Spacing | 24 | Larger spacing for section separation. |
| Extra Large Spacing | 32 | Largest spacing, for significant content breaks. |

### 3.2 Component Dimensions

| Role | Value (dp) | Usage |
| :--- | :--- | :--- |
| Icon Small | 16 | Smallest icons (e.g., within text, minor indicators). |
| Icon Medium | 24 | Standard icon size. |
| Icon Large | 32 | Larger icons (e.g., in app bars, prominent features). |
| Button Height (Standard) | 48 | Fixed height for most interactive buttons. |
| Input Field Height (Standard) | 56 | Fixed height for text input fields. |
| Card Elevation | 2-8 | Standard shadow depth for cards, increasing with importance. |
| Modal Controller Width | 60 | Width of the drag handle for bottom sheet modals. |
| Modal Controller Height | 4 | Height of the drag handle for bottom sheet modals. |
| Event Vertical Scroll Card Height | 120 | Height of event cards in vertical scroll lists. |
| Event Dashboard Slider Width | 200 | Width of event cards in horizontal dashboard sliders. |

## 4. Roundness / Border Radius

Consistent use of rounded corners provides a soft, modern aesthetic.

| Role | Value (dp) | Usage |
| :--- | :--- | :--- |
| Small Radius | 4 | Subtle rounding for small elements (e.g., chips, small buttons). |
| Medium Radius | 8 | Standard rounding for cards, input fields, and most components. |
| Large Radius | 12 | More pronounced rounding for prominent elements or containers. |
| Full Circle | 999 | For perfectly circular elements (e.g., avatars, floating action buttons). |

## 5. Aspect Ratios

Maintaining consistent aspect ratios for images and media ensures visual harmony.

| Role | Ratio (Width:Height) | Usage |
| :--- | :--- | :--- |
| 1:1 | 1:1 | Square images (e.g., avatars, small thumbnails). |
| 16:9 | 16:9 | Wide images (e.g., banners, video players). |
| 4:3 | 4:3 | Standard image ratio for general content. |
| 6:5 | 6:5 | Specific ratio for event cards in dashboard sliders. |

## 6. Icons

We use Material Design Icons for all UI elements. Icons should be clear, simple, and easily recognizable.

- **Size:** Refer to "Component Dimensions" (Icon Small, Icon Medium, Icon Large).
- **Color:** Icons should generally inherit text color or be explicitly set using the color palette (e.g., Primary, Accent, Disabled).

## 7. Buttons

Buttons are designed for clear calls-to-action and consistent interaction.

- **Primary Buttons:** Filled with `Primary` color, white text.
- **Secondary Buttons:** Outlined, transparent background, `Primary` colored text.
- **Text Buttons:** Text only, `Primary` colored text.
- **Floating Action Buttons (FABs):** Circular, `Accent` color, white icon.

## 8. Forms and Input Fields

Input fields should be clear, easy to use, and provide immediate feedback.

- **Borders:** Use `Borders / Dividers` color for outlines.
- **Background:** Use `Surface / Card` color.
- **Text:** Use `Text (Primary)` for input, `Text (Secondary/Muted)` for hints.
- **Error States:** Use `Error` color for borders and helper text.

## 9. Modals and Dialogs

Modals and dialogs provide focused interactions without navigating away from the current context.

- **Background:** Use `Surface / Card` color.
- **Overlay:** A semi-transparent overlay (e.g., `Colors.black.withOpacity(0.5)`) should cover the background content.
- **Border Radius:** Use `Medium Radius`.

## 10. Lists and Tiles

Lists should be clean, scannable, and provide clear separation between items.

- **Dividers:** Use `Borders / Dividers` color for subtle separation.
- **Background:** Use `Background` or `Surface / Card` for list items.

## 11. Shadows and Elevation

Subtle shadows are used to indicate elevation and hierarchy.

- **Standard Shadow:** `Colors.black.withOpacity(0.1)`, blur radius 2, offset (0, 1). Used for most cards and elevated elements.
- **Pronounced Shadow:** `Colors.black.withOpacity(0.2)`, blur radius 5, offset (0, 3). Used for modals or more prominent elements.

## 12. Illustrations and Imagery

- **Style:** Illustrations should be clean, modern, and align with the overall brand aesthetic.
- **Placeholders:** Use simple, geometric shapes or placeholder icons for missing images.
- **Image Loading:** Implement loading indicators for images to improve perceived performance.

## 13. Accessibility

- **Contrast:** Ensure sufficient color contrast for all text and interactive elements.
- **Font Sizes:** Provide options for larger font sizes where appropriate.
- **Tap Targets:** Ensure all interactive elements have a minimum tap target size of 48x48 dp.

## 14. Animations and Transitions

- **Purposeful:** Animations should enhance the user experience, not distract from it.
- **Subtle:** Prefer subtle, fast, and smooth transitions.
- **Consistent:** Use consistent animation curves and durations.

## 15. Error Handling

- **Clear Feedback:** Provide clear, concise, and actionable error messages.
- **Visual Cues:** Use `Error` color for visual indication of errors.
- **Graceful Degradation:** Ensure the app remains usable even when errors occur.

## 16. Internationalization (i18n)

- **Text Externalization:** All user-facing text should be externalized for easy translation.
- **Date/Time Formats:** Use locale-aware date and time formatting.

## 17. Performance

- **Optimization:** Optimize images, reduce unnecessary rebuilds, and minimize complex layouts.
- **Responsiveness:** Ensure the UI remains fluid and responsive across various device sizes and orientations.

## 18. Code Standards

- **Consistency:** Adhere to Flutter's official style guide and project-specific linting rules.
- **Modularity:** Break down UI into reusable widgets and components.
- **Documentation:** Document complex widgets and functions.
- **Testing:** Write unit and widget tests for UI components.