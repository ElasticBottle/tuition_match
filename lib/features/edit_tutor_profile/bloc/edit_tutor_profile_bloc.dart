import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/tutor_profile_model.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/usecases/user/set_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/update_tutor_profile.dart';
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
  final Map<String, dynamic> tutorProfileInfo = <String, dynamic>{
    GENDER: 0,
    RATE_TYPE: 0,
    STATUS: true,
    SUBJECTS: ['science']
  };
  String userId;
  String photoUrl;
  Name tutorName;
  bool isVerifiedTutor;
  bool isTutor;

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
    if (event is InitialiseFields) {
      yield* _mapInitialiseFieldsToState(
        event.tutorProfile,
        event.userId,
        event.name,
        event.photoUrl,
        event.isVerifiedTutor,
        event.isTutor,
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

  Stream<EditTutorProfileState> _mapInitialiseFieldsToState(
      TutorProfile profile,
      String userId,
      Name name,
      String photoUrl,
      bool isVerifiedTutor,
      bool isTutor) async* {
    this.userId = userId;
    this.isVerifiedTutor = isVerifiedTutor;
    this.photoUrl = photoUrl;
    tutorName = name;
    this.isTutor = isTutor;
    if (isTutor) {
      yield state.copyWith(
        genderSelection: profile.gender.index,
        rateTypeSelction: profile.rateType.index,
        classFormatSelection:
            profile.formats.map((ClassFormat e) => e.index).toList(),
        initialRateMin: profile.rateMin.toString(),
        initialRateMax: profile.rateMax.toString(),
        initialTiming: profile.timing,
        initiallocation: profile.location,
        initialQualification: profile.qualifications,
        initialSellingPoint: profile.sellingPoints,
        //  initialSelectedLevelsTaught:,
        //  initialSelectedSubjects:,
        //  initialLessonFormat: profile.formats,
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
        yield state.update(
            isSelectedLevelsTaughtValid: state.levelsTaught.isNotEmpty);
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
    }
  }

  Stream<EditTutorProfileState> _mapHandleToggleButtonClickToSate(
      String fieldName, dynamic index) async* {
    switch (fieldName) {
      case GENDER:
        yield state.copyWith(genderSelection: index);
        break;
      case RATE_TYPE:
        yield state.copyWith(rateTypeSelction: index);
        break;
      case CLASS_FORMATS:
        state.classFormatSelection.contains(index)
            ? state.classFormatSelection.remove(index)
            : state.classFormatSelection.add(index);
        yield state.copyWith(classFormatSelection: state.classFormatSelection);
        break;
      case TUTOR_OCCUPATION:
        yield state.copyWith(tutorOccupation: index);
        break;
      case LEVELS_TAUGHT:
        yield state.copyWith(levelsTaught: index);
        break;
      case SUBJECTS:
        yield state.copyWith(subjectsTaught: index);
        break;
      case STATUS:
        yield state.copyWith(isAcceptingStudent: index);
        break;
    }
  }

  Stream<EditTutorProfileState> _mapSaveFieldToState(String key,
      {dynamic value}) async* {
    switch (key) {
      case CLASS_FORMATS:
        tutorProfileInfo
            .addAll(<String, dynamic>{key: state.classFormatSelection});
        break;
      default:
        tutorProfileInfo.addAll(<String, dynamic>{key: value});
        break;
    }
    yield state.copyWith();
  }

  Stream<EditTutorProfileState> _mapSubmitFormToState() async* {
    yield state.copyWith(isSubmitting: true);
    Either<Failure, bool> result;
    yield* _verifyFields(tutorProfileInfo);
    if (!state.isValid()) {
      yield state.copyWith(
          isSubmitting: false,
          isFailure: true,
          failureMessage:
              'Please make sure all fields are properly filled in!');
      return;
    } else if (isTutor) {
      result = await updateTutorProfile(TutorProfileModel());
    } else {
      final TutorProfileModel model =
          TutorProfileModel.fromJson(<String, dynamic>{
        UID: userId,
        GENDER: tutorProfileInfo[GENDER],
        RATE_TYPE: tutorProfileInfo[RATE_TYPE],
        TUTOR_OCCUPATION: tutorProfileInfo[TUTOR_OCCUPATION],
        LEVELS_TAUGHT: tutorProfileInfo[LEVELS_TAUGHT],
        SUBJECTS: tutorProfileInfo[SUBJECTS],
        CLASS_FORMATS: tutorProfileInfo[CLASS_FORMATS],
        RATEMAX: tutorProfileInfo[RATEMAX],
        RATEMIN: tutorProfileInfo[RATEMIN],
        TIMING: tutorProfileInfo[TIMING],
        LOCATION: tutorProfileInfo[LOCATION],
        QUALIFICATIONS: tutorProfileInfo[QUALIFICATIONS],
        SELLING_POINTS: tutorProfileInfo[SELLING_POINTS],
        STATUS: tutorProfileInfo[STATUS] ? 0 : 1,
        TUTOR_NAME: <String, String>{
          FIRSTNAME: tutorName.firstName,
          LASTNAME: tutorName.lastName
        },
        PHOTOURL: photoUrl,
        IS_VERIFIED_TUTOR: isVerifiedTutor,
      });
      print(model);
      result = await setTutorProfile(model);
    }
    yield* result.fold(
      (l) async* {
        yield state.copyWith(
          isSubmitting: false,
          isFailure: true,
          failureMessage: 'Soemthing went wrong',
        );
      },
      (r) async* {},
    );
  }

  Stream<EditTutorProfileState> _verifyFields(
      Map<String, dynamic> tutorProfileInfo) async* {
    final List<String> keys = [
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
    for (String key in keys) {
      yield* _mapCheckDropDownNotEmptyToState(key);
    }
  }
}
