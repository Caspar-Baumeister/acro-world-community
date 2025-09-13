# Event Creation Database Information

## 🎯 **Working Event Creation System (Main Branch)**

### **1. Event Creation Flow**
- **Method**: `upsertClass(String creatorId)` in `EventCreationAndEditingProvider`
- **Repository**: `ClassesRepository.upsertClass()`
- **Mutation**: `Mutations.upsertClass` (uses `classes_insert_input`)

### **2. Key Data Structures**

#### **ClassUpsertInput**
```dart
class ClassUpsertInput {
  final String id;                    // Class ID (UUID)
  final String name;                  // Event title
  final String description;           // Event description
  final String imageUrl;              // Event image URL
  final String timezone;              // Event timezone
  final String urlSlug;               // Unique identifier
  final bool isCashAllowed;           // Cash payment allowed
  final LatLng location;              // Geographic coordinates
  final String? locationName;         // Location name
  final String? locationCity;         // City
  final String? locationCountry;      // Country code
  final String? eventType;            // Event type enum
  final int? maxBookingSlots;         // Maximum booking slots
  final List<ClassOwnerInput> classOwners;      // ⭐ KEY: Class owners
  final List<ClassTeacherInput> classTeachers;  // Class teachers
  final List<RecurringPatternInput> recurringPatterns;
  final List<BookingCategoryInput> bookingCategories;
  final List<QuestionInput> questions;
}
```

#### **ClassOwnerInput**
```dart
class ClassOwnerInput {
  final String id;                    // Owner relationship ID
  final String teacherId;             // ⭐ KEY: Teacher ID (not user ID)
  final bool isPaymentReceiver;       // Payment receiver flag
}
```

### **3. Database Relationships**

#### **Classes Table**
- **Primary Key**: `id` (UUID)
- **Fields**: `name`, `description`, `image_url`, `location`, `location_name`, `location_city`, `location_country`, `event_type`, `timezone`, `url_slug`, `is_cash_allowed`, `max_booking_slots`
- **No `created_by_id` field** - ownership is managed via `class_owners` table

#### **Class Owners Table**
- **Primary Key**: `id` (UUID)
- **Foreign Keys**: 
  - `class_id` → `classes.id`
  - `teacher_id` → `teachers.id` ⭐ **NOT user_id**
- **Fields**: `is_payment_receiver`

#### **Teachers Table**
- **Primary Key**: `id` (UUID)
- **Fields**: `name`, `user_id`, `stripe_id`, `is_stripe_enabled`, etc.
- **Key Relationship**: `teachers.user_id` → `users.id`

### **4. Event Creation Process**

#### **Step 1: Create ClassOwnerInput**
```dart
if (_classOwner.isEmpty) {
  _classOwner.add(ClassOwnerInput(
    id: Uuid().v4(),
    teacherId: creatorId,  // ⭐ This is the TEACHER ID, not user ID
    isPaymentReceiver: true,
  ));
}
```

#### **Step 2: Build ClassUpsertInput**
```dart
final classUpsertInput = ClassUpsertInput(
  id: _classId ?? Uuid().v4(),
  name: _title,
  description: _description,
  // ... other fields
  classOwners: _classOwner.lastOrNull != null && !_isEdit
      ? [_classOwner.last]  // ⭐ Include class owners
      : [],
  // ... other relationships
);
```

#### **Step 3: Call Repository**
```dart
final createdClass = await classesRepository.upsertClass(
  classUpsertInput,
  questionIdsToDelete,
  recurringPatternIdsToDelete,
  deleteClassTeacherIds,
  deleteBookingOptionIds,
  deleteBookingCategoryIds,
);
```

### **5. Event Query System (My Events)**

#### **Query Method**: `getClassesLazyAsTeacherUser`
- **Provider**: `TeacherEventsProvider.fetchMyEvents()`
- **Repository**: `ClassesRepository.getClassesLazyAsTeacher()`

#### **Query Filter Logic**
```dart
{
  "_or": [
    {
      "created_by_id": {"_eq": userId}  // ⭐ Direct ownership
    },
    {
      "class_owners": {
        "teacher": {
          "user_id": {"_eq": userId}    // ⭐ Via class_owners relationship
        }
      }
    }
  ]
}
```

#### **Key Insight**: 
- The query looks for `class_owners.teacher.user_id` = `userId`
- This means the `teacher_id` in `class_owners` must point to a teacher whose `user_id` matches the current user

### **6. Critical Database Schema Understanding**

#### **User-Teacher Relationship**
```
users.id ←→ teachers.user_id
teachers.id ←→ class_owners.teacher_id
```

#### **Event Ownership Chain**
```
User (userId) 
  ↓ (via teachers.user_id)
Teacher (teacherId) 
  ↓ (via class_owners.teacher_id)
Class Owner (class_owners)
  ↓ (via class_owners.class_id)
Class (classes)
```

### **7. Why Event Creation Works on Main Branch**

1. **Correct Teacher ID Usage**: Uses `creatorId` (teacher ID) in `ClassOwnerInput.teacherId`
2. **Proper Relationship**: Creates `class_owners` record linking teacher to class
3. **Query Matches**: Query looks for `class_owners.teacher.user_id` which matches the relationship chain
4. **Complete Data Flow**: User → Teacher → Class Owner → Class

### **8. What Was Wrong in Design Branch**

1. **Missing `class_owners` in Query**: `getMyEventsOptimized` didn't include `class_owners` relationship
2. **Incorrect Mutation**: Used `insertClassWithRecurringPatterns` instead of `upsertClass`
3. **Wrong Data Structure**: Tried to use `created_by_id` directly instead of `class_owners` relationship
4. **Incomplete Input**: Missing proper `ClassUpsertInput` structure

### **9. Required Fixes for Design Branch**

1. **Use `upsertClass` mutation** instead of `insertClassWithRecurringPatterns`
2. **Use `ClassUpsertInput`** instead of raw GraphQL variables
3. **Include `class_owners` in query** selection set
4. **Use teacher ID** in `ClassOwnerInput.teacherId` (not user ID)
5. **Follow complete data flow**: User → Teacher → Class Owner → Class

### **10. Key Files to Update**

- `lib/provider/riverpod_provider/event_creation_and_editing_provider.dart`
- `lib/data/repositories/class_repository.dart`
- `lib/data/graphql/mutations.dart`
- `lib/data/graphql/queries.dart`
- `lib/presentation/screens/creator_mode_screens/create_and_edit_event/create_and_edit_event_page.dart`

---

**Summary**: The main branch uses a proper `class_owners` relationship system where events are owned by teachers, and teachers are linked to users. The design branch was trying to use a non-existent `created_by_id` field and incomplete query structure.
