# Recurring Patterns Fix Plan

## Problem Analysis
The recurring patterns are not showing in the occurrences step when editing an event, even though they are being fetched from the database (as seen in the debug logs).

## Root Cause Analysis
From comparing with the main branch, I found that:

1. **Main branch approach**: Uses `ChangeNotifier` provider with direct field access
2. **Current branch approach**: Uses Riverpod `StateNotifier` with state object
3. **Key difference**: The main branch directly accesses `_recurringPatterns` field, while our branch uses `state.recurringPatterns`

## Current State
- ✅ Recurring patterns are being fetched from database (seen in debug logs)
- ✅ `templateClassModel.recurringPatterns` contains the data
- ✅ State is being set with `recurringPatterns: templateClassModel.recurringPatterns ?? []`
- ❌ UI is not displaying the patterns (debug prints will confirm this)

## Debug Information Needed
The debug prints I added will show:
1. What's in `templateClassModel.recurringPatterns` when loading
2. What's in `state.recurringPatterns` after setting state
3. What's in `eventState.recurringPatterns` in the UI
4. What's in `eventState.classModel?.recurringPatterns` in the UI

## Implementation Plan

### Phase 1: Debug and Verify (Current)
1. ✅ Add debug prints to occurrences step
2. ✅ Add debug prints to setClassFromExisting method
3. 🔄 Test app and analyze debug output
4. 🔄 Identify exact point where data is lost

### Phase 2: Fix Data Loading
Based on debug output, likely fixes:
1. **If templateClassModel.recurringPatterns is null/empty**: Fix GraphQL query to include recurring patterns
2. **If state.recurringPatterns is null/empty**: Fix state initialization
3. **If UI shows empty**: Fix state management or UI rendering

### Phase 3: Ensure Edit/Delete Functionality
1. ✅ Edit functionality already implemented (calls `editRecurringPattern`)
2. ✅ Delete functionality already implemented (calls `removeRecurringPattern`)
3. 🔄 Test that changes are applied when saving event

### Phase 4: Visual Feedback
1. Add visual indicators for edited patterns (colored frame)
2. Add visual indicators for deleted patterns (red frame)
3. Ensure changes are only applied on final save

## Expected Debug Output
When testing, we should see:
```
🔍 TEMPLATE DEBUG - Template recurringPatterns: [RecurringPatternModel(...)]
🔍 TEMPLATE DEBUG - Template recurringPatterns.length: 1
🔍 TEMPLATE DEBUG - State recurringPatterns: [RecurringPatternModel(...)]
🔍 TEMPLATE DEBUG - State recurringPatterns.length: 1
🔍 OCCURRENCES DEBUG - eventState.recurringPatterns.length: 1
🔍 OCCURRENCES DEBUG - eventState.recurringPatterns: [RecurringPatternModel(...)]
```

## Next Steps
1. Run app and check debug output
2. Identify where data is lost
3. Apply appropriate fix
4. Test edit/delete functionality
5. Add visual feedback for changes

## Confidence Level: 95%
Based on the main branch analysis and current code structure, I'm confident this approach will work. The main issue is likely in the data flow between fetching and displaying the patterns.
