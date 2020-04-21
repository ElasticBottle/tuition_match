import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/domain/entities/class_format.dart';
import 'package:cotor/domain/entities/gender.dart';
import 'package:cotor/domain/entities/rate_types.dart';
import 'package:cotor/domain/entities/subject.dart' as subject;
import 'package:cotor/domain/usecases/user/set_tutee_assignment.dart';
import 'package:cotor/domain/usecases/user/update_tutee_assignment.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part 'edit_tutee_assignment_event.dart';
part 'edit_tutee_assignment_state.dart';

class EditTuteeAssignmentBloc
    extends Bloc<EditTuteeAssignmentEvent, EditTuteeAssignmentState> {
  EditTuteeAssignmentBloc({
    @required this.updateTuteeAssignment,
    @required this.validator,
    @required this.setTuteeAssignment,
  });
  final EmailAndPasswordValidators validator;
  final SetTuteeAssignment setTuteeAssignment;
  final UpdateTuteeAssignment updateTuteeAssignment;

  Map<String, dynamic> tuteeAssignmentInfo = <String, dynamic>{
    TUTOR_GENDER: EditTuteeAssignmentState.initial().genderSelection,
    CLASS_FORMATS: EditTuteeAssignmentState.initial().classFormatSelection,
    LEVELS: <dynamic>[],
    SUBJECTS: <dynamic>[],
    TUTOR_OCCUPATIONS: <dynamic>[],
    RATE_TYPE: EditTuteeAssignmentState.initial().rateTypeSelction,
  };
  // Map<String, String> stringValues = <String, String>{};
  UserModel userDetails;
  bool isUpdate;

  @override
  EditTuteeAssignmentState get initialState {
    return EditTuteeAssignmentState.initial();
  }

  @override
  Stream<EditTuteeAssignmentState> transformEvents(
      Stream<EditTuteeAssignmentEvent> events,
      Stream<EditTuteeAssignmentState> Function(EditTuteeAssignmentEvent)
          next) {
    final Stream<EditTuteeAssignmentEvent> debounceStream = events
        .where((event) =>
            event is CheckRatesAreValid ||
            event is CheckDropDownNotEmpty ||
            event is CheckTextFieldNotEmpty)
        .debounceTime(Duration(milliseconds: 300));
    final Stream<EditTuteeAssignmentEvent> nonDebounceStream = events.where(
        (event) =>
            events is! CheckRatesAreValid &&
            event is! CheckDropDownNotEmpty &&
            event is! CheckTextFieldNotEmpty);
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<EditTuteeAssignmentState> mapEventToState(
    EditTuteeAssignmentEvent event,
  ) async* {
    if (event is InitialiseEditTuteeFields) {
      yield* _mapInitialiseFieldsToState(
        event.userDetails,
        event.assignment,
      );
    } else if (event is CheckRatesAreValid) {
      yield* _mapCheckRatesAreValidToState(event.toCheck, event.fieldName);
    } else if (event is CheckTextFieldNotEmpty) {
      yield* _mapCheckTextFieldNotEmptyToState(event.toCheck, event.fieldName);
    } else if (event is CheckDropDownNotEmpty) {
      yield* _mapCheckDropDownNotEmptyToState(event.fieldName);
    } else if (event is HandleToggleButtonClick) {
      yield* _mapHandleToggleButtonClickToSate(event.fieldName, event.index);
    } else if (event is SaveField) {
      yield* _mapSaveFieldToState(event.key, value: event.value);
    } else if (event is SubmitForm) {
      yield* _mapSubmitFormToState();
    }
  }

  Stream<EditTuteeAssignmentState> _mapInitialiseFieldsToState(
    UserModel userDetails,
    TuteeAssignmentModel assignment,
  ) async* {
    this.userDetails = userDetails;
    isUpdate = !assignment.isEmpty();
    if (isUpdate) {
      yield state.copyWith(
          genderSelection: Gender.toIndices(assignment.tutorGender),
          levels: assignment.levels,
          subjects: assignment.subjects,
          tutorOccupation: assignment.tutorOccupation,
          rateTypeSelction: RateTypes.toIndex(assignment.rateType),
          classFormatSelection: ClassFormat.toIndices(assignment.formats),
          initialRateMin: assignment.rateMin.toString(),
          initialRateMax: assignment.rateMax.toString(),
          initialTiming: assignment.timing,
          initiallocation: assignment.location,
          initialFreq: assignment.freq,
          initialAdditionalRemarks: assignment.additionalRemarks,
          isAcceptingTutors: assignment.isPublic
          //  initialSelectedLevelsTaught:,
          //  initialSelectedSubjects:,
          //  initialLessonFormat: profile.formats,
          );
    } else {
      yield state.copyWith();
    }
  }

  Stream<EditTuteeAssignmentState> _mapCheckRatesAreValidToState(
      String toCheck, String fieldName) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(toCheck);
    final bool isValidRate = validator.isDoubleValidator.isValid(toCheck);
    if (isValidRate && isNotEmpty) {
      yield* _mapFieldToErrorState(fieldName, isValid: true);
    } else {
      yield* _mapFieldToErrorState(fieldName, isValid: false);
    }
  }

  Stream<EditTuteeAssignmentState> _mapCheckTextFieldNotEmptyToState(
      String toCheck, String fieldName) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(toCheck);
    if (isNotEmpty) {
      yield* _mapFieldToErrorState(fieldName, isValid: true);
    } else {
      yield* _mapFieldToErrorState(fieldName, isValid: false);
    }
  }

  Stream<EditTuteeAssignmentState> _mapCheckDropDownNotEmptyToState(
      String fieldName) async* {
    yield* _mapFieldToErrorState(fieldName);
  }

  Stream<EditTuteeAssignmentState> _mapFieldToErrorState(String fieldName,
      {bool isValid}) async* {
    switch (fieldName) {
      case RATEMAX:
        yield state.update(isRateMaxValid: isValid);
        break;
      case RATEMIN:
        yield state.update(isRateMinValid: isValid);
        break;
      case TIMING:
        yield state.update(isTimingValid: isValid);
        break;
      case LOCATION:
        yield state.update(isLocationValid: isValid);
        break;
      case FREQ:
        yield state.update(isFreqValid: isValid);
        break;
      case LEVELS:
        final bool valid = state.levels.isNotEmpty;
        if (valid) {
          yield state.copyWith(
            subjectHint: 'Subjects',
            isSelectedLevelsValid: valid,
          );
        } else {
          yield state.copyWith(
              isSelectedLevelsValid: valid,
              subjectsToDisplay: [],
              subjectHint: 'please select a level first');
        }
        break;
      case SUBJECTS:
        yield state.update(isSelectedSubjectsValid: state.subjects.isNotEmpty);
        break;
      case CLASS_FORMATS:
        yield state.update(
            isClassFormatsValid: state.classFormatSelection.isNotEmpty);
        break;
      case TUTOR_GENDER:
        yield state.update(isGenderValid: state.genderSelection.isNotEmpty);
        break;
      case TUTOR_OCCUPATIONS:
        yield state.update(
            isTutorOccupationsValid: state.tutorOccupation != null);
        break;
      case RATE_TYPE:
      case ADDITIONAL_REMARKS:
        yield state.update(isAdditionalRemarksValid: true);
        break;
    }
  }

  Stream<EditTuteeAssignmentState> _mapHandleToggleButtonClickToSate(
      String fieldName, dynamic index) async* {
    switch (fieldName) {
      case TUTOR_GENDER:
        state.genderSelection.contains(index)
            ? state.genderSelection.remove(index)
            : state.genderSelection.add(index);
        yield state.copyWith(genderSelection: state.genderSelection);
        break;
      case CLASS_FORMATS:
        state.classFormatSelection.contains(index)
            ? state.classFormatSelection.remove(index)
            : state.classFormatSelection.add(index);
        yield state.copyWith(classFormatSelection: state.classFormatSelection);
        break;
      case LEVELS:
        yield state.copyWith(
            subjectsToDisplay:
                subject.Subject.getSubjectsToDisplay(state.levels),
            levels: index);
        break;
      case RATE_TYPE:
        yield state.copyWith(rateTypeSelction: index);
        break;
      case TUTOR_OCCUPATIONS:
        yield state.copyWith(tutorOccupation: index);
        break;
      case SUBJECTS:
        yield state.copyWith(subjects: index);
        break;
      case IS_PUBLIC:
        yield state.copyWith(isAcceptingTutors: index);
        break;
    }
  }

  Stream<EditTuteeAssignmentState> _mapSaveFieldToState(String key,
      {dynamic value}) async* {
    switch (key) {
      case CLASS_FORMATS:
        tuteeAssignmentInfo.addAll(<String, dynamic>{
          key: ClassFormat.fromIndices(state.classFormatSelection)
        });
        break;
      case RATE_TYPE:
        tuteeAssignmentInfo.addAll(<String, dynamic>{
          key: RateTypes.fromIndex(state.rateTypeSelction)
        });
        break;
      case TUTOR_GENDER:
        tuteeAssignmentInfo.addAll(
            <String, dynamic>{key: Gender.fromIndices(state.genderSelection)});
        break;
      case RATEMIN:
      case RATEMAX:
      case PROPOSED_RATE:
        if (value.isNotEmpty) {
          tuteeAssignmentInfo
              .addAll(<String, dynamic>{key: double.parse(value)});
        } else {
          tuteeAssignmentInfo.addAll(<String, dynamic>{key: value});
        }
        break;
      default:
        tuteeAssignmentInfo.addAll(<String, dynamic>{key: value});
        break;
    }
    yield state.copyWith();
  }

  Stream<EditTuteeAssignmentState> _mapSubmitFormToState() async* {
    yield state.loading();
    Either<Failure, bool> result;
    print(tuteeAssignmentInfo);
    yield* _verifyFields(tuteeAssignmentInfo);
    if (!state.isValid()) {
      yield state
          .failure('Please make sure all fields are properly filled in!');
      return;
    }

    final TuteeAssignmentModel model = TuteeAssignmentModel(
      uid: userDetails.uid,
      tutorGender: tuteeAssignmentInfo[TUTOR_GENDER],
      rateType: tuteeAssignmentInfo[RATE_TYPE],
      tutorOccupation: tuteeAssignmentInfo[TUTOR_OCCUPATIONS],
      levels: tuteeAssignmentInfo[LEVELS_TAUGHT],
      subjects: tuteeAssignmentInfo[SUBJECTS],
      formats: tuteeAssignmentInfo[CLASS_FORMATS],
      rateMax: tuteeAssignmentInfo[RATEMAX],
      rateMin: tuteeAssignmentInfo[RATEMIN],
      timing: tuteeAssignmentInfo[TIMING],
      location: tuteeAssignmentInfo[LOCATION],
      freq: tuteeAssignmentInfo[QUALIFICATIONS],
      additionalRemarks: tuteeAssignmentInfo[SELLING_POINTS],
      isPublic: tuteeAssignmentInfo[IS_PUBLIC],
      isOpen: true,
      tuteeNameModel: userDetails.name,
      photoUrl: userDetails.photoUrl,
      isVerifiedAccount: userDetails.isVerifiedAccount,
    );
    print(model);
    if (isUpdate) {
      result = await updateTuteeAssignment(model.toDomainEntity());
    } else {
      result = await setTuteeAssignment(model.toDomainEntity());
    }
    yield* result.fold(
      (l) async* {
        yield state.failure('something went wrong');
      },
      (r) async* {
        yield state.success();
      },
    );
  }

  Stream<EditTuteeAssignmentState> _verifyFields(
      Map<String, dynamic> tuteeAssignmentInfo) async* {
    final List<String> keys = [
      TUTOR_GENDER,
      CLASS_FORMATS,
      LEVELS,
      SUBJECTS,
      TUTOR_OCCUPATIONS,
      RATE_TYPE,
    ];
    for (MapEntry<String, dynamic> entry in tuteeAssignmentInfo.entries) {
      if (entry.value is String) {
        yield* _mapCheckTextFieldNotEmptyToState(entry.value, entry.key);
      }
    }
    for (String key in keys) {
      yield* _mapCheckDropDownNotEmptyToState(key);
    }
  }
}
