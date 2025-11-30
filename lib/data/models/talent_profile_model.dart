/// Model for talent profile data collected through the wizard
class TalentProfile {
  final String? id;
  final String? userId;
  final String? workTypesText;
  final String? locationCitiesText;
  final String? disciplinesText;
  final String? disciplineDetailsText;
  final String? certificationsText;
  final String? experienceLength;
  final String? experienceDescription;
  final String? languagesText;
  final String? paymentExpectations;
  final bool? acceptsTicketCompensation;
  final bool? emailOptIn;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TalentProfile({
    this.id,
    this.userId,
    this.workTypesText,
    this.locationCitiesText,
    this.disciplinesText,
    this.disciplineDetailsText,
    this.certificationsText,
    this.experienceLength,
    this.experienceDescription,
    this.languagesText,
    this.paymentExpectations,
    this.acceptsTicketCompensation,
    this.emailOptIn,
    this.createdAt,
    this.updatedAt,
  });

  factory TalentProfile.fromJson(Map<String, dynamic> json) {
    return TalentProfile(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      workTypesText: json['work_types_text'] as String?,
      locationCitiesText: json['location_cities_text'] as String?,
      disciplinesText: json['disciplines_text'] as String?,
      disciplineDetailsText: json['discipline_details_text'] as String?,
      certificationsText: json['certifications_text'] as String?,
      experienceLength: json['experience_length'] as String?,
      experienceDescription: json['experience_description'] as String?,
      languagesText: json['languages_text'] as String?,
      paymentExpectations: json['payment_expectations'] as String?,
      acceptsTicketCompensation: json['accepts_ticket_compensation'] as bool?,
      emailOptIn: json['email_opt_in'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (workTypesText != null) 'work_types_text': workTypesText,
      if (locationCitiesText != null) 'location_cities_text': locationCitiesText,
      if (disciplinesText != null) 'disciplines_text': disciplinesText,
      if (disciplineDetailsText != null)
        'discipline_details_text': disciplineDetailsText,
      if (certificationsText != null) 'certifications_text': certificationsText,
      if (experienceLength != null) 'experience_length': experienceLength,
      if (experienceDescription != null)
        'experience_description': experienceDescription,
      if (languagesText != null) 'languages_text': languagesText,
      if (paymentExpectations != null)
        'payment_expectations': paymentExpectations,
      if (acceptsTicketCompensation != null)
        'accepts_ticket_compensation': acceptsTicketCompensation,
      if (emailOptIn != null) 'email_opt_in': emailOptIn,
    };
  }

  TalentProfile copyWith({
    String? id,
    String? userId,
    String? workTypesText,
    String? locationCitiesText,
    String? disciplinesText,
    String? disciplineDetailsText,
    String? certificationsText,
    String? experienceLength,
    String? experienceDescription,
    String? languagesText,
    String? paymentExpectations,
    bool? acceptsTicketCompensation,
    bool? emailOptIn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TalentProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workTypesText: workTypesText ?? this.workTypesText,
      locationCitiesText: locationCitiesText ?? this.locationCitiesText,
      disciplinesText: disciplinesText ?? this.disciplinesText,
      disciplineDetailsText:
          disciplineDetailsText ?? this.disciplineDetailsText,
      certificationsText: certificationsText ?? this.certificationsText,
      experienceLength: experienceLength ?? this.experienceLength,
      experienceDescription:
          experienceDescription ?? this.experienceDescription,
      languagesText: languagesText ?? this.languagesText,
      paymentExpectations: paymentExpectations ?? this.paymentExpectations,
      acceptsTicketCompensation:
          acceptsTicketCompensation ?? this.acceptsTicketCompensation,
      emailOptIn: emailOptIn ?? this.emailOptIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

