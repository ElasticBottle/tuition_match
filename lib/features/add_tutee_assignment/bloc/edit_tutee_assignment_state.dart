part of 'edit_tutee_assignment_bloc.dart';

class EditTuteeAssignmentState extends Equatable {
  const EditTuteeAssignmentState({
    this.subjectsToDisplay,
    this.subjectHint,
    this.initialRateMin,
    this.initialRateMax,
    this.initialTiming,
    this.initiallocation,
    this.initialFreq,
    this.initialAdditionalRemarks,
    this.levels,
    this.subjects,
    this.classFormatSelection,
    this.genderSelection,
    this.rateTypeSelction,
    this.tutorOccupation,
    this.isAcceptingTutors,
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
    this.isTutorOccupationsValid,
    this.isSubmitting,
    this.isSuccess,
    this.isFailure,
    this.failureMessage,
  });

  factory EditTuteeAssignmentState.initial() {
    return EditTuteeAssignmentState(
      subjectsToDisplay: [],
      subjectHint: 'Please select a level first',
      genderSelection: [0, 1],
      classFormatSelection: [1],
      levels: [],
      tutorOccupation: [],
      rateTypeSelction: 0,
      subjects: [],
      initialRateMin: '',
      initialRateMax: '',
      initialTiming: '',
      initiallocation: '',
      initialFreq: '',
      initialAdditionalRemarks: '',
      isAcceptingTutors: true,
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
      isTutorOccupationsValid: true,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false,
      failureMessage: null,
    );
  }

  final List<String> subjectsToDisplay;
  final String subjectHint;
  final String initialRateMin;
  final String initialRateMax;
  final String initialTiming;
  final String initiallocation;
  final String initialFreq;
  final String initialAdditionalRemarks;
  final List<String> levels;
  final List<String> subjects;
  final List<int> classFormatSelection;
  final List<int> genderSelection;
  final int rateTypeSelction;
  final List<String> tutorOccupation;
  final bool isAcceptingTutors;
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
  final bool isTutorOccupationsValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String failureMessage;

  bool isValid() {
    return isRateMinValid &&
        isRateMaxValid &&
        isTimingValid &&
        isLocationValid &&
        isFreqValid &&
        isAdditionalRemarksValid &&
        isSelectedLevelsValid &&
        isSelectedSubjectsValid &&
        isClassFormatsValid &&
        isGenderValid &&
        isTypeRateValid &&
        isTutorOccupationsValid;
  }

  EditTuteeAssignmentState success() {
    return copyWith(
      isFailure: false,
      isSubmitting: false,
      isSuccess: true,
      failureMessage: null,
    );
  }

  EditTuteeAssignmentState failure(String msg) {
    return copyWith(
      isFailure: true,
      isSubmitting: false,
      isSuccess: false,
      failureMessage: msg,
    );
  }

  EditTuteeAssignmentState loading() {
    return copyWith(isSubmitting: true);
  }

  EditTuteeAssignmentState update({
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
    bool isTutorOccupationsValid,
  }) {
    return copyWith(
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
      isTutorOccupationsValid: isTutorOccupationsValid,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false,
      failureMessage: null,
    );
  }

  EditTuteeAssignmentState copyWith({
    List<String> subjectsToDisplay,
    String subjectHint,
    String initialRateMin,
    String initialRateMax,
    String initialTiming,
    String initiallocation,
    String initialFreq,
    String initialAdditionalRemarks,
    List<String> levels,
    List<String> subjects,
    List<int> classFormatSelection,
    List<int> genderSelection,
    int rateTypeSelction,
    List<String> tutorOccupation,
    bool isAcceptingTutors,
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
    bool isTutorOccupationsValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  }) {
    return EditTuteeAssignmentState(
      subjectsToDisplay: subjectsToDisplay ?? this.subjectsToDisplay,
      subjectHint: subjectHint ?? this.subjectHint,
      initialRateMin: initialRateMin ?? this.initialRateMin,
      initialRateMax: initialRateMax ?? this.initialRateMax,
      initialTiming: initialTiming ?? this.initialTiming,
      initiallocation: initiallocation ?? this.initiallocation,
      initialFreq: initialFreq ?? this.initialFreq,
      initialAdditionalRemarks:
          initialAdditionalRemarks ?? this.initialAdditionalRemarks,
      levels: levels ?? this.levels,
      subjects: subjects ?? this.subjects,
      classFormatSelection: classFormatSelection ?? this.classFormatSelection,
      genderSelection: genderSelection ?? this.genderSelection,
      rateTypeSelction: rateTypeSelction ?? this.rateTypeSelction,
      tutorOccupation: tutorOccupation ?? this.tutorOccupation,
      isAcceptingTutors: isAcceptingTutors ?? this.isAcceptingTutors,
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
      isTutorOccupationsValid:
          isTutorOccupationsValid ?? this.isTutorOccupationsValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object> get props => [
        subjectsToDisplay,
        subjectHint,
        initialRateMin,
        initialRateMax,
        initialTiming,
        initiallocation,
        initialFreq,
        initialAdditionalRemarks,
        levels,
        subjects,
        classFormatSelection,
        genderSelection,
        rateTypeSelction,
        tutorOccupation,
        isAcceptingTutors,
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
        isTutorOccupationsValid,
        isSubmitting,
        isSuccess,
        isFailure,
        failureMessage,
      ];

  @override
  String toString() {
    return '''EditTuteeAssignmentState(
      subjectsToDisplay: $subjectsToDisplay,
      subjectHint : $subjectHint,
      initialRateMin: $initialRateMin, 
      initialRateMax: $initialRateMax, 
      initialTiming: $initialTiming, 
      initiallocation: $initiallocation, 
      initialFreq: $initialFreq, 
      initialAdditionalRemarks: $initialAdditionalRemarks, 
      levels: $levels, subjects: $subjects, 
      classFormatSelection: $classFormatSelection, 
      genderSelection: $genderSelection,
      rateTypeSelction: $rateTypeSelction, 
      tutorOccupation: $tutorOccupation, 
      isAcceptingTutors: $isAcceptingTutors, 
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
      isTutorOccupationValid: $isTutorOccupationsValid, 
      isSubmitting: $isSubmitting, 
      isSuccess: $isSuccess, 
      isFailure: $isFailure, 
      failureMessage: $failureMessage)''';
  }
}
