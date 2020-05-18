import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/form_field_keys.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
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
          print('displaying: ' + r.toString());
          tutorProfileInfo = _initialiseMapFields(r, true);
          yield state.update(
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
      yield state.update(
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
      yield state.update(
        subjectsLabels: [],
        classFormatSelection: [1],
        levelsTaught: [],
        subjectsTaught: [],
      );
    }
  }

  Map<String, dynamic> _initialiseMapFields(TutorProfile profile, bool isOld) {
    return !isOld
        ? <String, dynamic>{
            FormFieldKey.DATE_DETAILS: DateDetails(),
            FormFieldKey.GENDER: Gender.fromIndex(
                EditTutorProfileState.initial().genderSelection),
            FormFieldKey.CLASS_FORMATS: ClassFormat.fromIndices(
              EditTutorProfileState.initial().classFormatSelection,
            ),
            FormFieldKey.RATE_TYPE: RateTypes.fromIndex(
                EditTutorProfileState.initial().rateTypeSelction),
            FormFieldKey.MAX_RATE:
                double.parse(EditTutorProfileState.initial().initialRateMax),
            FormFieldKey.MIN_RATE:
                double.parse(EditTutorProfileState.initial().initialRateMin),
            FormFieldKey.PROPOSED_RATE: 0.0,
            FormFieldKey.IS_OPEN:
                EditTutorProfileState.initial().isAcceptingStudent,
          }
        : <String, dynamic>{
            FormFieldKey.DATE_DETAILS: profile.details.dateDetails,
            FormFieldKey.GENDER: profile.identity.gender,
            FormFieldKey.TUTOR_OCCUPATION: profile.details.occupation,
            FormFieldKey.LEVELS_TAUGHT: profile.details.levelsTaught,
            FormFieldKey.SUBJECTS_TAUGHT: profile.details.subjectsTaught,
            FormFieldKey.CLASS_FORMATS: profile.requirements.classFormat,
            FormFieldKey.RATE_TYPE: profile.requirements.price.rateType,
            FormFieldKey.MIN_RATE: profile.requirements.price.minRate,
            FormFieldKey.MAX_RATE: profile.requirements.price.maxRate,
            FormFieldKey.PROPOSED_RATE: profile.requirements.price.proposedRate,
            FormFieldKey.TIMING: profile.requirements.timing,
            FormFieldKey.LOCATION: profile.requirements.location,
            FormFieldKey.QUALIFICATIONS: profile.details.qualification,
            FormFieldKey.SELLING_POINTS: profile.details.sellingPoints,
            FormFieldKey.IS_OPEN: profile.identity.isOpen,
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
      yield* _mapFieldToErrorState(fieldName, value: value, isValid: true);
    } else {
      tutorProfileInfo.remove(fieldName);
      yield* _mapFieldToErrorState(fieldName, value: value, isValid: false);
    }
  }

  Stream<EditTutorProfileState> _mapFieldToErrorState(
    String fieldName, {
    bool isValid,
    String value,
  }) async* {
    switch (fieldName) {
      case FormFieldKey.MAX_RATE:
        yield state.update(isRateMaxValid: isValid);
        break;
      case FormFieldKey.MIN_RATE:
        yield state.update(isRateMinValid: isValid);
        break;
      case FormFieldKey.TIMING:
        tutorProfileInfo
            .addAll(<String, dynamic>{fieldName: Timing(timing: value)});
        yield state.update(isTimingValid: isValid);
        break;
      case FormFieldKey.LOCATION:
        tutorProfileInfo
            .addAll(<String, dynamic>{fieldName: Location(location: value)});
        yield state.update(isLocationValid: isValid);
        break;
      case FormFieldKey.QUALIFICATIONS:
        tutorProfileInfo.addAll(<String, dynamic>{
          fieldName: Qualifications(qualifications: value)
        });
        yield state.update(isQualificationValid: isValid);
        break;
      case FormFieldKey.SELLING_POINTS:
        tutorProfileInfo.addAll(
            <String, dynamic>{fieldName: SellingPoints(sellingPt: value)});
        yield state.update(isSellingPointValid: isValid);
        break;
    }
  }

  Stream<EditTutorProfileState> _mapHandleToggleButtonClickToState(
      String fieldName, dynamic index) async* {
    switch (fieldName) {
      case FormFieldKey.GENDER:
        yield state.update(
          genderSelection: index,
          isGenderValid: true,
        );
        tutorProfileInfo[fieldName] = Gender.fromIndex(index);
        break;
      case FormFieldKey.CLASS_FORMATS:
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
      case FormFieldKey.RATE_TYPE:
        yield state.update(
          rateTypeSelction: index,
          isTypeRateValid: true,
        );
        tutorProfileInfo[fieldName] = RateTypes.fromIndex(index);

        break;
      case FormFieldKey.TUTOR_OCCUPATION:
        final bool isValid = index.isNotEmpty;
        if (isValid) {
          yield state.update(
              tutorOccupation: index[0], isTutorOccupationValid: isValid);
          tutorProfileInfo
              .addAll(<String, dynamic>{fieldName: TutorOccupation(index[0])});
        } else {
          yield state.update(
              tutorOccupation: '', isTutorOccupationValid: isValid);
          tutorProfileInfo.remove(fieldName);
        }

        break;
      case FormFieldKey.SUBJECTS_TAUGHT:
        yield state.update(
          subjectsTaught: index,
          isSelectedSubjectsValid: index.isNotEmpty,
        );
        index.isNotEmpty
            ? tutorProfileInfo.addAll(<String, dynamic>{
                fieldName: index
                    .map<SubjectArea>((String e) => SubjectArea(e))
                    .toList()
              })
            : tutorProfileInfo.remove(fieldName);
        break;
      case FormFieldKey.LEVELS_TAUGHT:
        yield state.update(levelsTaught: index);
        final bool valid = index.isNotEmpty;
        if (valid) {
          final List<String> subjectsAvailToTeach =
              SubjectArea.getSubjectsToDisplay(
                      index.map<Level>((String e) => Level(e)).toList())
                  .map((e) => e.toString())
                  .toList();
          state.subjectsTaught.removeWhere(
              (element) => !subjectsAvailToTeach.contains(element));
          final List<String> sbjTaught = state.subjectsTaught;
          tutorProfileInfo.addAll(<String, dynamic>{
            fieldName: index.map<Level>((String e) => Level(e)).toList(),
            FormFieldKey.SUBJECTS_TAUGHT:
                sbjTaught.map<SubjectArea>((e) => SubjectArea(e)).toList()
          });
          yield state.update(
            subjectsLabels: subjectsAvailToTeach,
            subjectsTaught: state.subjectsTaught,
            subjectHint: Strings.subjectHint,
            isSelectedLevelsTaughtValid: valid,
          );
        } else {
          tutorProfileInfo.remove(fieldName);
          yield state.update(
            isSelectedLevelsTaughtValid: valid,
            subjectsTaught: [],
            subjectsLabels: [],
            subjectHint: Strings.subjectChooseLevelHint,
          );
        }
        break;
      case FormFieldKey.IS_OPEN:
        yield state.update(isAcceptingStudent: index);
        tutorProfileInfo[fieldName] = index;
        break;
    }
    print('exiting ' + tutorProfileInfo.toString());
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
        accountType: userDetails.identity.accountType,
        isOpen: tutorProfileInfo[FormFieldKey.IS_OPEN],
        gender: tutorProfileInfo[FormFieldKey.GENDER],
        uid: userDetails.identity.uid,
        name: userDetails.identity.name,
        photoUrl: userDetails.identity.photoUrl,
      ),
      detailsTutor: DetailsTutor(
        dateDetails: tutorProfileInfo[FormFieldKey.DATE_DETAILS],
        levelsTaught: tutorProfileInfo[FormFieldKey.LEVELS_TAUGHT],
        subjectsTaught: tutorProfileInfo[FormFieldKey.SUBJECTS_TAUGHT],
        tutorOccupation: tutorProfileInfo[FormFieldKey.TUTOR_OCCUPATION],
        qualification: tutorProfileInfo[FormFieldKey.QUALIFICATIONS],
        sellingPoints: tutorProfileInfo[FormFieldKey.SELLING_POINTS],
      ),
      requirementsTutor: RequirementsTutor(
        price: Price(
          rateType: tutorProfileInfo[FormFieldKey.RATE_TYPE],
          proposedRate: tutorProfileInfo[FormFieldKey.PROPOSED_RATE],
          maxRate: tutorProfileInfo[FormFieldKey.MAX_RATE],
          minRate: tutorProfileInfo[FormFieldKey.MIN_RATE],
        ),
        classFormat: tutorProfileInfo[FormFieldKey.CLASS_FORMATS],
        timing: tutorProfileInfo[FormFieldKey.TIMING],
        location: tutorProfileInfo[FormFieldKey.LOCATION],
      ),
      statsSimple: StatsSimple(),
    );
    print(model);
    final Either<Failure, bool> result =
        userDetails.identity.accountType.isTutor()
            ? await updateTutorProfile(model)
            : await setTutorProfile(model);
    yield* result.fold(
      (l) async* {
        if (l is ServerFailure) {
          yield state.failure(Strings.serverFailureErrorMsg);
        } else if (l is NetworkFailure) {
          yield state.failure(Strings.networkFailureErrorMsg);
        }
      },
      (r) async* {
        yield state.success('Success!');
      },
    );
  }

  bool _verifyFields(Map<String, dynamic> tutorProfileInfo) {
    final List<String> fieldsToVerify = [
      FormFieldKey.CLASS_FORMATS,
      FormFieldKey.LEVELS_TAUGHT,
      FormFieldKey.SUBJECTS_TAUGHT,
      FormFieldKey.TUTOR_OCCUPATION,
      FormFieldKey.MIN_RATE,
      FormFieldKey.MAX_RATE,
      FormFieldKey.LOCATION,
      FormFieldKey.TIMING,
      FormFieldKey.QUALIFICATIONS,
      FormFieldKey.SELLING_POINTS,
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
          accountType: userDetails.identity.accountType,
          isOpen: tutorProfileInfo[FormFieldKey.IS_OPEN],
          gender: tutorProfileInfo[FormFieldKey.GENDER],
          uid: userDetails.identity.uid,
          name: userDetails.identity.name,
          photoUrl: userDetails.identity.photoUrl,
        ),
        detailsTutor: DetailsTutor(
          dateDetails: tutorProfileInfo[FormFieldKey.DATE_DETAILS],
          levelsTaught:
              tutorProfileInfo[FormFieldKey.LEVELS_TAUGHT] ?? <Level>[],
          subjectsTaught:
              tutorProfileInfo[FormFieldKey.SUBJECTS_TAUGHT] ?? <SubjectArea>[],
          tutorOccupation: tutorProfileInfo[FormFieldKey.TUTOR_OCCUPATION] ??
              TutorOccupation(''),
          qualification: tutorProfileInfo[FormFieldKey.QUALIFICATIONS] ??
              Qualifications(qualifications: ''),
          sellingPoints: tutorProfileInfo[FormFieldKey.SELLING_POINTS] ??
              SellingPoints(sellingPt: ''),
        ),
        requirementsTutor: RequirementsTutor(
          price: Price(
            rateType: tutorProfileInfo[FormFieldKey.RATE_TYPE],
            proposedRate: tutorProfileInfo[FormFieldKey.PROPOSED_RATE],
            maxRate: tutorProfileInfo[FormFieldKey.MAX_RATE] ??
                EditTutorProfileState.initial().initialRateMax,
            minRate: tutorProfileInfo[FormFieldKey.MIN_RATE] ??
                EditTutorProfileState.initial().initialRateMin,
          ),
          classFormat:
              tutorProfileInfo[FormFieldKey.CLASS_FORMATS] ?? <ClassFormat>[],
          timing: tutorProfileInfo[FormFieldKey.TIMING] ?? Timing(timing: ''),
          location:
              tutorProfileInfo[FormFieldKey.LOCATION] ?? Location(location: ''),
        ),
        statsSimple: StatsSimple());
    print('model to be cahcehd: ' + model.toString());
    print(tutorProfileInfo[FormFieldKey.RATE_TYPE]);
    await cacheTutorProfile(model);
    yield state.copyWith();
  }

  Stream<EditTutorProfileState> _mapResetFormToState() async* {
    tutorProfileInfo.clear();
    yield EditTutorProfileState.initial();
  }
}
