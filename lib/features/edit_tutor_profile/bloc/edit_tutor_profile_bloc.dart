import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/class_format.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/rate_types.dart';
import 'package:cotor/domain/entities/post/base_post/gender.dart';
import 'package:cotor/domain/entities/post/base_post/tutor_occupation.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/usecases/user/manage_profile/cache_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/manage_profile/get_cache_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/manage_profile/set_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/manage_profile/update_tutor_profile.dart';
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
  User userDetails;

  @override
  EditTutorProfileState get initialState {
    return EditTutorProfileState.initial();
  }

  @override
  Stream<Transition<EditTutorProfileEvent, EditTutorProfileState>>
      transformEvents(Stream<EditTutorProfileEvent> events, transitionFn) {
    final Stream<EditTutorProfileEvent> nonDebounceStream = events
        .where((event) => event is! HandleRates && event is! HandleTextField);
    final Stream<EditTutorProfileEvent> debounceStream = events
        .where((event) => event is HandleRates || event is HandleTextField)
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<EditTutorProfileState> mapEventToState(
    EditTutorProfileEvent event,
  ) async* {
    if (event is EditTutorProfileBlocInitialise) {
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
    TutorProfile profile,
    User userDetails,
    bool isCacheForm,
  ) async* {
    this.userDetails = userDetails;
    tutorProfileInfo = _initialiseMapFields(
        profile, userDetails.identity.accountType.isTutor());
    if (isCacheForm) {
      final result = await getCacheTutorProfile(NoParams());
      yield* result.fold(
        (l) async* {
          yield state.failure(
              'Error retrieving stored profile, retrieving live version instead');
          add(EditTutorProfileBlocInitialise(
            isCacheProfile: false,
            tutorProfile: profile,
            userDetails: userDetails,
          ));
        },
        (r) async* {
          tutorProfileInfo = _initialiseMapFields(
              profile, userDetails.identity.accountType.isTutor());
          print('displaying: ' + r.toString());
          yield state.copyWith(
            genderSelection: r.identity.gender.toIndex(),
            classFormatSelection: r.requirements.classFormat
                .map<int>((e) => e.toIndex())
                .toList(),
            levelsTaught:
                r.details.levelsTaught.map((e) => e.toString()).toList(),
            subjectsTaught:
                r.details.subjectsTaught.map((e) => e.toString()).toList(),
            subjectsLabels:
                SubjectArea.getSubjectsToDisplay(r.details.levelsTaught)
                    .map((e) => e.toString())
                    .toList(),
            subjectHint: 'Subjects',
            tutorOccupation: r.details.occupation.toString(),
            rateTypeSelction: r.requirements.price.rateType.toIndex(),
            initialRateMin: r.requirements.price.minRate.toString(),
            initialRateMax: r.requirements.price.maxRate.toString(),
            initialTiming: r.requirements.timing.toString(),
            initiallocation: r.requirements.location.toString(),
            initialQualification: r.details.qualification.toString(),
            initialSellingPoint: r.details.sellingPoints.toString(),
            isAcceptingStudent: r.identity.isOpen,
          );
        },
      );
    } else if (userDetails.identity.accountType.isTutor()) {
      yield state.copyWith(
        genderSelection: profile.identity.gender.toIndex(),
        classFormatSelection:
            profile.requirements.classFormat.map((e) => e.toIndex()).toList(),
        levelsTaught:
            profile.details.levelsTaught.map((e) => e.toString()).toList(),
        subjectsTaught:
            profile.details.subjectsTaught.map((e) => e.toString()).toList(),
        subjectsLabels:
            SubjectArea.getSubjectsToDisplay(profile.details.levelsTaught)
                .map((e) => e.toString())
                .toList(),
        subjectHint: 'Subjects',
        tutorOccupation: profile.details.occupation.toString(),
        rateTypeSelction: profile.requirements.price.rateType.toIndex(),
        initialRateMin: profile.requirements.price.minRate.toString(),
        initialRateMax: profile.requirements.price.maxRate.toString(),
        initialTiming: profile.requirements.timing.toString(),
        initiallocation: profile.requirements.location.toString(),
        initialQualification: profile.details.qualification.toString(),
        initialSellingPoint: profile.details.sellingPoints.toString(),
        isAcceptingStudent: profile.identity.isOpen,
      );
    } else {
      yield state.copyWith(
        subjectsLabels: [],
        classFormatSelection: [1],
        levelsTaught: [],
        subjectsTaught: [],
      );
    }
  }

  Map<String, dynamic> _initialiseMapFields(
      TutorProfile profile, bool isTutor) {
    return !isTutor
        ? <String, dynamic>{
            GENDER: Gender.fromIndex(
                EditTutorProfileState.initial().genderSelection),
            CLASS_FORMATS: ClassFormat.fromIndices(
              EditTutorProfileState.initial().classFormatSelection,
            ),
            RATE_TYPE: RateTypes.fromIndex(
                EditTutorProfileState.initial().rateTypeSelction),
            MAX_RATE:
                double.parse(EditTutorProfileState.initial().initialRateMax),
            MIN_RATE:
                double.parse(EditTutorProfileState.initial().initialRateMin),
            IS_OPEN: EditTutorProfileState.initial().isAcceptingStudent,
          }
        : <String, dynamic>{
            GENDER: profile.identity.gender,
            TUTOR_OCCUPATION: profile.details.occupation,
            LEVELS_TAUGHT: profile.details.levelsTaught,
            SUBJECTS: profile.details.levelsTaught,
            CLASS_FORMATS: profile.requirements.classFormat,
            RATE_TYPE: profile.requirements.price.rateType,
            MIN_RATE: profile.requirements.price.minRate,
            MAX_RATE: profile.requirements.price.maxRate,
            PROPOSED_RATE: profile.requirements.price.proposedRate,
            TIMING: profile.requirements.timing,
            LOCATION: profile.requirements.location,
            QUALIFICATIONS: profile.details.qualification,
            SELLING_POINTS: profile.details.sellingPoints,
            IS_OPEN: profile.identity.isOpen,
          };
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
      case MAX_RATE:
        yield state.update(isRateMaxValid: isValid);
        break;
      case MIN_RATE:
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
            ? tutorProfileInfo.addAll(<String, dynamic>{
                fieldName: index.map((String e) => SubjectArea(e)).toList()
              })
            : tutorProfileInfo.remove(fieldName);
        break;
      case LEVELS_TAUGHT:
        yield state.update(levelsTaught: index);
        final bool valid = index.isNotEmpty;
        if (valid) {
          final List<String> subjectsAvailToTeach =
              SubjectArea.getSubjectsToDisplay(
                      index.map((String e) => Level(e)))
                  .map((e) => e.toString())
                  .toList();
          state.subjectsTaught.removeWhere(
              (element) => !subjectsAvailToTeach.contains(element));
          tutorProfileInfo.addAll(<String, dynamic>{
            fieldName: index,
            SUBJECTS: state.subjectsTaught
          });
          yield state.update(
            subjectsLabels: subjectsAvailToTeach,
            subjectsTaught: state.subjectsTaught,
            subjectHint: 'Subjects',
            isSelectedLevelsTaughtValid: valid,
          );
        } else {
          tutorProfileInfo.remove(fieldName);
          yield state.update(
            isSelectedLevelsTaughtValid: valid,
            subjectsTaught: [],
            subjectsLabels: [],
            subjectHint: 'please select a level first',
          );
        }
        break;
      case IS_OPEN:
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
    final TutorProfile model = TutorProfile(
      identityTutor: IdentityTutor(
        isVerifiedTutor: userDetails.identity.accountType.isVerTutor(),
        isOpen: tutorProfileInfo[IS_OPEN],
        gender: tutorProfileInfo[GENDER],
        uid: userDetails.identity.uid,
        name: userDetails.identity.name,
        photoUrl: userDetails.identity.photoUrl,
      ),
      detailsTutor: DetailsTutor(
        levelsTaught: tutorProfileInfo[LEVELS_TAUGHT],
        subjectsTaught: tutorProfileInfo[SUBJECTS],
        tutorOccupation: tutorProfileInfo[TUTOR_OCCUPATION],
        qualification: tutorProfileInfo[QUALIFICATIONS],
        sellingPoints: tutorProfileInfo[SELLING_POINTS],
      ),
      requirementsTutor: RequirementsTutor(
        price: Price(
          rateType: tutorProfileInfo[RATE_TYPE],
          proposedRate: tutorProfileInfo[PROPOSED_RATE],
          maxRate: tutorProfileInfo[MAX_RATE],
          minRate: tutorProfileInfo[MIN_RATE],
        ),
        classFormat: tutorProfileInfo[CLASS_FORMATS],
        timing: tutorProfileInfo[TIMING],
        location: tutorProfileInfo[LOCATION],
      ),
    );
    print(model);
    final Either<Failure, bool> result =
        userDetails.identity.accountType.isTutor()
            ? await updateTutorProfile(model)
            : await setTutorProfile(model);
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
      MIN_RATE,
      MAX_RATE,
      LOCATION,
      TIMING,
      QUALIFICATIONS,
      SELLING_POINTS,
    ];
    for (var key in fieldsToVerify) {
      if (!tutorProfileInfo.containsKey(key)) {
        print('tutor profile info does not contain' + key);
        return false;
      }
    }
    return true;
  }

  Stream<EditTutorProfileState> _mapCacheFormToState() async* {
    print(tutorProfileInfo);

    final TutorProfile model = TutorProfile(
      identityTutor: IdentityTutor(
        isVerifiedTutor: userDetails.identity.accountType.isVerTutor(),
        isOpen: tutorProfileInfo[IS_OPEN],
        gender: tutorProfileInfo[GENDER],
        uid: userDetails.identity.uid,
        name: userDetails.identity.name,
        photoUrl: userDetails.identity.photoUrl,
      ),
      detailsTutor: DetailsTutor(
        levelsTaught: tutorProfileInfo[LEVELS_TAUGHT],
        subjectsTaught: tutorProfileInfo[SUBJECTS],
        tutorOccupation: tutorProfileInfo[TUTOR_OCCUPATION],
        qualification: tutorProfileInfo[QUALIFICATIONS],
        sellingPoints: tutorProfileInfo[SELLING_POINTS],
      ),
      requirementsTutor: RequirementsTutor(
        price: Price(
          rateType: tutorProfileInfo[RATE_TYPE],
          proposedRate: tutorProfileInfo[PROPOSED_RATE],
          maxRate: tutorProfileInfo[MAX_RATE],
          minRate: tutorProfileInfo[MIN_RATE],
        ),
        classFormat: tutorProfileInfo[CLASS_FORMATS],
        timing: tutorProfileInfo[TIMING],
        location: tutorProfileInfo[LOCATION],
      ),
      // uid: userDetails.uid,
      // gender: tutorProfileInfo[GENDER],
      // rateType: tutorProfileInfo[RATE_TYPE],
      // tutorOccupation:
      //     tutorProfileInfo[TUTOR_OCCUPATION] ?? state.tutorOccupation,
      // levelsTaught: tutorProfileInfo[LEVELS_TAUGHT] ?? state.levelsTaught,
      // subjects: tutorProfileInfo[SUBJECTS] ?? state.subjectsTaught,
      // formats: tutorProfileInfo[CLASS_FORMATS] ??
      //     ClassFormat.fromIndices(state.classFormatSelection),
      // rateMax: tutorProfileInfo[MAX_RATE] ?? double.parse(state.initialRateMax),
      // rateMin: tutorProfileInfo[MIN_RATE:] ?? double.parse(state.initialRateMin),
      // timing: tutorProfileInfo[TIMING] ?? state.initialTiming,
      // location: tutorProfileInfo[LOCATION] ?? state.initiallocation,
      // qualifications:
      //     tutorProfileInfo[QUALIFICATIONS] ?? state.initialQualification,
      // sellingPoints:
      //     tutorProfileInfo[SELLING_POINTS] ?? state.initialSellingPoint,
      // isPublic: tutorProfileInfo[IS_OPENIS_OPEN],
      // tutorName: userDetails.name,
      // photoUrl: userDetails.photoUrl,
      // isVerifiedTutor: userDetails.isVerifiedTutor,
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
