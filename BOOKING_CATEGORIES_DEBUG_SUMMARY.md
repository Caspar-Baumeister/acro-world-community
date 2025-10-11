# Booking Categories & Tickets Issue - Debug Summary

**Date:** October 10, 2025  
**Status:** 🔍 **DEBUGGING IN PROGRESS**

---

## 🐛 Problem Description

When creating a new event from an existing template:
- ✅ Categories load correctly
- ❌ **Only 1 category visible** (should show all categories)
- ❌ **Tickets don't show** under the category
- ❌ **Cannot click "Add Ticket"** button (likely because `categoryId` is null)

---

## 🔍 Root Cause Analysis

### **The Problem: Mismatched Category IDs**

#### **What Happens:**

1. **Template Loading** (`event_creation_coordinator_provider.dart` lines 158-197):
   ```dart
   for (final category in classModel.bookingCategories!) {
     // Create new category with ID = null (for template)
     final copiedCategory = BookingCategoryModel(
       id: null,  // ✅ Correct - clear ID for new event
       name: category.name,
       contingent: category.contingent,
     );
     
     // Create options BUT keep the OLD category ID!
     for (final option in category.bookingOptions!) {
       final copiedOption = BookingOption(
         id: null,  // ✅ Correct - clear ID
         bookingCategoryId: category.id,  // ❌ WRONG! Uses OLD ID
         //                   ^^^^^^^^^^^^
         // This is the ORIGINAL category ID from the template event!
       );
     }
   }
   ```

2. **Display Logic** (`category_creation_card.dart` line 169):
   ```dart
   // Filter options by category ID
   bookingState.bookingOptions
     .where((option) => option.bookingCategoryId == bookingCategory.id)
     //                                             ^^^^^^^^^^^^^^^^^^
     //                                             This is NULL!
   ```

3. **The Mismatch:**
   ```
   Category (from template):
   ├─ copiedCategory.id = null ❌
   └─ Options looking for: null
   
   Options (from template):
   ├─ option.bookingCategoryId = "old-uuid-123" ❌
   └─ Looking for category: "old-uuid-123"
   
   Result: null ≠ "old-uuid-123" → NO MATCH! 💥
   ```

---

## 🎯 Why This Breaks

### **Scenario: Create from Existing Event**

**Original Event:**
```
Category: "Early Bird" (ID: "abc-123")
├─ Ticket: "Full Pass" (CategoryID: "abc-123") → ✅ Match
└─ Ticket: "One Day" (CategoryID: "abc-123")   → ✅ Match
```

**After Template Copy:**
```
Category: "Early Bird" (ID: null)               ← New category, no ID yet
├─ Ticket: "Full Pass" (CategoryID: "abc-123") → ❌ Looking for "abc-123"
└─ Ticket: "One Day" (CategoryID: "abc-123")   → ❌ Looking for "abc-123"

Filter: option.bookingCategoryId == null
Result: "abc-123" ≠ null → NO TICKETS DISPLAYED! 💥
```

### **Why "Add Ticket" Button Doesn't Work:**

```dart
// In category_creation_card.dart line 230:
AddOrEditBookingOptionModal(
  categoryID: bookingCategory.id!,  // ❌ bookingCategory.id is NULL!
  //                              ↑ Null assertion fails or passes null
)
```

---

## 🔧 The Fix

### **Option 1: Generate Temporary IDs** (Recommended)

When copying categories, generate temporary UUIDs that booking options can reference:

```dart
// In event_creation_coordinator_provider.dart
import 'package:uuid/uuid.dart';

for (final category in classModel.bookingCategories!) {
  // Generate a temporary ID for this category
  final tempCategoryId = const Uuid().v4();
  
  final copiedCategory = BookingCategoryModel(
    id: tempCategoryId,  // ✅ Use temp ID instead of null
    name: category.name,
    contingent: category.contingent,
  );
  
  for (final option in category.bookingOptions!) {
    final copiedOption = BookingOption(
      id: null,
      bookingCategoryId: tempCategoryId,  // ✅ Reference the temp ID
      //                 ^^^^^^^^^^^^^^^
      // Now options can find their category!
    );
  }
}
```

### **Option 2: Use Index-Based Mapping**

Map options to categories by index instead of ID:

```dart
// Store category index in bookingOption
// Then filter by index instead of ID
```

**Option 1 is cleaner and more robust.**

---

## 📊 Debug Output Added

### **Files with Debug Prints:**

1. **`event_creation_coordinator_provider.dart`** (lines 155-200)
   - Logs each category being copied
   - Logs each option being copied
   - Shows the ID mismatch problem

2. **`event_booking_provider.dart`** (lines 171-196)
   - Logs what data is received in setFromTemplate
   - Shows all categories and options with their IDs
   - Confirms state update

3. **`category_creation_card.dart`** (lines 37-48)
   - Logs category ID being displayed
   - Logs all options and their category IDs
   - Shows why filtering fails

---

## 🧪 How to Debug

### **Run the App and:**

1. Go to "My Events"
2. Click "Create Event from Existing"
3. Select an event that has categories and tickets
4. Navigate to the last step (Market/Booking)
5. Check console output:

**Expected Output:**
```
🎟️ BOOKING DEBUG - Starting to copy booking categories...
🎟️ BOOKING DEBUG - classModel.bookingCategories: 2
🎟️ BOOKING DEBUG - Processing category: Early Bird
🎟️ BOOKING DEBUG - Category ID (original): abc-123-old-uuid
🎟️ BOOKING DEBUG - Category has 2 options
🎟️ BOOKING DEBUG - Created copied category with ID: null  ← PROBLEM!
🎟️ BOOKING DEBUG - Processing option: Full Pass
🎟️ BOOKING DEBUG - Option bookingCategoryId (original): abc-123-old-uuid
🎟️ BOOKING DEBUG - Created copied option with bookingCategoryId: abc-123-old-uuid  ← PROBLEM!

🎟️ PROVIDER DEBUG - setFromTemplate called
🎟️ PROVIDER DEBUG - Category 0: Early Bird (ID: null, ...)  ← NULL!
🎟️ PROVIDER DEBUG - Option 0: Full Pass (CategoryID: abc-123-old-uuid, ...)  ← OLD ID!

🎟️ CARD DEBUG - bookingCategory.id: null  ← NULL!
🎟️ CARD DEBUG - Option: Full Pass, CategoryID: abc-123-old-uuid, Matches: false  ← NO MATCH!
```

---

## ✅ Next Steps

1. ✅ **Added debug prints** to trace the issue
2. ⏳ **Run app** and verify the debug output confirms this theory
3. ⏳ **Implement fix** (Option 1: Generate temporary UUIDs)
4. ⏳ **Test** that categories and tickets load correctly
5. ⏳ **Remove debug prints** after fix is confirmed

---

## 📝 Summary

**Issue:** Category IDs are set to `null` during template copy, but booking options still reference the original category IDs, causing a mismatch that prevents tickets from being displayed or added.

**Solution:** Generate temporary UUIDs for categories when copying from template, and use those same UUIDs for the booking options' `bookingCategoryId` field.

---

**Debug By:** AI Assistant  
**Date:** October 10, 2025  
**Status:** Debug prints added, ready to test and fix

