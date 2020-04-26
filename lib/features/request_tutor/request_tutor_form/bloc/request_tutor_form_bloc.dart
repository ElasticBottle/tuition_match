import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/class_format.dart';
import 'package:cotor/domain/entities/gender.dart';
import 'package:cotor/domain/entities/rate_types.dart';
import 'package:cotor/domain/entities/subject.dart' as subject;
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/usecases/user/set_tutee_assignment.dart';
import 'package:cotor/domain/usecases/user/update_tutee_assignment.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part 'request_tutor_form_event.dart';
part 'request_tutor_form_state.dart';

class RequestTutorFormBloc
    extends Bloc<RequestTutorFormEvent, RequestTutorFormState> {
  RequestTutorFormBloc({
    @required this.requestTutorProfile,
    @required this.validator,
  });
  final EmailAndPasswordValidators validator;
  final RequestTutorProfile requestTutorProfile;

  Map<String, dynamic> tuteeAssignmentInfo;
  UserModel userDetails;

  @override
  RequestTutorFormState get initialState {
    return RequestTutorFormState.initial();
  }

  @override
  Stream<RequestTutorFormState> transformEvents(
      Stream<RequestTutorFormEvent> events,
      Stream<RequestTutorFormState> Function(RequestTutorFormEvent) next) {
    final Stream<RequestTutorFormEvent> nonDebounceStream = events
        .where((event) => event is! HandleRates && event is! HandleTextField);
    final Stream<RequestTutorFormEvent> debounceStream = events
        .where((event) => event is HandleRates || event is HandleTextField)
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<RequestTutorFormState> mapEventToState(
    RequestTutorFormEvent event,
  ) async* {
    if (event is InitialiseProfileFields) {
      yield* _mapInitialiseFieldsToState(
        event.requestingProfile,
        event.userDetails,
        event.userRefAssignment,
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
    } else if (event is ResetForm) {
      yield* _mapResetFormToState();
    }
  }

  Stream<RequestTutorFormState> _mapInitialiseFieldsToState(
    TutorProfileModel requestingProfile,
    UserModel userDetails,
    TuteeAssignmentModel userRefAssignment,
  ) async* {
    this.userDetails = userDetails;
    if (userRefAssignment.postId != null) {
      userRefAssignment.subjects.retainWhere(
          (subject) => requestingProfile.subjects.contains(subject));
      userRefAssignment.levels.retainWhere(
          (level) => requestingProfile.levelsTaught.contains(level));
      userRefAssignment.formats
          .retainWhere((format) => requestingProfile.formats.contains(format));
      tuteeAssignmentInfo =
          _initialiseMapFields(userRefAssignment, requestingProfile);
      yield state.copyWith(
        requestingProfile: requestingProfile,
        userRefAssignment: userRefAssignment,
        levelsToDisplay: requestingProfile.levelsTaught,
        levels: userRefAssignment.levels,
        subjects: userRefAssignment.subjects,
        subjectsToDisplay:
            subject.Subject.getSubjectsToDisplay(userRefAssignment.levels),
        subjectHint: 'Subjects',
        classFormatsToDisplay: requestingProfile.formats,
        classFormatSelection: ClassFormat.toIndices(userRefAssignment.formats),
        initialProposedRate: userRefAssignment.proposedRate.toString(),
        rateTypeSelction: RateTypes.toIndex(userRefAssignment.rateType),
        initialTiming: userRefAssignment.timing,
        initiallocation: userRefAssignment.location,
        initialFreq: userRefAssignment.freq,
        initialAdditionalRemarks: userRefAssignment.additionalRemarks,
        isPublic: userRefAssignment.isPublic,
        genderSelection: Gender.toIndices(userRefAssignment.tutorGender),
        tutorOccupation: userRefAssignment.tutorOccupation,
        initialRateMin: userRefAssignment.rateMin.toString(),
        initialRateMax: userRefAssignment.rateMax.toString(),
      );
    } else {
      yield state.copyWith(
        requestingProfile: requestingProfile,
        levelsToDisplay: requestingProfile.levelsTaught,
        classFormatsToDisplay: requestingProfile.formats,
        classFormatSelection: ClassFormat.toIndices(requestingProfile.formats),
        rateTypeSelction: RateTypes.toIndex(requestingProfile.rateType),
        genderSelection: [Gender.toIndex(requestingProfile.gender)],
        tutorOccupation: [requestingProfile.tutorOccupation],
        initialRateMin: requestingProfile.rateMin.toString(),
        initialRateMax: requestingProfile.rateMax.toString(),
      );
    }
  }

  Map<String, dynamic> _initialiseMapFields(
      TuteeAssignmentModel userRefAssignment,
      TutorProfileModel requestingProfile) {
    return userRefAssignment.postId == null
        ? <String, dynamic>{
            CLASS_FORMATS: requestingProfile.formats,
            RATE_TYPE: requestingProfile.rateType,
            IS_PUBLIC: RequestTutorFormState.initial().isPublic,
            TUTOR_GENDER: [requestingProfile.gender],
            RATEMIN: requestingProfile.rateMin,
            RATEMAX: requestingProfile.rateMax,
            TUTOR_OCCUPATIONS: [requestingProfile.tutorOccupation],
          }
        : <String, dynamic>{
            LEVELS: userRefAssignment.levels,
            SUBJECTS: userRefAssignment.subjects,
            CLASS_FORMATS: userRefAssignment.formats,
            RATE_TYPE: userRefAssignment.rateType,
            PROPOSED_RATE: userRefAssignment.proposedRate,
            TIMING: userRefAssignment.timing,
            LOCATION: userRefAssignment.location,
            FREQ: userRefAssignment.freq,
            ADDITIONAL_REMARKS: userRefAssignment.additionalRemarks,
            IS_PUBLIC: userRefAssignment.isPublic,
            TUTOR_GENDER: userRefAssignment.tutorGender,
            RATEMIN: userRefAssignment.rateMin,
            RATEMAX: userRefAssignment.rateMax,
            TUTOR_OCCUPATIONS: userRefAssignment.tutorOccupation,
          };
  }

  Stream<RequestTutorFormState> _mapHandleRateToState(
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

  Stream<RequestTutorFormState> _mapHandleTextField(
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

  Stream<RequestTutorFormState> _mapFieldToErrorState(String fieldName,
      {bool isValid}) async* {
    switch (fieldName) {
      case RATEMAX:
        yield state.update(isRateMaxValid: isValid);
        break;
      case RATEMIN:
        yield state.update(isRateMinValid: isValid);
        break;
      case PROPOSED_RATE:
        yield state.update(isProposedRateValid: isValid);
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
        yield state.update(isAdditionalRemarksValid: true);
        break;
    }
  }

  Stream<RequestTutorFormState> _mapHandleToggleButtonClickToState(
      String fieldName, dynamic index) async* {
    switch (fieldName) {
      case TUTOR_GENDER:
        state.genderSelection.contains(index)
            ? state.genderSelection.remove(index)
            : state.genderSelection.add(index);
        yield state.update(
          genderSelection: state.genderSelection,
          isGenderValid: state.genderSelection.isNotEmpty,
        );
        state.genderSelection.isNotEmpty
            ? tuteeAssignmentInfo[fieldName] =
                Gender.fromIndices(state.genderSelection)
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
            ? tuteeAssignmentInfo[fieldName] =
                ClassFormat.fromIndices(state.classFormatSelection)
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
          tutorOccupation: index,
          isTutorOccupationValid: index.isNotEmpty,
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
          yield state.update(
            isSelectedLevelsValid: valid,
            subjects: [],
            subjectsToDisplay: [],
            subjectHint: 'please select a level first',
          );
        }
        break;
      case IS_PUBLIC:
        yield state.update(isPublic: index);
        tuteeAssignmentInfo[fieldName] = index;
        break;
    }
  }

  Stream<RequestTutorFormState> _mapSubmitFormToState() async* {
    yield state.loading();
    final bool isValid = _verifyFields(tuteeAssignmentInfo);
    if (!isValid || !state.isValid()) {
      yield state.failure(
          'Please fill in the blanks or make some changes before saving.');
      return;
    }
    final TuteeAssignmentModel model = TuteeAssignmentModel(
      photoUrl: userDetails.photoUrl,
      tuteeNameModel: userDetails.name,
      uid: userDetails.uid,
      levels: tuteeAssignmentInfo[LEVELS],
      subjects: tuteeAssignmentInfo[SUBJECTS],
      formats: tuteeAssignmentInfo[CLASS_FORMATS],
      rateType: tuteeAssignmentInfo[RATE_TYPE],
      proposedRate: tuteeAssignmentInfo[PROPOSED_RATE],
      timing: tuteeAssignmentInfo[TIMING],
      location: tuteeAssignmentInfo[LOCATION],
      freq: tuteeAssignmentInfo[FREQ],
      additionalRemarks: tuteeAssignmentInfo[ADDITIONAL_REMARKS],
      isPublic: tuteeAssignmentInfo[IS_PUBLIC],
      isVerifiedAccount: userDetails.isVerifiedAccount,
      tutorGender: tuteeAssignmentInfo[TUTOR_GENDER],
      rateMax: tuteeAssignmentInfo[RATEMAX],
      rateMin: tuteeAssignmentInfo[RATEMIN],
      tutorOccupation: tuteeAssignmentInfo[TUTOR_OCCUPATIONS],
    );
    print(model);
    final Either<Failure, bool> result =
        requestTutorProfile(RequestTutorProfileParams(
      assignment: model.toDomainEntity(),
      requestingProfile: state.requestingProfile.toDomainEntity(),
      isNewAssignment: state.userRefAssignment.postId == null,
    ));

    yield* result.fold(
      (l) async* {
        if (l is ServerFailure) {
          yield state.failure(
            'We had problems updating our server. Please wait a wihle and try again later!',
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

  bool _verifyFields(Map<String, dynamic> tuteeAssignmentInfo) {
    final List<String> fieldsToVerify = [
      LEVELS,
      SUBJECTS,
      CLASS_FORMATS,
      RATE_TYPE,
      PROPOSED_RATE,
      TIMING,
      LOCATION,
      FREQ,
      ADDITIONAL_REMARKS,
      IS_PUBLIC,
      TUTOR_GENDER,
      RATEMIN,
      RATEMAX,
      TUTOR_OCCUPATIONS,
    ];
    bool toReturn = true;
    for (var key in fieldsToVerify) {
      if (!tuteeAssignmentInfo.containsKey(key)) {
        toReturn = false;
      }
    }
    return toReturn;
  }

  Stream<RequestTutorFormState> _mapResetFormToState() async* {
    tuteeAssignmentInfo.clear();
    yield RequestTutorFormState.initial();
  }
}
