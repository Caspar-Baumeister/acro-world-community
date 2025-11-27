# Teacher Invitation Data Flow - Event Creation & Editing

## Overview
This document explains the complete data flow for teacher selection and invitations in event creation and editing.

---

## 1. TEACHER SELECTION (UI Flow)

### Location
**File:** `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/`

### Components Involved:
1. **`community_step.dart`** - Main step container
2. **`community_step_search_teacher_input_field.dart`** - Search input field
3. **`community_step_teacher_suggestion_section.dart`** - Teacher search results
4. **`community_step_selected_teachers_section.dart`** - Selected teachers display

### How Teachers Are Selected:

#### Step 1: User Types in Search Field
- User types in the search input (name or email)
- Query is validated:
  - If it's a valid email format → shows "Email Invite" option
  - Otherwise → shows teacher search results

#### Step 2: Teacher Search Query
**Component:** `CommunityStepTeacherSuggestionSection`
**Query:** `TeacherSuggestionsQuery` with variables:
```dart
{
  'limit': 10,
  'offset': 0,
  'where': {
    '_or': [
      {'name': {'_ilike': '$query%'}},
      {'user': {'email': {'_ilike': '$query%'}}}
    ]
  }
}
```
**Returns:** List of teachers matching name or email

#### Step 3: Teacher Selection
**Action:** User clicks on a teacher from search results
**Handler:** `onTeacherSelected: (TeacherModel teacher)`
```dart
notifier.addPendingInviteTeacher(teacher);
teacherQueryController.clear();
```

#### Step 4: Email Invite (Alternative)
If query is a valid email:
- Shows "Invite by email" option
- Adds email to `pendingEmailInvites` list

---

## 2. STATE MANAGEMENT

### Provider: `eventTeachersProvider`
**File:** `lib/provider/riverpod_provider/event_teachers_provider.dart`

### State Structure:
```dart
class EventTeachersState {
  final List<TeacherModel> pendingInviteTeachers;  // Selected teachers with accounts
  final List<String> pendingEmailInvites;          // Email invites (no account)
  final bool isLoading;
  final String? errorMessage;
}
```

### Key Methods:
- `addPendingInviteTeacher(TeacherModel)` - Add teacher to pending list
- `removePendingInviteTeacher(String teacherId)` - Remove teacher
- `addEmailInvite(String email)` - Add email invitation
- `removeEmailInvite(String email)` - Remove email invite
- `setFromTemplate(List<TeacherModel>)` - Load teachers when editing

---

## 3. EVENT CREATION FLOW

### File: `lib/provider/riverpod_provider/event_creation_coordinator_provider.dart`

### Step 1: Create Class (without teachers)
**Method:** `saveEvent(String teacherId)`

**Mutation:** `Mutations.upsertClass`
**Input:** `ClassUpsertInput`
```dart
ClassUpsertInput(
  id: classId,
  name: basicInfo.title,
  urlSlug: basicInfo.slug,
  description: basicInfo.description,
  eventType: basicInfo.eventType,
  location: locationInput,
  locationName: location.locationName,
  locationCountry: location.countryCode,
  locationCity: location.region,
  imageUrl: imageUrl,
  classTeachers: [], // ⚠️ EMPTY - teachers invited separately!
  bookingCategories: [...],
  questions: [...],
  recurringPatterns: [...],
)
```

### Step 2: Send Teacher Invitations
**Method:** `_sendTeacherInvitations(String classId)`

#### For Teachers with Accounts:
```dart
Mutation: Mutations.inviteToClassMutation
Variables: {
  'email': teacher.email,
  'entity': 'class',
  'entity_id': classId,
  'userId': teacher.userId  // ⚠️ User ID included
}
```

#### For Email Invites (no account):
```dart
Mutation: Mutations.inviteToClassMutation
Variables: {
  'email': email,
  'entity': 'class',
  'entity_id': classId,
  // userId is null
}
```

### Mutation Definition:
**File:** `lib/data/graphql/mutations.dart`
```graphql
mutation InviteToClass(
  $email: String!,
  $entity: String!,
  $entity_id: String!,
  $userId: String
) {
  invite(
    email: $email,
    entity: $entity,
    entity_id: $entity_id,
    userId: $userId
  ) {
    success
  }
}
```

---

## 4. EVENT EDITING FLOW

### Step 1: Load Existing Event Data
**Method:** `loadExistingClass(ClassModel classModel, bool isEditing)`

**Query Used:** `Queries.getClassById`
**Variables:**
```dart
{
  'url_slug': classModel.urlSlug
}
```

### Step 2: Query Returns Full Class Data
**Fragment:** `Fragments.classFragmentAllInfo`

**Includes:**
```graphql
class_teachers {
  teacher {
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
  }
  is_owner
}
```

### Step 3: Extract Teachers from Response
**Location:** Lines 230-238 in `event_creation_coordinator_provider.dart`

```dart
final List<TeacherModel> copiedTeachers = [];
if (classModel.classTeachers != null) {
  for (final classTeacher in classModel.classTeachers!) {
    if (classTeacher.teacher != null) {
      copiedTeachers.add(classTeacher.teacher!);
    }
  }
}
```

### Step 4: Populate Provider
**Location:** Line 275-277

```dart
ref.read(eventTeachersProvider.notifier).setFromTemplate(
  pendingInviteTeachers: copiedTeachers,
);
```

### Step 5: Display in UI
- Teachers appear in `CommunityStepSelectedTeachersSection`
- Each teacher shown as `TeacherOption` widget
- Can be removed with delete button

### Step 6: Save Changes
**Same as creation flow:**
1. Update class with `Mutations.upsertClass` (teachers field is empty)
2. Send invitations via `_sendTeacherInvitations()`

---

## 5. DATA FLOW SUMMARY

### Creation Flow:
```
User Types → Search Query → Select Teacher → Add to Provider
                                                    ↓
                                            Save Event
                                                    ↓
                                            Create Class (no teachers)
                                                    ↓
                                            Send Invitations (separate mutation per teacher)
```

### Editing Flow:
```
Load Event → Query getClassById → Extract classTeachers → Populate Provider
                                                                    ↓
                                                            Display in UI
                                                                    ↓
                                                            User can modify
                                                                    ↓
                                                            Save Event
                                                                    ↓
                                                            Update Class
                                                                    ↓
                                                            Send New Invitations
```

---

## 6. KEY POINTS

### ⚠️ Important Notes:

1. **Teachers NOT in ClassUpsertInput**
   - The `classTeachers` field in `ClassUpsertInput` is **always empty** `[]`
   - Teachers are invited **separately** after class creation/update

2. **Separate Invitation Mutation**
   - Each teacher gets their own `inviteToClassMutation` call
   - Invitations are sent sequentially in a loop

3. **Two Types of Invitations**
   - **With Account:** Includes `userId` in mutation
   - **Email Only:** No `userId`, just email

4. **Editing Behavior**
   - Existing teachers are loaded from `class_teachers` table
   - When saving, ALL pending teachers get new invitations
   - Backend handles accepting/declining invitations

5. **Query Fragment**
   - `classFragmentAllInfo` includes full teacher data
   - Includes user info, likes count, stripe status, etc.

---

## 7. MUTATION & QUERY SUMMARY

### Mutations:
1. **`Mutations.upsertClass`** - Create/update class (teachers field empty)
2. **`Mutations.inviteToClassMutation`** - Send invitation to teacher

### Queries:
1. **`Queries.getClassById`** - Load class data for editing (includes teachers)
2. **`TeacherSuggestionsQuery`** - Search for teachers by name/email

### Fragments:
1. **`Fragments.classFragmentAllInfo`** - Full class data including teachers
2. **`Fragments.teacherFragmentAllInfo`** - Full teacher data including user info

---

## 8. BACKEND EXPECTATIONS

### When Creating/Updating Class:
- Backend expects `classTeachers: []` in input
- Backend does NOT create teacher associations from this field

### When Inviting:
- Backend receives invitation via `invite()` mutation
- Backend creates entry in `invites` table
- Backend sends notification to user
- User accepts/declines invitation
- Backend creates `class_teachers` entry when accepted

---

## 9. FILES REFERENCED

### UI Components:
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/community_step.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_teacher_suggestion_section.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_selected_teachers_section.dart`

### Providers:
- `lib/provider/riverpod_provider/event_teachers_provider.dart`
- `lib/provider/riverpod_provider/event_creation_coordinator_provider.dart`

### GraphQL:
- `lib/data/graphql/mutations.dart`
- `lib/data/graphql/queries.dart`
- `lib/data/graphql/fragments.dart`

---

## 10. VISUAL FLOW DIAGRAM

```
┌─────────────────────────────────────────────────────────────┐
│                    EVENT CREATION                            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  1. User searches for teacher                                │
│     ↓                                                         │
│  2. Select teacher from results                              │
│     ↓                                                         │
│  3. Teacher added to eventTeachersProvider                   │
│     ↓                                                         │
│  4. User clicks "Create"                                     │
│     ↓                                                         │
│  5. upsertClass mutation (classTeachers: [])                 │
│     ↓                                                         │
│  6. Class created in database                                │
│     ↓                                                         │
│  7. _sendTeacherInvitations() called                         │
│     ↓                                                         │
│  8. For each teacher: inviteToClassMutation                  │
│     ↓                                                         │
│  9. Invitations sent to backend                              │
│                                                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    EVENT EDITING                             │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  1. User clicks "Edit" on existing event                     │
│     ↓                                                         │
│  2. loadExistingClass() called                               │
│     ↓                                                         │
│  3. getClassById query executed                              │
│     ↓                                                         │
│  4. Response includes class_teachers array                   │
│     ↓                                                         │
│  5. Teachers extracted from classTeachers                    │
│     ↓                                                         │
│  6. Teachers loaded into eventTeachersProvider               │
│     ↓                                                         │
│  7. UI displays existing teachers                            │
│     ↓                                                         │
│  8. User can add/remove teachers                             │
│     ↓                                                         │
│  9. User clicks "Update"                                     │
│     ↓                                                         │
│  10. upsertClass mutation (classTeachers: [])                │
│     ↓                                                         │
│  11. Class updated in database                               │
│     ↓                                                         │
│  12. _sendTeacherInvitations() called                        │
│     ↓                                                         │
│  13. New invitations sent                                    │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 11. DATABASE TABLES

### Relevant Tables:
1. **`classes`** - Stores class data (without teacher associations)
2. **`invites`** - Stores pending invitations
3. **`class_teachers`** - Stores accepted teacher associations
4. **`teachers`** - Stores teacher profiles
5. **`users`** - Stores user accounts

### Relationships:
```
classes ← class_teachers → teachers → users
classes ← invites → users (via email)
```

---

## 12. EXAMPLE DATA

### Teacher Model (from search):
```dart
TeacherModel(
  id: "uuid-123",
  name: "John Doe",
  email: "john@example.com",
  userId: "user-uuid-456",
  likes: 150,
  description: "Acroyoga teacher...",
  // ... more fields
)
```

### ClassTeachers (from query):
```graphql
class_teachers {
  teacher {
    id: "uuid-123"
    name: "John Doe"
    user {
      id: "user-uuid-456"
      email: "john@example.com"
    }
  }
  is_owner: false
}
```

### Invitation Mutation Variables:
```json
{
  "email": "john@example.com",
  "entity": "class",
  "entity_id": "class-uuid-789",
  "userId": "user-uuid-456"
}
```

---

## END OF DOCUMENT

