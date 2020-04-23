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
import 'package:cotor/domain/usecases/user/cache_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/get_cache_tutor_profile.dart';
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
    @required this.cacheTutorProfile,
    @required this.getCacheTutorProfile,
  });
  final EmailAndPasswordValidators validator;
  final SetTutorProfile setTutorProfile;
  final UpdateTutorProfile updateTutorProfile;
  final CacheTutorProfile cacheTutorProfile;
  final GetCacheTutorProfile getCacheTutorProfile;
  Map<String, dynamic> tutorProfileInfo;
  UserModel userDetails;

  @override
  EditTutorProfileState get initialState {
    return EditTutorProfileState.initial();
  }

  @override
  Stream<EditTutorProfileState> transformEvents(
      Stream<EditTutorProfileEvent> events,
      Stream<EditTutorProfileState> Function(EditTutorProfileEvent) next) {
    final Stream<EditTutorProfileEvent> nonDebounceStream = events
        .where((event) => event is! HandleRates && event is! HandleTextField);
    final Stream<EditTutorProfileEvent> debounceStream = events
        .where((event) => event is HandleRates || event is HandleTextField)
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
        event.isCacheProfile,
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
    } else if (event is CacheForm) {
      yield* _mapCacheFormToState();
    } else if (event is ResetForm) {
      yield* _mapResetFormToState();
    }
  }

  Stream<EditTutorProfileState> _mapInitialiseFieldsToState(
    TutorProfileModel profile,
    UserModel userDetails,
    bool isCacheForm,
  ) async* {
    tutorProfileInfo = <String, dynamic>{
      GENDER: Gender.fromIndex(EditTutorProfileState.initial().genderSelection),
      RATE_TYPE:
          RateTypes.fromIndex(EditTutorProfileState.initial().rateTypeSelction),
      IS_PUBLIC: EditTutorProfileState.initial().isAcceptingStudent,
    };
    this.userDetails = userDetails;
    if (isCacheForm) {
      final result = await getCacheTutorProfile(NoParams());
      yield* result.fold(
        (l) async* {
          yield state.failure(
              'Error retrieving stored profile, retrieving live version instead');
          add(InitialiseProfileFields(
            isCacheProfile: false,
            tutorProfile: profile,
            userDetails: userDetails,
          ));
        },
        (r) async* {
          final TutorProfileModel model = TutorProfileModel.fromDomainEntity(r);
          print('displaying: ' + model.toString());
          yield state.copyWith(
            genderSelection: Gender.toIndex(model.gender),
            classFormatSelection: ClassFormat.toIndices(model.formats),
            levelsTaught: model.levelsTaught,
            subjectsTaught: model.subjects,
            subjectsToDisplay:
                subject.Subject.getSubjectsToDisplay(model.levelsTaught),
            subjectHint: 'Subjects',
            tutorOccupation: model.tutorOccupation,
            rateTypeSelction: RateTypes.toIndex(model.rateType),
            initialRateMin: model.rateMin.toString(),
            initialRateMax: model.rateMax.toString(),
            initialTiming: model.timing,
            initiallocation: model.location,
            initialQualification: model.qualifications,
            initialSellingPoint: model.sellingPoints,
            isAcceptingStudent: model.isPublic,
          );
        },
      );
    } else if (userDetails.isTutor) {
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

  Stream<EditTutorProfileState> _mapHandleRateToState(
      {String fieldName, String value}) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(value);
    final bool isValidRate = validator.isDoubleValidator.isValid(value);
    if (isValidRate && isNotEmpty) {
      yield* _mapFieldToErrorState(fieldName, isValid: true);
      tutorProfileInfo
          .addAll(<String, dynamic>{fieldName: double.parse(value)});
    } else {
      yield* _mapFieldToErrorState(fieldName, isValid: false);
      tutorProfileInfo.remove(fieldName);
    }
  }

  Stream<EditTutorProfileState> _mapHandleTextField(
      {String fieldName, String value}) async* {
    final bool isNotEmpty = validator.nonEmptyStringValidator.isValid(value);
    if (isNotEmpty) {
      tutorProfileInfo.addAll(<String, dynamic>{fieldName: value});
      yield* _mapFieldToErrorState(fieldName, isValid: true);
    } else {
      tutorProfileInfo.remove(fieldName);
      yield* _mapFieldToErrorState(fieldName, isValid: false);
    }
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
    }
  }

  Stream<EditTutorProfileState> _mapHandleToggleButtonClickToState(
      String fieldName, dynamic index) async* {
    print('just entere' + tutorProfileInfo.toString());
    switch (fieldName) {
      case GENDER:
        yield state.update(
          genderSelection: index,
          isGenderValid: true,
        );
        tutorProfileInfo[GENDER] = Gender.fromIndex(index);
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
            ? tutorProfileInfo.addAll(<String, dynamic>{
                fieldName: ClassFormat.fromIndices(state.classFormatSelection)
              })
            : tutorProfileInfo.remove(fieldName);
        break;
      case RATE_TYPE:
        yield state.update(
          rateTypeSelction: index,
          isTypeRateValid: true,
        );
        tutorProfileInfo[RATE_TYPE] = RateTypes.fromIndex(index);

        break;
      case TUTOR_OCCUPATION:
        // ! POtentially buggy
        yield state.update(
            tutorOccupation: index, isTutorOccupationValid: index != null);
        tutorProfileInfo.addAll(<String, dynamic>{fieldName: index});
        break;
      case SUBJECTS:
        yield state.update(
          subjectsTaught: index,
          isSelectedSubjectsValid: index.isNotEmpty,
        );
        index.isNotEmpty
            ? tutorProfileInfo.addAll(<String, dynamic>{fieldName: index})
            : tutorProfileInfo.remove(fieldName);
        break;
      case LEVELS_TAUGHT:
        yield state.update(levelsTaught: index);
        final bool valid = index.isNotEmpty;
        if (valid) {
          final List<String> subjectsAvailToTeach =
              subject.Subject.getSubjectsToDisplay(index);
          state.subjectsTaught.removeWhere(
              (element) => !subjectsAvailToTeach.contains(element));
          print('subjects teaching ' + state.subjectsTaught.toString());
          tutorProfileInfo.addAll(<String, dynamic>{
            fieldName: index,
            SUBJECTS: state.subjectsTaught
          });
          yield state.update(
            subjectsToDisplay: subjectsAvailToTeach,
            subjectsTaught: state.subjectsTaught,
            subjectHint: 'Subjects',
            isSelectedLevelsTaughtValid: valid,
          );
        } else {
          tutorProfileInfo.remove(fieldName);
          yield state.update(
            isSelectedLevelsTaughtValid: valid,
            subjectsTaught: [],
            subjectsToDisplay: [],
            subjectHint: 'please select a level first',
          );
        }
        print('done level taught ' + tutorProfileInfo.toString());
        break;
      case IS_PUBLIC:
        yield state.update(isAcceptingStudent: index);
        tutorProfileInfo.addAll(<String, dynamic>{fieldName: index});
        break;
    }
  }

  Stream<EditTutorProfileState> _mapSubmitFormToState() async* {
    yield state.loading();
    final bool isValid = _verifyFields(tutorProfileInfo);
    if (!isValid || !state.isValid()) {
      yield state.failure(
          'Please fill in the blanks or make some changes before saving.');
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
    final Either<Failure, bool> result = userDetails.isTutor
        ? await updateTutorProfile(model.toDomainEntity())
        : await setTutorProfile(model.toDomainEntity());
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
      CLASS_FORMATS,
      LEVELS_TAUGHT,
      SUBJECTS,
      TUTOR_OCCUPATION,
      RATEMIN,
      RATEMAX,
      LOCATION,
      TIMING,
      QUALIFICATIONS,
      SELLING_POINTS,
    ];
    bool toReturn = true;
    for (var key in fieldsToVerify) {
      if (!tutorProfileInfo.containsKey(key)) {
        toReturn = false;
      }
    }
    return toReturn;
  }

  Stream<EditTutorProfileState> _mapCacheFormToState() async* {
    print(tutorProfileInfo);

    final TutorProfileModel model = TutorProfileModel(
      uid: userDetails.uid,
      gender: tutorProfileInfo[GENDER],
      rateType: tutorProfileInfo[RATE_TYPE],
      tutorOccupation:
          tutorProfileInfo[TUTOR_OCCUPATION] ?? state.tutorOccupation,
      levelsTaught: tutorProfileInfo[LEVELS_TAUGHT] ?? state.levelsTaught,
      subjects: tutorProfileInfo[SUBJECTS] ?? state.subjectsTaught,
      formats: tutorProfileInfo[CLASS_FORMATS] ??
          ClassFormat.fromIndices(state.classFormatSelection),
      rateMax: tutorProfileInfo[RATEMAX] ?? double.parse(state.initialRateMax),
      rateMin: tutorProfileInfo[RATEMIN] ?? double.parse(state.initialRateMin),
      timing: tutorProfileInfo[TIMING] ?? state.initialTiming,
      location: tutorProfileInfo[LOCATION] ?? state.initiallocation,
      qualifications:
          tutorProfileInfo[QUALIFICATIONS] ?? state.initialQualification,
      sellingPoints:
          tutorProfileInfo[SELLING_POINTS] ?? state.initialSellingPoint,
      isPublic: tutorProfileInfo[IS_PUBLIC],
      tutorNameModel: userDetails.name,
      photoUrl: userDetails.photoUrl,
      isVerifiedTutor: userDetails.isVerifiedTutor,
    );
    print('model to be cahcehd: ' + model.toString());
    print(tutorProfileInfo[RATE_TYPE]);
    await cacheTutorProfile(model);
    yield state.copyWith();
  }

  Stream<EditTutorProfileState> _mapResetFormToState() async* {
    tutorProfileInfo.clear();
    yield EditTutorProfileState.initial();
  }
}
