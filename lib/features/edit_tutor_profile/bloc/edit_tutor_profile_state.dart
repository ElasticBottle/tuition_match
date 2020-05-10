part of 'edit_tutor_profile_bloc.dart';

class EditTutorProfileState extends Equatable {
  const EditTutorProfileState({
    this.tutorOccupationLabels,
    this.rateTypeLabels,
    this.genderLabels,
    this.classFormatLabels,
    this.levelsLabels,
    this.subjectsLabels,
    this.subjectHint,
    this.initialRateMin,
    this.initialRateMax,
    this.initialTiming,
    this.initiallocation,
    this.initialQualification,
    this.initialSellingPoint,
    this.levelsTaught,
    this.subjectsTaught,
    this.classFormatSelection,
    this.genderSelection,
    this.rateTypeSelction,
    this.tutorOccupation,
    this.isAcceptingStudent,
    this.isRateMinValid,
    this.isRateMaxValid,
    this.isTimingValid,
    this.isLocationValid,
    this.isQualificationValid,
    this.isSellingPointValid,
    this.isSelectedLevelsTaughtValid,
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

  factory EditTutorProfileState.initial() {
    return EditTutorProfileState(
      rateTypeLabels: RateTypes.types.map((e) => e.toString()).toList(),
      genderLabels: Gender.genders.map((e) => e.toString()).toList(),
      classFormatLabels: ClassFormat.formats.map((e) => e.toString()).toList(),
      tutorOccupationLabels:
          TutorOccupation.occupations.map((e) => e.toString()).toList(),
      levelsLabels: Level.all.map((e) => e.toString()).toList(),
      subjectsLabels: const [],
      subjectHint: 'Please select a level first',
      genderSelection: 0,
      classFormatSelection: const [1],
      levelsTaught: const [],
      subjectsTaught: const [],
      tutorOccupation: null,
      rateTypeSelction: 0,
      initialRateMin: '0',
      initialRateMax: '100',
      initialTiming: '',
      initiallocation: '',
      initialQualification: '',
      initialSellingPoint: '',
      isAcceptingStudent: true,
      isRateMinValid: true,
      isRateMaxValid: true,
      isTimingValid: true,
      isLocationValid: true,
      isQualificationValid: true,
      isSellingPointValid: true,
      isSelectedLevelsTaughtValid: true,
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

  final List<String> tutorOccupationLabels;
  final List<String> rateTypeLabels;
  final List<String> genderLabels;
  final List<String> classFormatLabels;
  final List<String> levelsLabels;
  final List<String> subjectsLabels;
  final String subjectHint;
  final String initialRateMin;
  final String initialRateMax;
  final String initialTiming;
  final String initiallocation;
  final String initialQualification;
  final String initialSellingPoint;
  final List<String> levelsTaught;
  final List<String> subjectsTaught;
  final List<int> classFormatSelection;
  final int genderSelection;
  final int rateTypeSelction;
  final String tutorOccupation;
  final bool isAcceptingStudent;
  final bool isRateMinValid;
  final bool isRateMaxValid;
  final bool isTimingValid;
  final bool isLocationValid;
  final bool isQualificationValid;
  final bool isSellingPointValid;
  final bool isSelectedLevelsTaughtValid;
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
        isTimingValid &&
        isLocationValid &&
        isQualificationValid &&
        isSellingPointValid &&
        isSelectedLevelsTaughtValid &&
        isSelectedSubjectsValid &&
        isClassFormatsValid &&
        isGenderValid &&
        isTypeRateValid &&
        isTutorOccupationValid;
  }

  EditTutorProfileState success(String msg) {
    return copyWith(
      isFailure: false,
      isSubmitting: false,
      isSuccess: true,
      failureMessage: null,
      successMessage: msg,
    );
  }

  EditTutorProfileState failure(String msg) {
    return copyWith(
      isFailure: true,
      isSubmitting: false,
      isSuccess: false,
      failureMessage: msg,
      successMessage: null,
    );
  }

  EditTutorProfileState loading() {
    return copyWith(
      isSubmitting: true,
      isFailure: false,
      isSuccess: false,
      failureMessage: null,
      successMessage: null,
    );
  }

  EditTutorProfileState update({
    List<String> tutorOccupationLabels,
    List<String> rateTypeLabels,
    List<String> genderLabels,
    List<String> classFormatLabels,
    List<String> levelsLabels,
    List<String> subjectsLabels,
    String subjectHint,
    String initialRateMin,
    String initialRateMax,
    String initialTiming,
    String initiallocation,
    String initialQualification,
    String initialSellingPoint,
    List<String> levelsTaught,
    List<String> subjectsTaught,
    List<int> classFormatSelection,
    int genderSelection,
    int rateTypeSelction,
    String tutorOccupation,
    bool isAcceptingStudent,
    bool isRateMinValid,
    bool isRateMaxValid,
    bool isTimingValid,
    bool isLocationValid,
    bool isQualificationValid,
    bool isSellingPointValid,
    bool isSelectedLevelsTaughtValid,
    bool isSelectedSubjectsValid,
    bool isClassFormatsValid,
    bool isGenderValid,
    bool isTypeRateValid,
    bool isTutorOccupationValid,
  }) {
    return copyWith(
      subjectsLabels: subjectsLabels,
      subjectHint: subjectHint,
      initialRateMin: initialRateMin,
      initialRateMax: initialRateMax,
      initialTiming: initialTiming,
      initiallocation: initiallocation,
      initialQualification: initialQualification,
      initialSellingPoint: initialSellingPoint,
      levelsTaught: levelsTaught,
      subjectsTaught: subjectsTaught,
      classFormatSelection: classFormatSelection,
      genderSelection: genderSelection,
      rateTypeSelction: rateTypeSelction,
      tutorOccupation: tutorOccupation,
      isAcceptingStudent: isAcceptingStudent,
      isRateMinValid: isRateMinValid,
      isRateMaxValid: isRateMaxValid,
      isTimingValid: isTimingValid,
      isLocationValid: isLocationValid,
      isQualificationValid: isQualificationValid,
      isSellingPointValid: isSellingPointValid,
      isSelectedLevelsTaughtValid: isSelectedLevelsTaughtValid,
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

  EditTutorProfileState copyWith({
    List<String> tutorOccupationLabels,
    List<String> rateTypeLabels,
    List<String> genderLabels,
    List<String> classFormatLabels,
    List<String> levelsLabels,
    List<String> subjectsLabels,
    String subjectHint,
    String initialRateMin,
    String initialRateMax,
    String initialTiming,
    String initiallocation,
    String initialQualification,
    String initialSellingPoint,
    List<String> levelsTaught,
    List<String> subjectsTaught,
    List<int> classFormatSelection,
    int genderSelection,
    int rateTypeSelction,
    String tutorOccupation,
    bool isAcceptingStudent,
    bool isRateMinValid,
    bool isRateMaxValid,
    bool isTimingValid,
    bool isLocationValid,
    bool isQualificationValid,
    bool isSellingPointValid,
    bool isSelectedLevelsTaughtValid,
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
    return EditTutorProfileState(
      subjectsLabels: subjectsLabels ?? this.subjectsLabels,
      subjectHint: subjectHint ?? this.subjectHint,
      initialRateMin: initialRateMin ?? this.initialRateMin,
      initialRateMax: initialRateMax ?? this.initialRateMax,
      initialTiming: initialTiming ?? this.initialTiming,
      initiallocation: initiallocation ?? this.initiallocation,
      initialQualification: initialQualification ?? this.initialQualification,
      initialSellingPoint: initialSellingPoint ?? this.initialSellingPoint,
      levelsTaught: levelsTaught ?? this.levelsTaught,
      subjectsTaught: subjectsTaught ?? this.subjectsTaught,
      classFormatSelection: classFormatSelection ?? this.classFormatSelection,
      genderSelection: genderSelection ?? this.genderSelection,
      rateTypeSelction: rateTypeSelction ?? this.rateTypeSelction,
      tutorOccupation: tutorOccupation ?? this.tutorOccupation,
      isAcceptingStudent: isAcceptingStudent ?? this.isAcceptingStudent,
      isRateMinValid: isRateMinValid ?? this.isRateMinValid,
      isRateMaxValid: isRateMaxValid ?? this.isRateMaxValid,
      isTimingValid: isTimingValid ?? this.isTimingValid,
      isLocationValid: isLocationValid ?? this.isLocationValid,
      isQualificationValid: isQualificationValid ?? this.isQualificationValid,
      isSellingPointValid: isSellingPointValid ?? this.isSellingPointValid,
      isSelectedLevelsTaughtValid:
          isSelectedLevelsTaughtValid ?? this.isSelectedLevelsTaughtValid,
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
        tutorOccupationLabels,
        rateTypeLabels,
        genderLabels,
        classFormatLabels,
        levelsLabels,
        subjectsLabels,
        subjectHint,
        initialRateMin,
        initialRateMax,
        initialTiming,
        initiallocation,
        initialQualification,
        initialSellingPoint,
        levelsTaught,
        subjectsTaught,
        classFormatSelection,
        genderSelection,
        rateTypeSelction,
        tutorOccupation,
        isAcceptingStudent,
        isRateMinValid,
        isRateMaxValid,
        isTimingValid,
        isLocationValid,
        isQualificationValid,
        isSellingPointValid,
        isSelectedLevelsTaughtValid,
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
    return '''EditTutorProfileState(
      tutorOccupationLabels: $tutorOccupationLabels,
      rateTypeLabels: $rateTypeLabels,
      genderLabels: $genderLabels,
      classFormatLabels: $classFormatLabels,
      levelsLabels: $levelsLabels,
      subjectsToDisplay: $subjectsLabels,
      subjectHint : $subjectHint,
      initialRateMin: $initialRateMin, 
      initialRateMax: $initialRateMax, 
      initialTiming: $initialTiming, 
      initiallocation: $initiallocation, 
      initialQualification: $initialQualification, 
      initialSellingPoint: $initialSellingPoint, 
      levelsTaught: $levelsTaught, subjectsTaught: $subjectsTaught, 
      classFormatSelection: $classFormatSelection, 
      genderSelection: $genderSelection,
      rateTypeSelction: $rateTypeSelction, 
      tutorOccupation: $tutorOccupation, 
      isAcceptingStudent: $isAcceptingStudent, 
      isRateMinValid: $isRateMinValid, 
      isRateMaxValid: $isRateMaxValid, 
      isTimingValid: $isTimingValid, 
      isLocationValid: $isLocationValid,
      isQualificationValid: $isQualificationValid, 
      isSellingPointValid: $isSellingPointValid, 
      isSelectedLevelsTaughtValid: $isSelectedLevelsTaughtValid, 
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
