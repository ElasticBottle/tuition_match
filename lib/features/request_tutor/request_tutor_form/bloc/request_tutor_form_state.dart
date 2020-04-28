part of 'request_tutor_form_bloc.dart';

class RequestTutorFormState extends Equatable {
  const RequestTutorFormState({
    this.isNewAssignment,
    this.requestingProfile,
    this.userRefAssignment,
    this.levelsToDisplay,
    this.subjectsToDisplay,
    this.subjectHint,
    this.initialProposedRate,
    this.initialRateMin,
    this.initialRateMax,
    this.initialTiming,
    this.initiallocation,
    this.initialFreq,
    this.initialAdditionalRemarks,
    this.levels,
    this.subjects,
    this.classFormatsToDisplay,
    this.classFormatSelection,
    this.genderSelection,
    this.rateTypeSelction,
    this.tutorOccupation,
    this.saveForFuture,
    this.isPublic,
    this.isProposedRateValid,
    this.isRateMinValid,
    this.isRateMaxValid,
    this.isTimingValid,
    this.isLocationValid,
    this.isFreqValid,
    this.isAdditionalRemarksValid,
    this.isSelectedLevelsValid,
    this.isSelectedSubjectsValid,
    this.isClassFormatsValid,
    this.isGenderValid,
    this.isTypeRateValid,
    this.isTutorOccupationValid,
    this.isSubmitting,
    this.isSuccess,
    this.isFailure,
    this.failureMessage,
    this.successMessage,
  });

  factory RequestTutorFormState.initial() {
    return RequestTutorFormState(
      isNewAssignment: true,
      requestingProfile: TutorProfileModel.empty(),
      userRefAssignment: TuteeAssignmentModel(),
      levelsToDisplay: const [],
      subjectsToDisplay: const [],
      subjectHint: 'Please select a level first',
      genderSelection: const [],
      classFormatsToDisplay: const [],
      classFormatSelection: const [],
      levels: const [],
      subjects: const [],
      tutorOccupation: const [],
      rateTypeSelction: 0,
      initialRateMin: '0',
      initialRateMax: '100',
      initialProposedRate: '0',
      initialTiming: '',
      initiallocation: '',
      initialFreq: '',
      initialAdditionalRemarks: '',
      saveForFuture: true,
      isPublic: false,
      isProposedRateValid: true,
      isRateMinValid: true,
      isRateMaxValid: true,
      isTimingValid: true,
      isLocationValid: true,
      isFreqValid: true,
      isAdditionalRemarksValid: true,
      isSelectedLevelsValid: true,
      isSelectedSubjectsValid: true,
      isClassFormatsValid: true,
      isGenderValid: true,
      isTypeRateValid: true,
      isTutorOccupationValid: true,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false,
      failureMessage: null,
      successMessage: null,
    );
  }

  final bool isNewAssignment;
  final TutorProfileModel requestingProfile;
  final TuteeAssignmentModel userRefAssignment;
  final List<String> subjectsToDisplay;
  final List<String> levelsToDisplay;
  final String subjectHint;
  final String initialRateMin;
  final String initialRateMax;
  final String initialProposedRate;
  final String initialTiming;
  final String initiallocation;
  final String initialFreq;
  final String initialAdditionalRemarks;
  final List<String> levels;
  final List<String> subjects;
  final List<String> classFormatsToDisplay;
  final List<int> classFormatSelection;
  final List<int> genderSelection;
  final int rateTypeSelction;
  final List<String> tutorOccupation;
  final bool isPublic;
  final bool saveForFuture;
  final bool isProposedRateValid;
  final bool isRateMinValid;
  final bool isRateMaxValid;
  final bool isTimingValid;
  final bool isLocationValid;
  final bool isFreqValid;
  final bool isAdditionalRemarksValid;
  final bool isSelectedLevelsValid;
  final bool isSelectedSubjectsValid;
  final bool isClassFormatsValid;
  final bool isGenderValid;
  final bool isTypeRateValid;
  final bool isTutorOccupationValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String failureMessage;
  final String successMessage;

  bool isValid() {
    return isRateMinValid &&
        isRateMaxValid &&
        isProposedRateValid &&
        isTimingValid &&
        isLocationValid &&
        isFreqValid &&
        isAdditionalRemarksValid &&
        isSelectedLevelsValid &&
        isSelectedSubjectsValid &&
        isClassFormatsValid &&
        isGenderValid &&
        isTypeRateValid &&
        isTutorOccupationValid;
  }

  RequestTutorFormState success(String msg) {
    return copyWith(
      isFailure: false,
      isSubmitting: false,
      isSuccess: true,
      failureMessage: null,
      successMessage: msg,
    );
  }

  RequestTutorFormState failure(String msg) {
    return copyWith(
      isFailure: true,
      isSubmitting: false,
      isSuccess: false,
      failureMessage: msg,
      successMessage: null,
    );
  }

  RequestTutorFormState loading() {
    return copyWith(
      isSubmitting: true,
      isFailure: false,
      isSuccess: false,
      failureMessage: null,
      successMessage: null,
    );
  }

  RequestTutorFormState update({
    bool isNewAssignment,
    TutorProfileModel requestingProfile,
    TuteeAssignmentModel userRefAssignment,
    List<String> levelsToDisplay,
    List<String> subjectsToDisplay,
    String subjectHint,
    String initialProposedRate,
    String initialRateMin,
    String initialRateMax,
    String initialTiming,
    String initiallocation,
    String initialFreq,
    String initialAdditionalRemarks,
    List<String> levels,
    List<String> subjects,
    List<String> classFormatsToDisplay,
    List<int> classFormatSelection,
    List<int> genderSelection,
    int rateTypeSelction,
    List<String> tutorOccupation,
    bool saveForFuture,
    bool isPublic,
    bool isRateMinValid,
    bool isRateMaxValid,
    bool isProposedRateValid,
    bool isTimingValid,
    bool isLocationValid,
    bool isFreqValid,
    bool isAdditionalRemarksValid,
    bool isSelectedLevelsValid,
    bool isSelectedSubjectsValid,
    bool isClassFormatsValid,
    bool isGenderValid,
    bool isTypeRateValid,
    bool isTutorOccupationValid,
  }) {
    return copyWith(
      isNewAssignment: isNewAssignment,
      requestingProfile: requestingProfile,
      userRefAssignment: userRefAssignment,
      levelsToDisplay: levelsToDisplay,
      subjectsToDisplay: subjectsToDisplay,
      subjectHint: subjectHint,
      initialProposedRate: initialProposedRate,
      initialRateMin: initialRateMin,
      initialRateMax: initialRateMax,
      initialTiming: initialTiming,
      initiallocation: initiallocation,
      initialFreq: initialFreq,
      initialAdditionalRemarks: initialAdditionalRemarks,
      levels: levels,
      subjects: subjects,
      classFormatsToDisplay: classFormatsToDisplay,
      classFormatSelection: classFormatSelection,
      genderSelection: genderSelection,
      rateTypeSelction: rateTypeSelction,
      tutorOccupation: tutorOccupation,
      saveForFuture: saveForFuture,
      isPublic: isPublic,
      isProposedRateValid: isProposedRateValid,
      isRateMinValid: isRateMinValid,
      isRateMaxValid: isRateMaxValid,
      isTimingValid: isTimingValid,
      isLocationValid: isLocationValid,
      isFreqValid: isFreqValid,
      isAdditionalRemarksValid: isAdditionalRemarksValid,
      isSelectedLevelsValid: isSelectedLevelsValid,
      isSelectedSubjectsValid: isSelectedSubjectsValid,
      isClassFormatsValid: isClassFormatsValid,
      isGenderValid: isGenderValid,
      isTypeRateValid: isTypeRateValid,
      isTutorOccupationValid: isTutorOccupationValid,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
      failureMessage: null,
      successMessage: null,
    );
  }

  RequestTutorFormState copyWith({
    bool isNewAssignment,
    TutorProfileModel requestingProfile,
    TuteeAssignmentModel userRefAssignment,
    List<String> levelsToDisplay,
    List<String> subjectsToDisplay,
    String subjectHint,
    String initialProposedRate,
    String initialRateMin,
    String initialRateMax,
    String initialTiming,
    String initiallocation,
    String initialFreq,
    String initialAdditionalRemarks,
    List<String> levels,
    List<String> subjects,
    List<String> classFormatsToDisplay,
    List<int> classFormatSelection,
    List<int> genderSelection,
    int rateTypeSelction,
    List<String> tutorOccupation,
    bool saveForFuture,
    bool isPublic,
    bool isProposedRateValid,
    bool isRateMinValid,
    bool isRateMaxValid,
    bool isTimingValid,
    bool isLocationValid,
    bool isFreqValid,
    bool isAdditionalRemarksValid,
    bool isSelectedLevelsValid,
    bool isSelectedSubjectsValid,
    bool isClassFormatsValid,
    bool isGenderValid,
    bool isTypeRateValid,
    bool isTutorOccupationValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
    String successMessage,
  }) {
    return RequestTutorFormState(
      isNewAssignment: isNewAssignment ?? this.isNewAssignment,
      requestingProfile: requestingProfile ?? this.requestingProfile,
      userRefAssignment: userRefAssignment ?? this.userRefAssignment,
      levelsToDisplay: levelsToDisplay ?? this.levelsToDisplay,
      subjectsToDisplay: subjectsToDisplay ?? this.subjectsToDisplay,
      subjectHint: subjectHint ?? this.subjectHint,
      initialProposedRate: initialProposedRate ?? this.initialProposedRate,
      initialRateMin: initialRateMin ?? this.initialRateMin,
      initialRateMax: initialRateMax ?? this.initialRateMax,
      initialTiming: initialTiming ?? this.initialTiming,
      initiallocation: initiallocation ?? this.initiallocation,
      initialFreq: initialFreq ?? this.initialFreq,
      initialAdditionalRemarks:
          initialAdditionalRemarks ?? this.initialAdditionalRemarks,
      levels: levels ?? this.levels,
      subjects: subjects ?? this.subjects,
      classFormatsToDisplay:
          classFormatsToDisplay ?? this.classFormatsToDisplay,
      classFormatSelection: classFormatSelection ?? this.classFormatSelection,
      genderSelection: genderSelection ?? this.genderSelection,
      rateTypeSelction: rateTypeSelction ?? this.rateTypeSelction,
      tutorOccupation: tutorOccupation ?? this.tutorOccupation,
      saveForFuture: saveForFuture ?? this.saveForFuture,
      isPublic: isPublic ?? this.isPublic,
      isProposedRateValid: isProposedRateValid ?? this.isProposedRateValid,
      isRateMinValid: isRateMinValid ?? this.isRateMinValid,
      isRateMaxValid: isRateMaxValid ?? this.isRateMaxValid,
      isTimingValid: isTimingValid ?? this.isTimingValid,
      isLocationValid: isLocationValid ?? this.isLocationValid,
      isFreqValid: isFreqValid ?? this.isFreqValid,
      isAdditionalRemarksValid:
          isAdditionalRemarksValid ?? this.isAdditionalRemarksValid,
      isSelectedLevelsValid:
          isSelectedLevelsValid ?? this.isSelectedLevelsValid,
      isSelectedSubjectsValid:
          isSelectedSubjectsValid ?? this.isSelectedSubjectsValid,
      isClassFormatsValid: isClassFormatsValid ?? this.isClassFormatsValid,
      isGenderValid: isGenderValid ?? this.isGenderValid,
      isTypeRateValid: isTypeRateValid ?? this.isTypeRateValid,
      isTutorOccupationValid:
          isTutorOccupationValid ?? this.isTutorOccupationValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage ?? this.failureMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object> get props => [
        isNewAssignment,
        requestingProfile,
        userRefAssignment,
        levelsToDisplay,
        subjectsToDisplay,
        subjectHint,
        initialProposedRate,
        initialRateMin,
        initialRateMax,
        initialTiming,
        initiallocation,
        initialFreq,
        initialAdditionalRemarks,
        levels,
        subjects,
        classFormatsToDisplay,
        classFormatSelection,
        genderSelection,
        rateTypeSelction,
        tutorOccupation,
        saveForFuture,
        isPublic,
        isProposedRateValid,
        isRateMinValid,
        isRateMaxValid,
        isTimingValid,
        isLocationValid,
        isFreqValid,
        isAdditionalRemarksValid,
        isSelectedLevelsValid,
        isSelectedSubjectsValid,
        isClassFormatsValid,
        isGenderValid,
        isTypeRateValid,
        isTutorOccupationValid,
        isSubmitting,
        isSuccess,
        isFailure,
        failureMessage,
        successMessage,
      ];

  @override
  String toString() {
    return '''RequestTutorFormState(
      isNewAssignment: $isNewAssignment,
      requestingProfile: $requestingProfile,
      userRefAssignment: $userRefAssignment,
      levelsToDisplay: $levelsToDisplay,
      subjectsToDisplay: $subjectsToDisplay,
      subjectHint : $subjectHint,
      initialPropsedRate: $initialProposedRate,
      initialRateMin: $initialRateMin, 
      initialRateMax: $initialRateMax, 
      initialTiming: $initialTiming, 
      initiallocation: $initiallocation, 
      initialFreq: $initialFreq, 
      initialAdditionalRemarks: $initialAdditionalRemarks, 
      levels: $levels, subjects: $subjects, 
      classFormatsToDisplay: $classFormatsToDisplay,
      classFormatSelection: $classFormatSelection, 
      genderSelection: $genderSelection,
      rateTypeSelction: $rateTypeSelction, 
      tutorOccupation: $tutorOccupation, 
      saveForFuture: $saveForFuture,
      isPublic: $isPublic, 
      isProposedRateValid: $isProposedRateValid,
      isRateMinValid: $isRateMinValid, 
      isRateMaxValid: $isRateMaxValid, 
      isTimingValid: $isTimingValid, 
      isLocationValid: $isLocationValid,
      isFreqValid: $isFreqValid, 
      isAdditionalRemarksValid: $isAdditionalRemarksValid, 
      isSelectedLevelsValid: $isSelectedLevelsValid, 
      isSelectedSubjectsValid: $isSelectedSubjectsValid, 
      isClassFormatsValid: $isClassFormatsValid, 
      isGenderValid: $isGenderValid, 
      isTypeRateValid: $isTypeRateValid, 
      isTutorOccupationValid: $isTutorOccupationValid, 
      isSubmitting: $isSubmitting, 
      isSuccess: $isSuccess, 
      isFailure: $isFailure, 
      failureMessage: $failureMessage,
      successMessage: $successMessage)''';
  }
}
