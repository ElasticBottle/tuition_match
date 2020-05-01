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

  Map<String, dynamic> tuteeAssignmentInfo = <String, dynamic>{};
  // Map<String, String> stringValues = <String, String>{};
  UserModel userDetails;
  bool isUpdate;

  @override
  EditTuteeAssignmentState get initialState {
    return EditTuteeAssignmentState.initial();
  }

  @override
  Stream<Transition<EditTuteeAssignmentEvent, EditTuteeAssignmentState>>
      transformEvents(Stream<EditTuteeAssignmentEvent> events, transitionFn) {
    final Stream<EditTuteeAssignmentEvent> nonDebounceStream = events
        .where((event) => event is! HandleRates && event is! HandleTextField);
    final Stream<EditTuteeAssignmentEvent> debounceStream = events
        .where((event) => event is HandleRates || event is HandleTextField)
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
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
    } else if (event is HandleToggleButtonClick) {
      yield* _mapHandleToggleButtonClickToState(event.fieldName, event.index);
    } else if (event is HandleRates) {
      yield* _mapHandleRateToState(
          fieldName: event.fieldName, value: event.value);
    } else if (event is HandleTextField) {
      yield* _mapHandleTextField(
          fieldName: event.fieldName, value: event.value);
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
    tuteeAssignmentInfo = _initialiseMapFields(assignment, isUpdate);

    if (isUpdate) {
      yield state.copyWith(
          genderSelection: Gender.toIndices(assignment.tutorGenders),
          classFormatSelection: ClassFormat.toIndices(assignment.formats),
          levels: assignment.levels,
          subjects: assignment.subjects,
          subjectsToDisplay:
              subject.Subject.getSubjectsToDisplay(assignment.levels),
          subjectHint: 'Subjects',
          tutorOccupations: assignment.tutorOccupations,
          rateTypeSelction: RateTypes.toIndex(assignment.rateType),
          initialRateMin: assignment.rateMin.toString(),
          initialRateMax: assignment.rateMax.toString(),
          initialTiming: assignment.timing,
          initiallocation: assignment.location,
          initialFreq: assignment.freq,
          initialAdditionalRemarks: assignment.additionalRemarks,
          isAcceptingTutors: assignment.isPublic
          //  initialSelectedLevels:,
          //  initialSelectedSubjects:,
          //  initialLessonFormat: profile.formats,
          );
    } else {
      yield state.copyWith(
        genderSelection: [0, 1],
        subjectsToDisplay: [],
        classFormatSelection: [1],
        tutorOccupations: [],
        levels: [],
        subjects: [],
      );
    }
  }

  Map<String, dynamic> _initialiseMapFields(
      TuteeAssignmentModel assignment, bool isUpdate) {
    return !isUpdate
        ? <String, dynamic>{
            TUTOR_GENDER: Gender.fromIndices(
                EditTuteeAssignmentState.initial().genderSelection),
            CLASS_FORMATS: ClassFormat.fromIndices(
              EditTuteeAssignmentState.initial().classFormatSelection,
            ),
            RATE_TYPE: RateTypes.fromIndex(
                EditTuteeAssignmentState.initial().rateTypeSelction),
            PROPOSED_RATE: 0.0,
            RATEMAX:
                double.parse(EditTuteeAssignmentState.initial().initialRateMax),
            RATEMIN:
                double.parse(EditTuteeAssignmentState.initial().initialRateMin),
            IS_PUBLIC: EditTuteeAssignmentState.initial().isAcceptingTutors,
          }
        : <String, dynamic>{
            TUTOR_GENDER: assignment.tutorGenders,
            TUTOR_OCCUPATIONS: assignment.tutorOccupations,
            LEVELS: assignment.levels,
            SUBJECTS: assignment.subjects,
            CLASS_FORMATS: assignment.formats,
            RATE_TYPE: assignment.rateType,
            RATEMIN: assignment.rateMin,
            RATEMAX: assignment.rateMax,
            PROPOSED_RATE: assignment.proposedRate,
            TIMING: assignment.timing,
            LOCATION: assignment.location,
            FREQ: assignment.freq,
            ADDITIONAL_REMARKS: assignment.additionalRemarks,
            IS_PUBLIC: assignment.isPublic,
          };
  }

  Stream<EditTuteeAssignmentState> _mapHandleRateToState(
      {String fieldName, String value}) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(value);
    final bool isValidRate = validator.isDoubleValidator.isValid(value);
    if (isValidRate && isNotEmpty) {
      yield* _mapFieldToErrorState(fieldName, isValid: true);
      tuteeAssignmentInfo
          .addAll(<String, dynamic>{fieldName: double.parse(value)});
    } else {
      yield* _mapFieldToErrorState(fieldName, isValid: false);
      tuteeAssignmentInfo.remove(fieldName);
    }
  }

  Stream<EditTuteeAssignmentState> _mapHandleTextField(
      {String fieldName, String value}) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(value);
    if (isNotEmpty) {
      tuteeAssignmentInfo.addAll(<String, dynamic>{fieldName: value});
      yield* _mapFieldToErrorState(fieldName, isValid: true);
    } else {
      tuteeAssignmentInfo.remove(fieldName);
      yield* _mapFieldToErrorState(fieldName, isValid: false);
    }
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
      case ADDITIONAL_REMARKS:
        yield state.update(isAdditionalRemarksValid: isValid);
        break;
    }
  }

  Stream<EditTuteeAssignmentState> _mapHandleToggleButtonClickToState(
      String fieldName, dynamic index) async* {
    switch (fieldName) {
      case TUTOR_GENDER:
        state.genderSelection.contains(index)
            ? state.genderSelection.remove(index)
            : state.genderSelection.add(index);
        yield state.update(
          genderSelection: index,
          isGenderValid: state.genderSelection.isNotEmpty,
        );
        state.genderSelection.isNotEmpty
            ? tuteeAssignmentInfo[fieldName] = Gender.fromIndices(index)
            : tuteeAssignmentInfo.remove(fieldName);
        break;
      case CLASS_FORMATS:
        state.classFormatSelection.contains(index)
            ? state.classFormatSelection.remove(index)
            : state.classFormatSelection.add(index);
        yield state.update(
          classFormatSelection: state.classFormatSelection,
          isClassFormatsValid: state.classFormatSelection.isNotEmpty,
        );
        state.classFormatSelection.isNotEmpty
            ? tuteeAssignmentInfo.addAll(<String, dynamic>{
                fieldName: ClassFormat.fromIndices(state.classFormatSelection)
              })
            : tuteeAssignmentInfo.remove(fieldName);
        break;
      case RATE_TYPE:
        yield state.update(
          rateTypeSelction: index,
          isTypeRateValid: true,
        );
        tuteeAssignmentInfo[fieldName] = RateTypes.fromIndex(index);

        break;
      case TUTOR_OCCUPATIONS:
        yield state.update(
          tutorOccupations: index,
          isTutorOccupationsValid: index.isNotEmpty,
        );
        index.isNotEmpty
            ? tuteeAssignmentInfo[fieldName] = index
            : tuteeAssignmentInfo.remove(fieldName);
        break;
      case SUBJECTS:
        yield state.update(
          subjects: index,
          isSelectedSubjectsValid: index.isNotEmpty,
        );
        index.isNotEmpty
            ? tuteeAssignmentInfo[fieldName] = index
            : tuteeAssignmentInfo.remove(fieldName);
        break;
      case LEVELS:
        yield state.update(levels: index);
        final bool valid = index.isNotEmpty;
        if (valid) {
          final List<String> subjectsAvailToTeach =
              subject.Subject.getSubjectsToDisplay(index);
          state.subjects.removeWhere(
              (element) => !subjectsAvailToTeach.contains(element));
          tuteeAssignmentInfo.addAll(<String, dynamic>{
            fieldName: index,
            SUBJECTS: state.subjects,
          });
          yield state.update(
            subjectsToDisplay: subjectsAvailToTeach,
            subjects: state.subjects,
            subjectHint: 'Subjects',
            isSelectedLevelsValid: valid,
          );
        } else {
          tuteeAssignmentInfo.remove(fieldName);
          tuteeAssignmentInfo.remove(SUBJECTS);
          yield state.update(
            isSelectedLevelsValid: valid,
            subjects: [],
            subjectsToDisplay: [],
            subjectHint: 'please select a level first',
          );
        }
        break;
      case IS_PUBLIC:
        yield state.update(isAcceptingTutors: index);
        tuteeAssignmentInfo[fieldName] = index;
        break;
    }
  }

  Stream<EditTuteeAssignmentState> _mapSubmitFormToState() async* {
    yield state.loading();

    final bool isValid = _verifyFields(tuteeAssignmentInfo);
    if (!isValid || !state.isValid()) {
      yield state
          .failure('Please make sure all fields are properly filled in!');
      return;
    }

    final TuteeAssignmentModel model = TuteeAssignmentModel(
      uid: userDetails.uid,
      tutorGenders: tuteeAssignmentInfo[TUTOR_GENDER],
      rateType: tuteeAssignmentInfo[RATE_TYPE],
      tutorOccupations: tuteeAssignmentInfo[TUTOR_OCCUPATIONS],
      levels: tuteeAssignmentInfo[LEVELS],
      subjects: tuteeAssignmentInfo[SUBJECTS],
      formats: tuteeAssignmentInfo[CLASS_FORMATS],
      proposedRate: tuteeAssignmentInfo[PROPOSED_RATE],
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
    final Either<Failure, bool> result = isUpdate
        ? await updateTuteeAssignment(model.toDomainEntity())
        : await setTuteeAssignment(model.toDomainEntity());

    yield* result.fold(
      (l) async* {
        if (l is ServerFailure) {
          yield state.failure(
            'We had problems updating our server. You can save your edits and try again later!',
          );
        } else if (l is NetworkFailure) {
          yield state.failure(
            'No Internet! Check connection and Try again',
          );
        }
      },
      (r) async* {
        yield state.success('Success!');
      },
    );
  }

  bool _verifyFields(Map<String, dynamic> tutorProfileInfo) {
    final List<String> fieldsToVerify = [
      TUTOR_GENDER,
      TUTOR_OCCUPATIONS,
      LEVELS,
      SUBJECTS,
      CLASS_FORMATS,
      RATE_TYPE,
      RATEMIN,
      RATEMAX,
      PROPOSED_RATE,
      TIMING,
      LOCATION,
      FREQ,
      ADDITIONAL_REMARKS,
      IS_PUBLIC,
    ];
    for (String key in fieldsToVerify) {
      if (!tutorProfileInfo.containsKey(key)) {
        print('tutor profile info does not contain' + key);
        return false;
      }
    }
    return true;
  }
}
