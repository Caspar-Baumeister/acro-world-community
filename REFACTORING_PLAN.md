# AcroWorld Community App - Complete Refactoring Plan

## Overview
This document outlines the comprehensive refactoring plan for the AcroWorld Community App. The goal is to clean up the codebase, modernize the architecture, and ensure maintainability while keeping the app functional throughout the process.

## Current State Analysis

### Issues Identified
1. **Mixed State Management**: App uses both Provider and Riverpod simultaneously
2. **Dual Navigation Bars**: Two bottom navigation bars are being displayed
3. **"Around Me" Tab**: Activities/calendar tab needs to be removed
4. **Inconsistent Architecture**: Mix of old and new patterns
5. **Basic Logging**: Minimal Sentry integration
6. **Unused Code**: Dead code and unused dependencies

### Current Architecture
- **State Management**: Provider (old) + Riverpod (new) mixed
- **Routing**: go_router (already implemented)
- **Navigation**: Dual bottom navigation bars
- **Logging**: Basic Sentry integration
- **Dependencies**: 65+ packages with some unused ones

## Phase 1: Planning and Documentation ✅

### 1.1 PRD Update ✅
- [x] Updated PRD with detailed refactoring requirements
- [x] Defined technical requirements and success criteria

### 1.2 Detailed Refactoring Plan ✅
- [x] Created comprehensive step-by-step plan
- [x] Identified all components to be removed/modified
- [x] Defined testing strategy for each step

## Phase 2: Core Refactoring and Logging

### 2.1 Improved Centralized Logging
**Goal**: Replace print statements with centralized logging for development

#### Step 2.1.1: Improve Existing Logging Service
- [ ] Enhance CustomErrorHandler with better logging methods
- [ ] Add different log levels (debug, info, warning, error)
- [ ] Replace print statements throughout codebase with centralized logging
- [ ] Keep existing Sentry integration as-is

**Files to modify:**
- `lib/exceptions/error_handler.dart` (enhance existing)
- Replace print statements in key files
- Add logging to new implementations

**Test**: Verify logging works in both dev and prod environments

#### Step 2.1.2: Replace Print Statements
- [ ] Find all print statements in codebase
- [ ] Replace with appropriate logging calls
- [ ] Add contextual information to logs
- [ ] Ensure consistent logging format

**Test**: Verify no print statements remain and logging is consistent

### 2.2 Provider to Riverpod Migration
**Goal**: Systematically replace all Provider implementations with Riverpod

#### Step 2.2.1: Audit Current Providers
- [ ] List all Provider implementations
- [ ] Identify dependencies between providers
- [ ] Map provider usage across widgets
- [ ] Create migration priority list

**Files to audit:**
- `lib/provider/` (all files)
- `lib/App.dart` (MultiProvider setup)
- All widgets using Provider.of()

#### Step 2.2.2: Migrate Core Providers (Priority 1)
- [ ] `UserRoleProvider` → `userRoleProvider`
- [ ] `EventFilterProvider` → `eventFilterProvider`
- [ ] `DiscoveryProvider` → `discoveryProvider`
- [ ] `PlaceProvider` → `placeProvider`

**Test**: Verify each provider works correctly after migration

#### Step 2.2.3: Migrate Secondary Providers (Priority 2)
- [ ] `CalendarProvider` → `calendarProvider`
- [ ] `MapEventsProvider` → `mapEventsProvider`
- [ ] `TeacherEventsProvider` → `teacherEventsProvider`
- [ ] `CreatorBookingsProvider` → `creatorBookingsProvider`

**Test**: Verify each provider works correctly after migration

#### Step 2.2.4: Migrate Complex Providers (Priority 3)
- [ ] `EventCreationAndEditingProvider` → `eventCreationAndEditingProvider`
- [ ] `CreatorProvider` → `creatorProvider`
- [ ] `EventAnswerProvider` → `eventAnswerProvider`
- [ ] `InvitesProvider` → `invitesProvider`

**Test**: Verify each provider works correctly after migration

#### Step 2.2.5: Remove Provider Dependencies
- [ ] Remove `provider` package from pubspec.yaml
- [ ] Remove MultiProvider from App.dart
- [ ] Clean up all Provider imports
- [ ] Remove provider-related files

**Test**: App compiles and runs without Provider package

### 2.3 Navigation System Cleanup
**Goal**: Fix dual navigation bars and standardize navigation

#### Step 2.3.1: Identify Navigation Issues
- [ ] Find all bottom navigation implementations
- [ ] Identify which navigation is being used
- [ ] Map navigation state management
- [ ] Document current navigation flow

**Files to examine:**
- `lib/presentation/shells/shell_bottom_navigation_bar.dart`
- `lib/presentation/components/bottom_navbar/`
- `lib/presentation/shells/main_page_shell.dart`

#### Step 2.3.2: Consolidate Navigation
- [ ] Choose single navigation implementation
- [ ] Remove duplicate navigation components
- [ ] Update navigation state management
- [ ] Test navigation flow

**Test**: Only one navigation bar is displayed, navigation works correctly

#### Step 2.3.3: Remove "Around Me" Tab
- [ ] Remove activities route from navigation
- [ ] Remove activities page and components
- [ ] Update navigation indices
- [ ] Remove unused calendar components

**Files to remove/modify:**
- `lib/presentation/screens/user_mode_screens/main_pages/activities/`
- Update navigation arrays in `main_page_shell.dart`
- Update route definitions

**Test**: Navigation works without activities tab

## Phase 3: Cleanup and Design

### 3.1 Remove Unused Code
**Goal**: Eliminate dead code and unused dependencies

#### Step 3.1.1: Code Analysis
- [ ] Run dependency analysis
- [ ] Identify unused imports
- [ ] Find dead code paths
- [ ] List unused files

#### Step 3.1.2: Remove Unused Dependencies
- [ ] Remove unused packages from pubspec.yaml
- [ ] Clean up import statements
- [ ] Remove unused asset files
- [ ] Clean up build artifacts

#### Step 3.1.3: Remove Dead Code
- [ ] Delete unused files
- [ ] Remove commented code
- [ ] Clean up unused methods
- [ ] Remove unused variables

**Test**: App compiles and runs without errors

### 3.2 Standardize Design System
**Goal**: Create consistent UI components and design patterns

#### Step 3.2.1: Image Standardization
- [ ] Audit all image usage
- [ ] Implement consistent aspect ratios
- [ ] Create image loading components
- [ ] Update image display logic

**Files to modify:**
- `lib/presentation/components/images/`
- All screens with images
- Event cards and booking pages

#### Step 3.2.2: Component Standardization
- [ ] Audit UI components
- [ ] Create consistent button styles
- [ ] Standardize form inputs
- [ ] Implement consistent spacing

#### Step 3.2.3: Theme Standardization
- [ ] Review theme implementation
- [ ] Ensure consistent colors
- [ ] Standardize typography
- [ ] Implement consistent shadows/elevations

**Test**: UI looks consistent across all screens

### 3.3 Code Organization
**Goal**: Improve file structure and follow clean architecture

#### Step 3.3.1: File Structure Review
- [ ] Audit current file organization
- [ ] Identify misplaced files
- [ ] Plan new structure
- [ ] Create migration plan

#### Step 3.3.2: Implement Clean Architecture
- [ ] Organize files by feature
- [ ] Separate concerns properly
- [ ] Implement proper layering
- [ ] Update import paths

**Test**: Code is well-organized and maintainable

## Testing Strategy

### Integration Tests
- [ ] Test complete user flows
- [ ] Test navigation between screens
- [ ] Test state management across features
- [ ] Test error handling scenarios

### Unit Tests
- [ ] Test all new Riverpod providers
- [ ] Test logging service
- [ ] Test navigation components
- [ ] Test UI components

### Manual Testing
- [ ] Test on different devices
- [ ] Test different user roles
- [ ] Test offline scenarios
- [ ] Test performance

## Git Strategy

### Branching Strategy
- Create feature branch for each major step
- Use descriptive branch names
- Merge to main after each step is complete and tested
- Tag releases at major milestones

### Branch Names
- `feature/enhanced-logging`
- `feature/riverpod-migration-core`
- `feature/riverpod-migration-secondary`
- `feature/riverpod-migration-complex`
- `feature/navigation-cleanup`
- `feature/remove-around-me`
- `feature/remove-unused-code`
- `feature/design-standardization`

## Success Criteria

### Technical Criteria
- [ ] App compiles without warnings
- [ ] All tests pass
- [ ] No Provider dependencies remain
- [ ] Single navigation bar implementation
- [ ] "Around Me" tab completely removed
- [ ] Comprehensive logging implemented
- [ ] Consistent design system
- [ ] Clean code architecture

### Performance Criteria
- [ ] App startup time < 3 seconds
- [ ] Navigation transitions < 200ms
- [ ] Memory usage optimized
- [ ] No memory leaks

### User Experience Criteria
- [ ] Smooth navigation
- [ ] Consistent UI/UX
- [ ] No crashes or errors
- [ ] Responsive design

## Risk Mitigation

### Rollback Strategy
- Each step is independently testable
- Git branches allow easy rollback
- Comprehensive logging helps identify issues
- Manual testing at each step

### Communication Plan
- Daily progress updates
- Issue reporting and resolution
- Testing feedback incorporation
- Stakeholder approval at major milestones

## Timeline Estimate

- **Phase 1**: 1 day (Planning) ✅
- **Phase 2**: 5-7 days (Core Refactoring)
- **Phase 3**: 3-4 days (Cleanup and Design)
- **Total**: 9-12 days

## Next Steps

1. Begin Phase 2.1: Enhanced Logging System
2. Set up comprehensive testing environment
3. Create feature branch for logging implementation
4. Start systematic Provider to Riverpod migration
