import 'dart:convert';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/services/talent_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to check if user has an existing talent profile
final talentProfileExistsProvider = FutureProvider.autoDispose<bool>((ref) async {
  final user = await ref.watch(userRiverpodProvider.future);
  if (user?.id == null) return false;
  
  final service = TalentProfileService();
  return service.checkTalentProfileExists(user!.id!);
});

/// Total number of wizard steps
const int totalWizardSteps = 9;

/// Wizard state for collecting talent profile data
class TalentProfileWizardState {
  final int currentStep;
  final bool isSubmitting;
  final String? errorMessage;
  
  // Step 1: Work types
  final Set<String> selectedWorkTypes;
  final List<String> customWorkTypes;
  
  // Step 2: Location
  final String locationCities;
  
  // Step 3: Disciplines
  final Set<String> selectedDisciplines;
  final List<String> customDisciplines;
  
  // Step 4: Discipline details (keyed by discipline name)
  final Map<String, String> disciplineDetails;
  
  // Step 5: Certificates
  final String certificationsText;
  final List<String> certificateCards;
  
  // Step 6: Experience
  final String experienceLength;
  final String experienceDescription;
  
  // Step 7: Languages
  final Set<String> selectedLanguages;
  final List<String> customLanguages;
  
  // Step 8: Payment
  final String paymentExpectations;
  final bool acceptsTicketCompensation;
  
  // Step 9: Email consent
  final bool emailOptIn;

  const TalentProfileWizardState({
    this.currentStep = 1,
    this.isSubmitting = false,
    this.errorMessage,
    this.selectedWorkTypes = const {},
    this.customWorkTypes = const [],
    this.locationCities = '',
    this.selectedDisciplines = const {},
    this.customDisciplines = const [],
    this.disciplineDetails = const {},
    this.certificationsText = '',
    this.certificateCards = const [],
    this.experienceLength = '',
    this.experienceDescription = '',
    this.selectedLanguages = const {},
    this.customLanguages = const [],
    this.paymentExpectations = '',
    this.acceptsTicketCompensation = false,
    this.emailOptIn = false,
  });

  TalentProfileWizardState copyWith({
    int? currentStep,
    bool? isSubmitting,
    String? errorMessage,
    Set<String>? selectedWorkTypes,
    List<String>? customWorkTypes,
    String? locationCities,
    Set<String>? selectedDisciplines,
    List<String>? customDisciplines,
    Map<String, String>? disciplineDetails,
    String? certificationsText,
    List<String>? certificateCards,
    String? experienceLength,
    String? experienceDescription,
    Set<String>? selectedLanguages,
    List<String>? customLanguages,
    String? paymentExpectations,
    bool? acceptsTicketCompensation,
    bool? emailOptIn,
  }) {
    return TalentProfileWizardState(
      currentStep: currentStep ?? this.currentStep,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      selectedWorkTypes: selectedWorkTypes ?? this.selectedWorkTypes,
      customWorkTypes: customWorkTypes ?? this.customWorkTypes,
      locationCities: locationCities ?? this.locationCities,
      selectedDisciplines: selectedDisciplines ?? this.selectedDisciplines,
      customDisciplines: customDisciplines ?? this.customDisciplines,
      disciplineDetails: disciplineDetails ?? this.disciplineDetails,
      certificationsText: certificationsText ?? this.certificationsText,
      certificateCards: certificateCards ?? this.certificateCards,
      experienceLength: experienceLength ?? this.experienceLength,
      experienceDescription: experienceDescription ?? this.experienceDescription,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      customLanguages: customLanguages ?? this.customLanguages,
      paymentExpectations: paymentExpectations ?? this.paymentExpectations,
      acceptsTicketCompensation: acceptsTicketCompensation ?? this.acceptsTicketCompensation,
      emailOptIn: emailOptIn ?? this.emailOptIn,
    );
  }

  /// Get all disciplines (selected + custom)
  List<String> get allDisciplines {
    return [...selectedDisciplines, ...customDisciplines];
  }

  /// Get all work types as comma-separated string
  String get workTypesText {
    final all = [...selectedWorkTypes, ...customWorkTypes];
    return all.join(', ');
  }

  /// Get all disciplines as comma-separated string
  String get disciplinesText {
    return allDisciplines.join(', ');
  }

  /// Get discipline details as JSON string
  String get disciplineDetailsText {
    if (disciplineDetails.isEmpty) return '';
    return jsonEncode(disciplineDetails);
  }

  /// Get certifications as combined text
  String get combinedCertificationsText {
    final parts = <String>[];
    if (certificationsText.isNotEmpty) {
      parts.add(certificationsText);
    }
    if (certificateCards.isNotEmpty) {
      parts.addAll(certificateCards);
    }
    return parts.join('\n• ');
  }

  /// Get all languages as comma-separated string
  String get languagesText {
    final all = [...selectedLanguages, ...customLanguages];
    return all.join(', ');
  }

  /// Check if current step is valid
  bool isStepValid(int step) {
    switch (step) {
      case 1:
        return selectedWorkTypes.isNotEmpty || customWorkTypes.isNotEmpty;
      case 2:
        return locationCities.trim().isNotEmpty;
      case 3:
        return selectedDisciplines.isNotEmpty || customDisciplines.isNotEmpty;
      case 4:
        // Discipline details are optional but we need at least one entry
        return allDisciplines.isEmpty || disciplineDetails.isNotEmpty;
      case 5:
        return true; // Certificates are optional
      case 6:
        return experienceLength.trim().isNotEmpty;
      case 7:
        return selectedLanguages.isNotEmpty || customLanguages.isNotEmpty;
      case 8:
        return true; // Payment is optional
      case 9:
        return emailOptIn; // Must be true to submit
      default:
        return false;
    }
  }

  /// Check if can proceed to next step
  bool get canProceed => isStepValid(currentStep);

  /// Check if can go back
  bool get canGoBack => currentStep > 1;

  /// Check if on final step
  bool get isLastStep => currentStep == totalWizardSteps;
}

/// Notifier for talent profile wizard state
class TalentProfileWizardNotifier extends StateNotifier<TalentProfileWizardState> {
  final Ref _ref;
  final TalentProfileService _service;

  TalentProfileWizardNotifier(this._ref) 
      : _service = TalentProfileService(),
        super(const TalentProfileWizardState());

  /// Navigate to next step
  void nextStep() {
    if (state.currentStep < totalWizardSteps && state.canProceed) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  /// Navigate to previous step
  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Go to specific step
  void goToStep(int step) {
    if (step >= 1 && step <= totalWizardSteps) {
      state = state.copyWith(currentStep: step);
    }
  }

  // Step 1: Work types
  void toggleWorkType(String workType) {
    final newSet = Set<String>.from(state.selectedWorkTypes);
    if (newSet.contains(workType)) {
      newSet.remove(workType);
    } else {
      newSet.add(workType);
    }
    state = state.copyWith(selectedWorkTypes: newSet);
  }

  void addCustomWorkType(String workType) {
    if (workType.trim().isEmpty) return;
    final newList = List<String>.from(state.customWorkTypes);
    if (!newList.contains(workType.trim())) {
      newList.add(workType.trim());
    }
    state = state.copyWith(customWorkTypes: newList);
  }

  void removeCustomWorkType(String workType) {
    final newList = List<String>.from(state.customWorkTypes);
    newList.remove(workType);
    state = state.copyWith(customWorkTypes: newList);
  }

  // Step 2: Location
  void setLocationCities(String cities) {
    state = state.copyWith(locationCities: cities);
  }

  // Step 3: Disciplines
  void toggleDiscipline(String discipline) {
    final newSet = Set<String>.from(state.selectedDisciplines);
    if (newSet.contains(discipline)) {
      newSet.remove(discipline);
      // Also remove details for this discipline
      final newDetails = Map<String, String>.from(state.disciplineDetails);
      newDetails.remove(discipline);
      state = state.copyWith(
        selectedDisciplines: newSet,
        disciplineDetails: newDetails,
      );
    } else {
      newSet.add(discipline);
      state = state.copyWith(selectedDisciplines: newSet);
    }
  }

  void addCustomDiscipline(String discipline) {
    if (discipline.trim().isEmpty) return;
    final newList = List<String>.from(state.customDisciplines);
    if (!newList.contains(discipline.trim())) {
      newList.add(discipline.trim());
    }
    state = state.copyWith(customDisciplines: newList);
  }

  void removeCustomDiscipline(String discipline) {
    final newList = List<String>.from(state.customDisciplines);
    newList.remove(discipline);
    // Also remove details for this discipline
    final newDetails = Map<String, String>.from(state.disciplineDetails);
    newDetails.remove(discipline);
    state = state.copyWith(
      customDisciplines: newList,
      disciplineDetails: newDetails,
    );
  }

  // Step 4: Discipline details
  void setDisciplineDetail(String discipline, String detail) {
    final newDetails = Map<String, String>.from(state.disciplineDetails);
    newDetails[discipline] = detail;
    state = state.copyWith(disciplineDetails: newDetails);
  }

  // Step 5: Certificates
  void setCertificationsText(String text) {
    state = state.copyWith(certificationsText: text);
  }

  void addCertificateCard(String title) {
    if (title.trim().isEmpty) return;
    final newList = List<String>.from(state.certificateCards);
    if (!newList.contains(title.trim())) {
      newList.add(title.trim());
    }
    state = state.copyWith(certificateCards: newList);
  }

  void removeCertificateCard(String title) {
    final newList = List<String>.from(state.certificateCards);
    newList.remove(title);
    state = state.copyWith(certificateCards: newList);
  }

  // Step 6: Experience
  void setExperienceLength(String length) {
    state = state.copyWith(experienceLength: length);
  }

  void setExperienceDescription(String description) {
    state = state.copyWith(experienceDescription: description);
  }

  // Step 7: Languages
  void toggleLanguage(String language) {
    final newSet = Set<String>.from(state.selectedLanguages);
    if (newSet.contains(language)) {
      newSet.remove(language);
    } else {
      newSet.add(language);
    }
    state = state.copyWith(selectedLanguages: newSet);
  }

  void addCustomLanguage(String language) {
    if (language.trim().isEmpty) return;
    final newList = List<String>.from(state.customLanguages);
    if (!newList.contains(language.trim())) {
      newList.add(language.trim());
    }
    state = state.copyWith(customLanguages: newList);
  }

  void removeCustomLanguage(String language) {
    final newList = List<String>.from(state.customLanguages);
    newList.remove(language);
    state = state.copyWith(customLanguages: newList);
  }

  // Step 8: Payment
  void setPaymentExpectations(String expectations) {
    state = state.copyWith(paymentExpectations: expectations);
  }

  void setAcceptsTicketCompensation(bool accepts) {
    state = state.copyWith(acceptsTicketCompensation: accepts);
  }

  // Step 9: Email consent
  void setEmailOptIn(bool optIn) {
    state = state.copyWith(emailOptIn: optIn);
  }

  /// Submit the talent profile
  Future<bool> submit() async {
    if (!state.emailOptIn) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final user = await _ref.read(userRiverpodProvider.future);
      if (user?.id == null) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'User not authenticated',
        );
        return false;
      }

      final result = await _service.createTalentProfile(
        userId: user!.id!,
        workTypesText: state.workTypesText,
        locationCitiesText: state.locationCities,
        disciplinesText: state.disciplinesText,
        disciplineDetailsText: state.disciplineDetailsText,
        certificationsText: state.combinedCertificationsText,
        experienceLength: state.experienceLength,
        experienceDescription: state.experienceDescription,
        languagesText: state.languagesText,
        paymentExpectations: state.paymentExpectations,
        acceptsTicketCompensation: state.acceptsTicketCompensation,
        emailOptIn: state.emailOptIn,
      );

      if (result != null) {
        // Invalidate the exists provider to refresh UI
        _ref.invalidate(talentProfileExistsProvider);
        state = state.copyWith(isSubmitting: false);
        return true;
      } else {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to create profile. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'An error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Reset the wizard state
  void reset() {
    state = const TalentProfileWizardState();
  }
}

/// Provider for talent profile wizard state
final talentProfileWizardProvider =
    StateNotifierProvider.autoDispose<TalentProfileWizardNotifier, TalentProfileWizardState>(
  (ref) => TalentProfileWizardNotifier(ref),
);

