# Jobs Feature Implementation Plan

## Overview

This document outlines the complete implementation plan for the Jobs feature in the AcroWorld Community app. The jobs feature will allow teachers and studio owners to post job openings for performers, teachers, medics, or other community members for their events or studios.

## Database Schema

### Core Tables

#### 1. `jobs` Table
```sql
CREATE TABLE jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  requirements TEXT,
  responsibilities TEXT,
  location VARCHAR(255) NOT NULL,
  location_type VARCHAR(50) NOT NULL, -- 'studio', 'event', 'online', 'other'
  job_type VARCHAR(50) NOT NULL, -- 'teacher', 'performer', 'medic', 'assistant', 'other'
  experience_level VARCHAR(50) NOT NULL, -- 'beginner', 'intermediate', 'advanced', 'professional'
  start_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE,
  is_recurring BOOLEAN DEFAULT FALSE,
  recurring_pattern JSONB, -- For recurring jobs
  pay_rate DECIMAL(10,2),
  currency VARCHAR(3) DEFAULT 'EUR',
  pay_type VARCHAR(50), -- 'hourly', 'daily', 'weekly', 'monthly', 'fixed', 'volunteer'
  is_remote BOOLEAN DEFAULT FALSE,
  max_applications INTEGER,
  application_deadline TIMESTAMP WITH TIME ZONE,
  status VARCHAR(50) DEFAULT 'active', -- 'active', 'paused', 'closed', 'completed', 'cancelled'
  created_by_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  published_at TIMESTAMP WITH TIME ZONE,
  
  -- Constraints
  CONSTRAINT valid_status CHECK (status IN ('active', 'paused', 'closed', 'completed', 'cancelled')),
  CONSTRAINT valid_job_type CHECK (job_type IN ('teacher', 'performer', 'medic', 'assistant', 'other')),
  CONSTRAINT valid_experience_level CHECK (experience_level IN ('beginner', 'intermediate', 'advanced', 'professional')),
  CONSTRAINT valid_pay_type CHECK (pay_type IN ('hourly', 'daily', 'weekly', 'monthly', 'fixed', 'volunteer')),
  CONSTRAINT valid_location_type CHECK (location_type IN ('studio', 'event', 'online', 'other')),
  CONSTRAINT valid_dates CHECK (start_date <= end_date),
  CONSTRAINT valid_application_deadline CHECK (application_deadline IS NULL OR application_deadline >= created_at)
);
```

#### 2. `job_applications` Table
```sql
CREATE TABLE job_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  applicant_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  cover_letter TEXT,
  resume_url TEXT,
  portfolio_url TEXT,
  status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'reviewed', 'shortlisted', 'rejected', 'accepted', 'withdrawn'
  applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_at TIMESTAMP WITH TIME ZONE,
  reviewed_by_id UUID REFERENCES users(id),
  notes TEXT, -- Internal notes from employer
  
  -- Constraints
  CONSTRAINT valid_application_status CHECK (status IN ('pending', 'reviewed', 'shortlisted', 'rejected', 'accepted', 'withdrawn')),
  CONSTRAINT unique_job_application UNIQUE (job_id, applicant_id)
);
```

#### 3. `job_skills` Table (Many-to-Many)
```sql
CREATE TABLE job_skills (
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  skill_name VARCHAR(100) NOT NULL,
  skill_level VARCHAR(50), -- 'required', 'preferred', 'nice_to_have'
  
  PRIMARY KEY (job_id, skill_name),
  CONSTRAINT valid_skill_level CHECK (skill_level IN ('required', 'preferred', 'nice_to_have'))
);
```

#### 4. `job_images` Table
```sql
CREATE TABLE job_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  alt_text VARCHAR(255),
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Indexes
```sql
-- Performance indexes
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_jobs_location ON jobs(location);
CREATE INDEX idx_jobs_job_type ON jobs(job_type);
CREATE INDEX idx_jobs_experience_level ON jobs(experience_level);
CREATE INDEX idx_jobs_start_date ON jobs(start_date);
CREATE INDEX idx_jobs_created_by ON jobs(created_by_id);
CREATE INDEX idx_jobs_published_at ON jobs(published_at);

CREATE INDEX idx_job_applications_job_id ON job_applications(job_id);
CREATE INDEX idx_job_applications_applicant_id ON job_applications(applicant_id);
CREATE INDEX idx_job_applications_status ON job_applications(status);

CREATE INDEX idx_job_skills_job_id ON job_skills(job_id);
CREATE INDEX idx_job_skills_skill_name ON job_skills(skill_name);
```

## Data Models

### 1. Job Model
```dart
// lib/data/models/job_model.dart
class JobModel {
  final String id;
  final String title;
  final String description;
  final String? requirements;
  final String? responsibilities;
  final String location;
  final JobLocationType locationType;
  final JobType jobType;
  final ExperienceLevel experienceLevel;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isRecurring;
  final RecurringPattern? recurringPattern;
  final double? payRate;
  final String currency;
  final PayType? payType;
  final bool isRemote;
  final int? maxApplications;
  final DateTime? applicationDeadline;
  final JobStatus status;
  final String createdById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final List<String> skills; // Required skills
  final List<JobImage> images;
  final UserModel? createdBy; // Populated when needed
  final int applicationCount;
  final bool hasUserApplied;
  
  // Constructor and methods...
}

enum JobLocationType {
  studio,
  event,
  online,
  other;
}

enum JobType {
  teacher,
  performer,
  medic,
  assistant,
  other;
}

enum ExperienceLevel {
  beginner,
  intermediate,
  advanced,
  professional;
}

enum PayType {
  hourly,
  daily,
  weekly,
  monthly,
  fixed,
  volunteer;
}

enum JobStatus {
  active,
  paused,
  closed,
  completed,
  cancelled;
}

class RecurringPattern {
  final String frequency; // 'daily', 'weekly', 'monthly'
  final int interval;
  final List<int>? daysOfWeek; // For weekly
  final List<int>? daysOfMonth; // For monthly
  final DateTime? endDate;
  final int? maxOccurrences;
}
```

### 2. Job Application Model
```dart
// lib/data/models/job_application_model.dart
class JobApplicationModel {
  final String id;
  final String jobId;
  final String applicantId;
  final String? coverLetter;
  final String? resumeUrl;
  final String? portfolioUrl;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime? reviewedAt;
  final String? reviewedById;
  final String? notes;
  final UserModel? applicant; // Populated when needed
  final UserModel? reviewedBy; // Populated when needed
  
  // Constructor and methods...
}

enum ApplicationStatus {
  pending,
  reviewed,
  shortlisted,
  rejected,
  accepted,
  withdrawn;
}
```

## GraphQL Queries & Mutations

### Queries
```graphql
# Get jobs with filters and pagination
query getJobs(
  $limit: Int!
  $offset: Int!
  $searchQuery: String
  $jobType: String
  $location: String
  $experienceLevel: String
  $status: String
  $isRemote: Boolean
  $minPayRate: Float
  $maxPayRate: Float
  $currency: String
) {
  jobs(
    limit: $limit
    offset: $offset
    where: {
      _and: [
        { status: { _eq: $status } }
        { title: { _ilike: $searchQuery } }
        { job_type: { _eq: $jobType } }
        { location: { _ilike: $location } }
        { experience_level: { _eq: $experienceLevel } }
        { is_remote: { _eq: $isRemote } }
        { pay_rate: { _gte: $minPayRate } }
        { pay_rate: { _lte: $maxPayRate } }
        { currency: { _eq: $currency } }
      ]
    }
    order_by: { created_at: desc }
  ) {
    id
    title
    description
    location
    location_type
    job_type
    experience_level
    start_date
    end_date
    pay_rate
    currency
    pay_type
    is_remote
    status
    created_at
    published_at
    images {
      id
      image_url
      alt_text
      display_order
    }
    skills {
      skill_name
      skill_level
    }
    created_by {
      id
      name
      teacher_profile {
        id
        name
        images(where: { is_profile_picture: { _eq: true } }, limit: 1) {
          image {
            url
          }
        }
      }
    }
    applications_aggregate {
      aggregate {
        count
      }
    }
  }
  jobs_aggregate(
    where: {
      _and: [
        { status: { _eq: $status } }
        { title: { _ilike: $searchQuery } }
        # ... other filters
      ]
    }
  ) {
    aggregate {
      count
    }
  }
}

# Get single job with full details
query getJobById($id: uuid!) {
  jobs_by_pk(id: $id) {
    id
    title
    description
    requirements
    responsibilities
    location
    location_type
    job_type
    experience_level
    start_date
    end_date
    is_recurring
    recurring_pattern
    pay_rate
    currency
    pay_type
    is_remote
    max_applications
    application_deadline
    status
    created_by_id
    created_at
    updated_at
    published_at
    images {
      id
      image_url
      alt_text
      display_order
    }
    skills {
      skill_name
      skill_level
    }
    created_by {
      id
      name
      email
      teacher_profile {
        id
        name
        description
        images(where: { is_profile_picture: { _eq: true } }, limit: 1) {
          image {
            url
          }
        }
      }
    }
    applications {
      id
      applicant_id
      cover_letter
      resume_url
      portfolio_url
      status
      applied_at
      applicant {
        id
        name
        email
        teacher_profile {
          id
          name
          images(where: { is_profile_picture: { _eq: true } }, limit: 1) {
            image {
              url
            }
          }
        }
      }
    }
  }
}

# Get user's job applications
query getUserJobApplications($userId: uuid!, $limit: Int!, $offset: Int!) {
  job_applications(
    where: { applicant_id: { _eq: $userId } }
    limit: $limit
    offset: $offset
    order_by: { applied_at: desc }
  ) {
    id
    job_id
    status
    applied_at
    reviewed_at
    notes
    job {
      id
      title
      location
      job_type
      experience_level
      start_date
      status
      created_by {
        id
        name
        teacher_profile {
          id
          name
        }
      }
    }
  }
}

# Get jobs created by user
query getUserCreatedJobs($userId: uuid!, $limit: Int!, $offset: Int!) {
  jobs(
    where: { created_by_id: { _eq: $userId } }
    limit: $limit
    offset: $offset
    order_by: { created_at: desc }
  ) {
    id
    title
    description
    location
    job_type
    experience_level
    start_date
    end_date
    pay_rate
    currency
    status
    created_at
    published_at
    applications_aggregate {
      aggregate {
        count
      }
    }
  }
}
```

### Mutations
```graphql
# Create new job
mutation createJob($input: jobs_insert_input!) {
  insert_jobs_one(object: $input) {
    id
    title
    status
    created_at
  }
}

# Update job
mutation updateJob($id: uuid!, $input: jobs_set_input!) {
  update_jobs_by_pk(pk_columns: { id: $id }, _set: $input) {
    id
    title
    status
    updated_at
  }
}

# Delete job
mutation deleteJob($id: uuid!) {
  delete_jobs_by_pk(id: $id) {
    id
  }
}

# Apply to job
mutation applyToJob($input: job_applications_insert_input!) {
  insert_job_applications_one(object: $input) {
    id
    job_id
    applicant_id
    status
    applied_at
  }
}

# Update application status
mutation updateApplicationStatus(
  $id: uuid!
  $status: String!
  $notes: String
  $reviewed_by_id: uuid
) {
  update_job_applications_by_pk(
    pk_columns: { id: $id }
    _set: {
      status: $status
      notes: $notes
      reviewed_by_id: $reviewed_by_id
      reviewed_at: "now()"
    }
  ) {
    id
    status
    reviewed_at
    notes
  }
}

# Withdraw application
mutation withdrawApplication($id: uuid!) {
  update_job_applications_by_pk(
    pk_columns: { id: $id }
    _set: { status: "withdrawn" }
  ) {
    id
    status
  }
}
```

## UI Components & Screens

### 1. Jobs List Screen
- **Location**: `lib/presentation/screens/jobs/jobs_list_screen.dart`
- **Features**:
  - Search and filter functionality
  - Infinite scroll with pagination
  - Job cards with key information
  - Quick apply button
  - Filter by: job type, location, experience level, pay range, remote work
- **Components**:
  - `JobsSearchAndFilter` (already exists, needs enhancement)
  - `JobCard` (new)
  - `JobFiltersModal` (new)

### 2. Job Details Screen
- **Location**: `lib/presentation/screens/jobs/job_details_screen.dart`
- **Features**:
  - Full job description
  - Requirements and responsibilities
  - Employer information
  - Application form
  - Share functionality
  - Save/unsave job
- **Components**:
  - `JobHeader` (new)
  - `JobDescription` (new)
  - `JobRequirements` (new)
  - `JobApplicationForm` (new)
  - `EmployerCard` (new)

### 3. Create Job Screen
- **Location**: `lib/presentation/screens/jobs/create_job_screen.dart`
- **Features**:
  - Multi-step form
  - Rich text editor for description
  - Image upload
  - Skills selection
  - Preview before publishing
- **Components**:
  - `JobBasicInfoForm` (new)
  - `JobDetailsForm` (new)
  - `JobRequirementsForm` (new)
  - `JobPreview` (new)

### 4. My Jobs Screen
- **Location**: `lib/presentation/screens/jobs/my_jobs_screen.dart`
- **Features**:
  - Created jobs management
  - Application management
  - Analytics dashboard
  - Quick actions (edit, pause, close)
- **Components**:
  - `MyJobsTabBar` (new)
  - `CreatedJobsList` (new)
  - `JobApplicationsList` (new)
  - `JobAnalytics` (new)

### 5. My Applications Screen
- **Location**: `lib/presentation/screens/jobs/my_applications_screen.dart`
- **Features**:
  - Applied jobs list
  - Application status tracking
  - Withdraw applications
  - Application history
- **Components**:
  - `ApplicationCard` (new)
  - `ApplicationStatusChip` (new)
  - `ApplicationTimeline` (new)

## State Management (Riverpod)

### 1. Jobs Provider
```dart
// lib/provider/riverpod_provider/jobs_provider.dart
class JobsState {
  final List<JobModel> jobs;
  final bool loading;
  final bool isLoadingMore;
  final bool canFetchMore;
  final String? error;
  final String searchQuery;
  final JobFilters filters;
  final Map<String, bool> appliedJobs; // Track user applications
  
  // ... implementation
}

class JobsNotifier extends StateNotifier<JobsState> {
  // Methods:
  // - fetchJobs()
  // - fetchMoreJobs()
  // - searchJobs()
  // - applyFilters()
  // - applyToJob()
  // - saveJob()
  // - unsaveJob()
}
```

### 2. Job Details Provider
```dart
// lib/provider/riverpod_provider/job_details_provider.dart
class JobDetailsState {
  final JobModel? job;
  final bool loading;
  final String? error;
  final bool hasUserApplied;
  final bool isJobSaved;
  
  // ... implementation
}

class JobDetailsNotifier extends StateNotifier<JobDetailsState> {
  // Methods:
  // - fetchJobDetails()
  // - applyToJob()
  // - saveJob()
  // - unsaveJob()
}
```

### 3. My Jobs Provider
```dart
// lib/provider/riverpod_provider/my_jobs_provider.dart
class MyJobsState {
  final List<JobModel> createdJobs;
  final List<JobApplicationModel> applications;
  final bool loading;
  final String? error;
  
  // ... implementation
}

class MyJobsNotifier extends StateNotifier<MyJobsState> {
  // Methods:
  // - fetchCreatedJobs()
  // - fetchApplications()
  // - createJob()
  // - updateJob()
  // - deleteJob()
  // - updateApplicationStatus()
}
```

## Navigation & Routing

### Route Configuration
```dart
// lib/routing/route_names.dart
class RouteNames {
  static const String jobsList = '/jobs';
  static const String jobDetails = '/jobs/:jobId';
  static const String createJob = '/jobs/create';
  static const String editJob = '/jobs/:jobId/edit';
  static const String myJobs = '/my-jobs';
  static const String myApplications = '/my-applications';
  static const String jobApplications = '/jobs/:jobId/applications';
}
```

### Navigation Implementation
```dart
// lib/routing/app_router.dart
GoRoute(
  path: '/jobs',
  name: RouteNames.jobsList,
  builder: (context, state) => const JobsListScreen(),
),
GoRoute(
  path: '/jobs/:jobId',
  name: RouteNames.jobDetails,
  builder: (context, state) {
    final jobId = state.pathParameters['jobId']!;
    return JobDetailsScreen(jobId: jobId);
  },
),
// ... other routes
```

## Implementation Phases

### Phase 1: Core Infrastructure (Week 1-2)
1. Database schema setup
2. Basic data models
3. GraphQL queries and mutations
4. Basic Riverpod providers
5. Simple jobs list screen

### Phase 2: Job Management (Week 3-4)
1. Create/edit job functionality
2. Job details screen
3. Application system
4. My jobs dashboard

### Phase 3: Advanced Features (Week 5-6)
1. Advanced search and filtering
2. Notifications system
3. Analytics dashboard
4. Image upload and management
5. Recurring jobs support

### Phase 4: Polish & Testing (Week 7-8)
1. UI/UX improvements
2. Performance optimization
3. Comprehensive testing
4. Bug fixes and refinements

## Security Considerations

### Row Level Security (RLS)
```sql
-- Jobs table
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

-- Users can view all published jobs
CREATE POLICY "Anyone can view published jobs" ON jobs
  FOR SELECT USING (status = 'active' AND published_at IS NOT NULL);

-- Users can only edit their own jobs
CREATE POLICY "Users can edit own jobs" ON jobs
  FOR ALL USING (created_by_id = auth.uid());

-- Job applications
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

-- Users can view applications for their own jobs
CREATE POLICY "Job owners can view applications" ON job_applications
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM jobs 
      WHERE jobs.id = job_applications.job_id 
      AND jobs.created_by_id = auth.uid()
    )
  );

-- Users can view their own applications
CREATE POLICY "Users can view own applications" ON job_applications
  FOR SELECT USING (applicant_id = auth.uid());
```

### Data Validation
- Input sanitization for all text fields
- File upload restrictions (size, type)
- Rate limiting for applications
- Spam detection for job postings

## Analytics & Metrics

### Key Metrics to Track
1. **Job Posting Metrics**:
   - Total jobs posted
   - Jobs by category/type
   - Average time to fill
   - Application rate per job

2. **Application Metrics**:
   - Total applications
   - Application success rate
   - Time from application to response
   - Withdrawal rate

3. **User Engagement**:
   - Job views per user
   - Search queries and filters used
   - Saved jobs
   - User retention in jobs feature

### Analytics Implementation
```dart
// lib/services/analytics_service.dart
class JobsAnalytics {
  static void trackJobViewed(String jobId, String userId);
  static void trackJobApplied(String jobId, String userId);
  static void trackJobCreated(String jobId, String userId);
  static void trackJobSearch(String query, Map<String, dynamic> filters);
  static void trackApplicationStatusChanged(String applicationId, String newStatus);
}
```

## Testing Strategy

### Unit Tests
- Data model serialization/deserialization
- Provider state management
- Business logic validation
- Utility functions

### Widget Tests
- Individual UI components
- Screen layouts
- User interactions
- Form validation

### Integration Tests
- End-to-end job creation flow
- Application submission process
- Search and filtering functionality
- Navigation between screens

### Performance Tests
- Large dataset handling
- Image loading optimization
- Search performance
- Memory usage optimization

## Future Enhancements

### Phase 2 Features
1. **Messaging System**: Direct communication between employers and applicants
2. **Recommendations**: AI-powered job recommendations based on user profile
3. **Calendar Integration**: Sync job schedules with user calendars
4. **Payment Integration**: Built-in payment processing for paid positions
5. **Video Applications**: Allow video cover letters/portfolios
6. **Reviews & Ratings**: Rate employers and applicants
7. **Job Alerts**: Email/push notifications for matching jobs
8. **Bulk Operations**: Apply to multiple jobs, bulk application management

### Advanced Features
1. **Multi-language Support**: Job postings in different languages
2. **Geolocation Services**: Location-based job recommendations
3. **Social Features**: Share jobs, refer friends
4. **Advanced Analytics**: Detailed insights for employers
5. **API Integration**: Third-party job board integrations
6. **Mobile App**: Dedicated mobile app for job seekers
7. **Enterprise Features**: Company profiles, team management

## Conclusion

This implementation plan provides a comprehensive roadmap for building a robust jobs feature that integrates seamlessly with the existing AcroWorld Community platform. The phased approach ensures steady progress while maintaining code quality and user experience standards.

The feature will significantly enhance the platform's value proposition by connecting the acro community through professional opportunities, creating a more comprehensive ecosystem for acro practitioners, teachers, and studio owners.
