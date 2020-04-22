import 'dart:math' as math;

import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/buttons/toggle_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/common_widgets/platform_alert_dialog.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/class_format.dart';
import 'package:cotor/domain/entities/gender.dart';
import 'package:cotor/domain/entities/level.dart';
import 'package:cotor/domain/entities/rate_types.dart';
import 'package:cotor/domain/entities/tutor_occupation.dart';
import 'package:cotor/features/edit_tutor_profile/bloc/edit_tutor_profile_bloc.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiple_select/Item.dart';
import 'package:multiple_select/multi_filter_select.dart';

class EditTutorPage extends StatefulWidget {
  @override
  EditTutorPageState createState() => EditTutorPageState();
}

class EditTutorPageState extends State<EditTutorPage> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  EditTutorProfileBloc editProfileBloc;
  UserProfileBloc userProfileBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool _isButtonPressable(EditTutorProfileState state) {
    return state.isValid();
  }

  @override
  void initState() {
    editProfileBloc = BlocProvider.of<EditTutorProfileBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            CustomSliverAppbar(
              title: Strings.editTutorProfile,
              isTitleCenter: true,
              showActions: false,
              leading: IconButton(
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    Icons.exit_to_app,
                    color: ColorsAndFonts.primaryColor,
                  ),
                ),
                onPressed: () async {
                  final bool toSave = await PlatformAlertDialog(
                    title: 'Leaving',
                    content: 'What would you like to do with your edits?',
                    defaultActionText: 'Save',
                    cancelActionText: 'Discard',
                  ).show(context);
                  if (toSave != null) {
                    if (toSave) {
                      // TODO(ElasticBottle): Cache profile
                    }
                    editProfileBloc.add(ResetForm());
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            BlocListener<EditTutorProfileBloc, EditTutorProfileState>(
              listener: (context, state) {
                if (state.isFailure) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.error),
                            SizedBox(width: 20.0),
                            Expanded(child: Text(state.failureMessage))
                          ],
                        ),
                        action: SnackBarAction(
                          label: Strings.dismiss,
                          onPressed: () {
                            Scaffold.of(context).hideCurrentSnackBar();
                          },
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                } else if (state.isSuccess) {
                  editProfileBloc.add(ResetForm());
                  userProfileBloc.add(UpdateProfileSuccess('Success'));
                  Navigator.of(context).pop();
                }
              },
              child: BlocBuilder<EditTutorProfileBloc, EditTutorProfileState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SpacingsAndHeights.addAssignmentPageSidePadding),
                      child: Column(
                        children: <Widget>[
                          _getRadioSelectors(state),
                          _getTextFormFields(state),
                          _getOpenToApplicationSwitch(state),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: CustomRaisedButton(
                              onPressed: _isButtonPressable(state)
                                  ? _formSubmit
                                  : null,
                              loading: state.isSubmitting,
                              color: ColorsAndFonts.primaryColor,
                              textColor: ColorsAndFonts.backgroundColor,
                              child: Text(
                                Strings.addAssignment,
                                style: TextStyle(
                                  fontFamily: ColorsAndFonts.primaryFont,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ColorsAndFonts
                                      .AddAssignmntSubmitButtonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRadioSelectors(EditTutorProfileState state) {
    return Column(
      children: <Widget>[
        ToggleButton(
          title: 'Gender',
          errorText: state.isGenderValid ? null : 'Please state your gender',
          fontFamily: ColorsAndFonts.primaryFont,
          activeBgColor: ColorsAndFonts.primaryColor,
          activeTextColor: ColorsAndFonts.backgroundColor,
          inactiveTextColor: ColorsAndFonts.primaryColor,
          labels: Gender.genders,
          icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
          onPressed: (int index) {
            editProfileBloc.add(
              HandleToggleButtonClick(fieldName: GENDER, index: index),
            );
            editProfileBloc.add(
              SaveField(key: GENDER, value: index),
            );
          },
          initialLabelIndex: [state.genderSelection],
        ),
        ToggleButton(
          title: 'Class Format',
          errorText:
              state.isClassFormatsValid ? null : 'Please select your options',
          fontFamily: ColorsAndFonts.primaryFont,
          activeBgColor: ColorsAndFonts.primaryColor,
          activeTextColor: ColorsAndFonts.backgroundColor,
          inactiveTextColor: ColorsAndFonts.primaryColor,
          labels: ClassFormat.formats,
          onPressed: (int index) {
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: CLASS_FORMATS, index: index));
            editProfileBloc.add(
              CheckDropDownNotEmpty(fieldName: CLASS_FORMATS),
            );
            editProfileBloc.add(SaveField(key: CLASS_FORMATS));
            setState(() {});
          },
          initialLabelIndex: state.classFormatSelection,
        ),
        MultiFilterSelect(
          placeholder: 'Levels',
          allItems: Level.all
              .map<Item<String, String, String>>(
                (e) => Item<String, String, String>.build(
                  value: e,
                  display: '$e',
                  content: '$e',
                ),
              )
              .toList(),
          initValue: state.levelsTaught,
          selectCallback: (List selectedValue) {
            print(selectedValue.toString());
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: LEVELS_TAUGHT, index: selectedValue));
            editProfileBloc.add(
              CheckDropDownNotEmpty(fieldName: LEVELS_TAUGHT),
            );
            editProfileBloc
                .add(SaveField(key: LEVELS_TAUGHT, value: selectedValue));
          },
        ),
        SizedBox(height: 15.0),
        MultiFilterSelect(
          placeholder: state.subjectHint,
          allItems: state.subjectsToDisplay
              .map<Item<String, String, String>>(
                (e) => Item<String, String, String>.build(
                  value: e,
                  display: e,
                  content: e,
                ),
              )
              .toList(),
          selectCallback: (List selectedValue) {
            print(selectedValue.toString());
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: SUBJECTS, index: selectedValue));
            editProfileBloc.add(
              CheckDropDownNotEmpty(fieldName: SUBJECTS),
            );
            editProfileBloc.add(SaveField(key: SUBJECTS, value: selectedValue));
          },
          initValue: state.subjectsTaught,
        ),
        SizedBox(height: 15.0),
        MultiFilterSelect(
          placeholder: 'Tutor Occupation',
          allItems: TutorOccupation.occupations
              .map<Item<String, String, String>>(
                (e) => Item<String, String, String>.build(
                  value: e,
                  display: e,
                  content: e,
                ),
              )
              .toList(),
          selectCallback: (List selectedValue) {
            print(selectedValue.toString());
            selectedValue.removeWhere((dynamic element) => element == null);
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: TUTOR_OCCUPATION, index: selectedValue[0]));
            editProfileBloc.add(
              CheckDropDownNotEmpty(fieldName: TUTOR_OCCUPATION),
            );
            editProfileBloc
                .add(SaveField(key: TUTOR_OCCUPATION, value: selectedValue[0]));
          },
          initValue: <String>[state.tutorOccupation],
        ),
        SizedBox(height: 15.0),
        ToggleButton(
          title: 'Rate Type',
          errorText:
              state.isTypeRateValid ? null : 'Please select your rate type',
          fontFamily: ColorsAndFonts.primaryFont,
          activeBgColor: ColorsAndFonts.primaryColor,
          activeTextColor: ColorsAndFonts.backgroundColor,
          inactiveTextColor: ColorsAndFonts.primaryColor,
          labels: RateTypes.types,
          onPressed: (int index) {
            editProfileBloc.add(
                HandleToggleButtonClick(fieldName: RATE_TYPE, index: index));
            editProfileBloc.add(SaveField(key: RATE_TYPE, value: index));
          },
          initialLabelIndex: [state.rateTypeSelction],
        ),
      ],
    );
  }

  Widget _getTextFormFields(EditTutorProfileState state) {
    return FocusScope(
      node: _focusScopeNode,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Strings.rate,
              style: TextStyle(
                color: ColorsAndFonts.primaryColor,
                fontFamily: ColorsAndFonts.primaryFont,
                fontWeight: FontWeight.normal,
                fontSize: ColorsAndFonts.AddAssignmntRateFontSize,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: CustomTextField(
                    labelText: Strings.rateMin,
                    initialText: state.initialRateMin,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: _handleSubmitted,
                    errorText: state.isRateMinValid ? null : Strings.rateError,
                    prefixIcon: Icon(Icons.attach_money),
                    onChanged: (String value) => editProfileBloc.add(
                        CheckRatesAreValid(fieldName: RATEMIN, toCheck: value)),
                    onSaved: (String field) => editProfileBloc.add(SaveField(
                      value: field,
                      key: RATEMIN,
                    )),
                  ),
                ),
                SizedBox(
                    width: SpacingsAndHeights.addAssignmentPageFieldSpacing),
                Expanded(
                  flex: 10,
                  child: CustomTextField(
                    labelText: Strings.rateMax,
                    initialText: state.initialRateMax,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: _handleSubmitted,
                    errorText: state.isRateMaxValid ? null : Strings.rateError,
                    prefixIcon: Icon(Icons.attach_money),
                    onChanged: (String value) => editProfileBloc.add(
                        CheckRatesAreValid(fieldName: RATEMAX, toCheck: value)),
                    onSaved: (String field) => editProfileBloc.add(SaveField(
                      value: field,
                      key: RATEMAX,
                    )),
                  ),
                ),
              ],
            ),
            CustomTextField(
              labelText: Strings.timing,
              helpText: Strings.timingHelperText,
              maxLines: SpacingsAndHeights.timingMaxLines,
              textInputAction: TextInputAction.newline,
              // onFieldSubmitted: _handleSubmitted,
              initialText: state.initialTiming,
              errorText: state.isTimingValid
                  ? null
                  : Strings.invalidFieldCannotBeEmpty,
              prefixIcon: Icon(Icons.watch),
              onChanged: (String value) => editProfileBloc.add(
                  CheckTextFieldNotEmpty(fieldName: TIMING, toCheck: value)),
              onSaved: (String field) => editProfileBloc.add(SaveField(
                value: field,
                key: TIMING,
              )),
            ),
            CustomTextField(
              labelText: Strings.location,
              helpText: Strings.locationHelperText,
              maxLines: SpacingsAndHeights.locationMaxLines,
              textInputAction: TextInputAction.newline,
              prefixIcon: Icon(Icons.location_on),
              initialText: state.initiallocation,
              errorText: state.isLocationValid
                  ? null
                  : Strings.invalidFieldCannotBeEmpty,
              onChanged: (String value) => editProfileBloc.add(
                  CheckTextFieldNotEmpty(fieldName: LOCATION, toCheck: value)),
              onSaved: (String field) => editProfileBloc.add(SaveField(
                value: field,
                key: LOCATION,
              )),
            ),
            CustomTextField(
              labelText: Strings.qualifications,
              helpText: Strings.freqHelperText,
              textInputAction: TextInputAction.newline,
              onFieldSubmitted: _handleSubmitted,
              errorText: state.isQualificationValid
                  ? null
                  : Strings.invalidFieldCannotBeEmpty,
              initialText: state.initialQualification,
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                child: FaIcon(FontAwesomeIcons.certificate),
              ),
              onChanged: (String value) => editProfileBloc.add(
                  CheckTextFieldNotEmpty(
                      fieldName: QUALIFICATIONS, toCheck: value)),
              onSaved: (String field) => editProfileBloc.add(SaveField(
                value: field,
                key: QUALIFICATIONS,
              )),
            ),
            CustomTextField(
              labelText: Strings.sellingPoints,
              helpText: Strings.additionalRemarksHelperText,
              maxLines: SpacingsAndHeights.addRemarksMaxLines,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _focusScopeNode.unfocus(),
              prefixIcon: Icon(Icons.speaker_notes),
              errorText: state.isSellingPointValid
                  ? null
                  : Strings.invalidFieldCannotBeEmpty,
              initialText: state.initialSellingPoint,
              onChanged: (String value) => editProfileBloc.add(
                  CheckTextFieldNotEmpty(
                      fieldName: SELLING_POINTS, toCheck: value)),
              onSaved: (String field) => editProfileBloc.add(SaveField(
                value: field,
                key: SELLING_POINTS,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getOpenToApplicationSwitch(EditTutorProfileState state) {
    return SwitchListTile(
      title: const Text('Accepting Students?'),
      value: state.isAcceptingStudent,
      onChanged: (bool value) {
        editProfileBloc
            .add(HandleToggleButtonClick(fieldName: IS_PUBLIC, index: value));
        editProfileBloc.add(SaveField(key: IS_PUBLIC, value: value));
        setState(() {});
      },
      secondary: const Icon(FontAwesomeIcons.universalAccess),
    );
  }

  void _formSubmit() {
    // editProfileBloc.add(CheckDropDownNotEmpty(fieldName: TUTOR_OCCUPATION));
    final FormState state = _formKey.currentState;
    state.setState(() {});
    state.save();
    editProfileBloc.add(SubmitForm());
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }
}
