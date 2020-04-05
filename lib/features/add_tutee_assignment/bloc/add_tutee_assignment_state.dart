part of 'add_tutee_assignment_bloc.dart';

class AddTuteeFormState extends Equatable {
  const AddTuteeFormState({
    this.genderError,
    this.occupationError,
    this.formatError,
    this.locationError,
    this.timingError,
    this.freqError,
    this.rateMinError,
    this.rateMaxError,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.currentLevel,
    @required this.currentLevelIndex,
    @required this.currentSpecificLevel,
    @required this.currentSpecificLevelIndex,
    @required this.currentSubject,
    @required this.currentSubjectIndex,
    @required this.initialLevels,
    @required this.initialLevelsValue,
    @required this.specificLevels,
    @required this.specificLevelsValue,
    @required this.subjects,
  });

  final Level currentLevel;
  final int currentLevelIndex;
  final Level currentSpecificLevel;
  final int currentSpecificLevelIndex;
  final String currentSubject;
  final int currentSubjectIndex;
  final List<String> initialLevels;
  final List<Level> initialLevelsValue;
  final List<String> specificLevels;
  final List<Level> specificLevelsValue;
  final List<String> subjects;
  final String genderError;
  final String occupationError;
  final String formatError;
  final String locationError;
  final String timingError;
  final String freqError;
  final String rateMinError;
  final String rateMaxError;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  AddTuteeFormState copyWith({
    Level currentLevel,
    int currentLevelIndex,
    Level currentSpecificLevel,
    int currentSpecificLevelIndex,
    String currentSubject,
    int currentSubjectIndex,
    List<String> initialLevels,
    List<Level> initialLevelsValue,
    List<String> specificLevels,
    List<Level> specificLevelsValue,
    List<String> subjects,
    String genderError,
    String occupationError,
    String formatError,
    String locationError,
    String timingError,
    String freqError,
    String rateMinError,
    String rateMaxError,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return AddTuteeFormState(
      genderError: genderError,
      occupationError: occupationError,
      formatError: formatError,
      locationError: locationError,
      timingError: timingError,
      freqError: freqError,
      rateMinError: rateMinError,
      rateMaxError: rateMaxError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      currentLevel: currentLevel ?? this.currentLevel,
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      currentSpecificLevel: currentSpecificLevel ?? this.currentSpecificLevel,
      currentSpecificLevelIndex:
          currentSpecificLevelIndex ?? this.currentSpecificLevelIndex,
      currentSubject: currentSubject ?? this.currentSubject,
      currentSubjectIndex: currentSubjectIndex ?? this.currentSubjectIndex,
      initialLevels: initialLevels ?? this.initialLevels,
      initialLevelsValue: initialLevelsValue ?? this.initialLevelsValue,
      specificLevels: specificLevels ?? this.specificLevels,
      specificLevelsValue: specificLevelsValue ?? this.specificLevelsValue,
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object> get props => [
        genderError,
        occupationError,
        formatError,
        locationError,
        timingError,
        freqError,
        rateMinError,
        rateMaxError,
        isSubmitting,
        isSuccess,
        isFailure,
        currentLevel,
        currentLevelIndex,
        currentSpecificLevel,
        currentSpecificLevelIndex,
        currentSubject,
        currentSubjectIndex,
        initialLevels,
        initialLevelsValue,
        specificLevels,
        specificLevelsValue,
        subjects,
      ];

  @override
  String toString() => '''AddTuteeFormState {
    currentLevel : $currentLevel,
    currentLevelIndex: $currentLevelIndex,
    currentSpecificLevel: $currentSpecificLevel,
    currentSpecificLevelIndex: $currentSpecificLevelIndex,
    currentSubject: $currentSubject,
    currentSubjectIndex: $currentSubjectIndex,
    initialLevel: $initialLevels,
    initialLevelValues: $initialLevelsValue,
    specificLevels: $specificLevels,
    specificLevelsValue: $specificLevelsValue,
    subjects: $subjects,
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    isFailure: $isFailure,
    genderError: $genderError,
    occupationError: $occupationError,
    formatError: $formatError,
    locationError: $locationError,
    timingError: $timingError,
    freqError: $freqError,
    rateMinError: $rateMinError,
    rateMaxError: $rateMaxError,
  }''';
}
