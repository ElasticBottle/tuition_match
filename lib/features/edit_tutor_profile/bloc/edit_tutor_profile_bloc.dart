import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/class_format.dart';
import 'package:cotor/domain/entities/gender.dart';
import 'package:cotor/domain/entities/rate_types.dart';
import 'package:cotor/domain/entities/subject.dart' as subject;
import 'package:cotor/domain/usecases/user/set_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/update_tutor_profile.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part 'edit_tutor_profile_event.dart';
part 'edit_tutor_profile_state.dart';

class EditTutorProfileBloc
    extends Bloc<EditTutorProfileEvent, EditTutorProfileState> {
  EditTutorProfileBloc({
    @required this.validator,
    @required this.setTutorProfile,
    @required this.updateTutorProfile,
  });
  final EmailAndPasswordValidators validator;
  final SetTutorProfile setTutorProfile;
  final UpdateTutorProfile updateTutorProfile;
  final Map<String, dynamic> tutorProfileInfo = <String, dynamic>{};
  UserModel userDetails;

  @override
  EditTutorProfileState get initialState => EditTutorProfileState.initial();

  @override
  Stream<EditTutorProfileState> transformEvents(
      Stream<EditTutorProfileEvent> events,
      Stream<EditTutorProfileState> Function(EditTutorProfileEvent) next) {
    final Stream<EditTutorProfileEvent> nonDebounceStream = events.where(
        (event) =>
            event is! CheckRatesAreValid &&
            event is! CheckDropDownNotEmpty &&
            event is! CheckTextFieldNotEmpty);
    final Stream<EditTutorProfileEvent> debounceStream = events
        .where((event) =>
            event is CheckRatesAreValid ||
            event is CheckDropDownNotEmpty ||
            event is CheckTextFieldNotEmpty)
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<EditTutorProfileState> mapEventToState(
    EditTutorProfileEvent event,
  ) async* {
    if (event is InitialiseProfileFields) {
      yield* _mapInitialiseFieldsToState(
        event.tutorProfile,
        event.userDetails,
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
    } else if (event is ResetForm) {
      yield* _mapResetFormToState();
    }
  }

  Stream<EditTutorProfileState> _mapInitialiseFieldsToState(
    TutorProfileModel profile,
    UserModel userDetails,
  ) async* {
    this.userDetails = userDetails;
    if (userDetails.isTutor) {
      yield state.copyWith(
        genderSelection: Gender.toIndex(profile.gender),
        classFormatSelection: ClassFormat.toIndices(profile.formats),
        levelsTaught: profile.levelsTaught,
        subjectsTaught: profile.subjects,
        subjectsToDisplay:
            subject.Subject.getSubjectsToDisplay(profile.levelsTaught),
        subjectHint: 'Subjects',
        tutorOccupation: profile.tutorOccupation,
        rateTypeSelction: RateTypes.toIndex(profile.rateType),
        initialRateMin: profile.rateMin.toString(),
        initialRateMax: profile.rateMax.toString(),
        initialTiming: profile.timing,
        initiallocation: profile.location,
        initialQualification: profile.qualifications,
        initialSellingPoint: profile.sellingPoints,
        isAcceptingStudent: profile.isPublic,
      );
    } else {
      yield state.copyWith();
    }
  }

  Stream<EditTutorProfileState> _mapCheckRatesAreValidToState(
      String toCheck, String fieldName) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(toCheck);
    final bool isValidRate = validator.isDoubleValidator.isValid(toCheck);
    if (isValidRate && isNotEmpty) {
      yield* _mapFieldToErrorState(fieldName, isValid: true);
    } else {
      yield* _mapFieldToErrorState(fieldName, isValid: false);
    }
  }

  Stream<EditTutorProfileState> _mapCheckTextFieldNotEmptyToState(
      String toCheck, String fieldName) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(toCheck);
    if (isNotEmpty) {
      yield* _mapFieldToErrorState(fieldName, isValid: true);
    } else {
      yield* _mapFieldToErrorState(fieldName, isValid: false);
    }
  }

  Stream<EditTutorProfileState> _mapCheckDropDownNotEmptyToState(
      String fieldName) async* {
    yield* _mapFieldToErrorState(fieldName);
  }

  Stream<EditTutorProfileState> _mapFieldToErrorState(String fieldName,
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
      case QUALIFICATIONS:
        yield state.update(isQualificationValid: isValid);
        break;
      case SELLING_POINTS:
        yield state.update(isSellingPointValid: isValid);
        break;
      case LEVELS_TAUGHT:
        final bool valid = state.levelsTaught.isNotEmpty;
        if (valid) {
          yield state.copyWith(
            subjectHint: 'Subjects',
            isSelectedLevelsTaughtValid: valid,
          );
        } else {
          yield state.copyWith(
              isSelectedLevelsTaughtValid: valid,
              subjectsToDisplay: [],
              subjectHint: 'please select a level first');
        }
        break;
      case SUBJECTS:
        yield state.update(
            isSelectedSubjectsValid: state.subjectsTaught.isNotEmpty);
        break;
      case CLASS_FORMATS:
        yield state.update(
            isClassFormatsValid: state.classFormatSelection.isNotEmpty);
        break;
      case TUTOR_OCCUPATION:
        yield state.update(
            isTutorOccupationValid: state.tutorOccupation != null);
        break;
      case RATE_TYPE:
        yield state.update(isTypeRateValid: true);
        break;
      case GENDER:
        yield state.update(isGenderValid: true);
        break;
    }
  }

  Stream<EditTutorProfileState> _mapHandleToggleButtonClickToSate(
      String fieldName, dynamic index) async* {
    switch (fieldName) {
      case GENDER:
        yield state.copyWith(genderSelection: index);
        break;
      case CLASS_FORMATS:
        state.classFormatSelection.contains(index)
            ? state.classFormatSelection.remove(index)
            : state.classFormatSelection.add(index);
        yield state.copyWith(classFormatSelection: state.classFormatSelection);
        break;
      case RATE_TYPE:
        yield state.copyWith(rateTypeSelction: index);
        break;
      case TUTOR_OCCUPATION:
        yield state.copyWith(tutorOccupation: index);
        break;
      case SUBJECTS:
        yield state.copyWith(subjectsTaught: index);
        break;
      case LEVELS_TAUGHT:
        yield state.copyWith(
            subjectsToDisplay: subject.Subject.getSubjectsToDisplay(index),
            levelsTaught: index);
        break;
      case IS_PUBLIC:
        yield state.copyWith(isAcceptingStudent: index);
        break;
    }
  }

  Stream<EditTutorProfileState> _mapSaveFieldToState(String key,
      {dynamic value}) async* {
    switch (key) {
      case CLASS_FORMATS:
        tutorProfileInfo.addAll(<String, dynamic>{
          key: ClassFormat.fromIndices(state.classFormatSelection)
        });
        break;
      case RATE_TYPE:
        tutorProfileInfo.addAll(<String, dynamic>{
          key: RateTypes.fromIndex(state.rateTypeSelction)
        });
        break;
      case GENDER:
        tutorProfileInfo.addAll(
            <String, dynamic>{key: Gender.fromIndex(state.genderSelection)});
        break;
      case RATEMIN:
      case RATEMAX:
      case PROPOSED_RATE:
        if (value.isNotEmpty) {
          tutorProfileInfo.addAll(<String, dynamic>{key: double.parse(value)});
        } else {
          tutorProfileInfo.addAll(<String, dynamic>{key: value});
        }
        break;
      case LEVELS_TAUGHT:
        tutorProfileInfo.addAll(<String, dynamic>{key: state.levelsTaught});
        break;
      case SUBJECTS:
        tutorProfileInfo.addAll(<String, dynamic>{key: state.subjectsTaught});
        break;
      case TUTOR_OCCUPATION:
        tutorProfileInfo.addAll(<String, dynamic>{key: state.tutorOccupation});
        break;
      case IS_PUBLIC:
        tutorProfileInfo
            .addAll(<String, dynamic>{key: state.isAcceptingStudent});
        break;
      default:
        tutorProfileInfo.addAll(<String, dynamic>{key: value});
        break;
    }
    yield state.copyWith();
  }

  Stream<EditTutorProfileState> _mapSubmitFormToState() async* {
    yield state.loading();
    yield* _saveNonTextFields();
    Either<Failure, bool> result;
    yield* _verifyFields(tutorProfileInfo);
    if (!state.isValid()) {
      yield state
          .failure('Please make sure all fields are properly filled in!');
      return;
    }
    final TutorProfileModel model = TutorProfileModel(
      uid: userDetails.uid,
      gender: tutorProfileInfo[GENDER],
      rateType: tutorProfileInfo[RATE_TYPE],
      tutorOccupation: tutorProfileInfo[TUTOR_OCCUPATION],
      levelsTaught: tutorProfileInfo[LEVELS_TAUGHT],
      subjects: tutorProfileInfo[SUBJECTS],
      formats: tutorProfileInfo[CLASS_FORMATS],
      rateMax: tutorProfileInfo[RATEMAX],
      rateMin: tutorProfileInfo[RATEMIN],
      timing: tutorProfileInfo[TIMING],
      location: tutorProfileInfo[LOCATION],
      qualifications: tutorProfileInfo[QUALIFICATIONS],
      sellingPoints: tutorProfileInfo[SELLING_POINTS],
      isPublic: tutorProfileInfo[IS_PUBLIC],
      tutorNameModel: userDetails.name,
      photoUrl: userDetails.photoUrl,
      isVerifiedTutor: userDetails.isVerifiedTutor,
    );
    print(model);
    if (userDetails.isTutor) {
      result = await updateTutorProfile(model.toDomainEntity());
    } else {
      result = await setTutorProfile(model.toDomainEntity());
    }
    yield* result.fold(
      (l) async* {
        if (l is ServerFailure) {
          yield state.failure(
            'We had problems updating our server',
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

  Stream<EditTutorProfileState> _verifyFields(
      Map<String, dynamic> tutorProfileInfo) async* {
    final List<String> nonTextFieldToVerify = [
      CLASS_FORMATS,
      LEVELS_TAUGHT,
      SUBJECTS,
      TUTOR_OCCUPATION,
    ];
    for (MapEntry<String, dynamic> entry in tutorProfileInfo.entries) {
      if (entry.value is String) {
        yield* _mapCheckTextFieldNotEmptyToState(entry.value, entry.key);
      }
    }
    for (String key in nonTextFieldToVerify) {
      yield* _mapCheckDropDownNotEmptyToState(key);
    }
  }

  Stream<EditTutorProfileState> _saveNonTextFields() async* {
    final List<String> keys = [
      GENDER,
      CLASS_FORMATS,
      LEVELS_TAUGHT,
      SUBJECTS,
      TUTOR_OCCUPATION,
      RATE_TYPE,
      IS_PUBLIC,
    ];
    for (String key in keys) {
      yield* _mapSaveFieldToState(key);
    }
  }

  Stream<EditTutorProfileState> _mapResetFormToState() async* {
    yield EditTutorProfileState.initial();
  }
}
