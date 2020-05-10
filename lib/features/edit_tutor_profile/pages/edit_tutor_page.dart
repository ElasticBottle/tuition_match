import 'dart:math' as math;

import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/buttons/toggle_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/common_widgets/platform_alert_dialog.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/data/models/map_key_strings.dart';
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

  Future<bool> _confirmExit() async {
    final bool toSave = await PlatformAlertDialog(
      title: 'Leaving',
      content: 'What would you like to do with your edits?',
      defaultActionText: 'Save',
      cancelActionText: 'Discard',
    ).show(context);
    if (toSave != null) {
      userProfileBloc.add(CachedProfileToSet(false));
      if (toSave) {
        userProfileBloc.add(CachedProfileToSet(true));
        editProfileBloc.add(CacheForm());
      }
      editProfileBloc.add(ResetForm());
      Navigator.of(context).pop();
    }
    return false;
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
        body: WillPopScope(
          onWillPop: _confirmExit,
          child: CustomScrollView(
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
                  onPressed: _confirmExit,
                ),
              ),
              BlocConsumer<EditTutorProfileBloc, EditTutorProfileState>(
                listener: (context, state) {
                  if (state.isFailure) {
                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackBar(
                          message: state.failureMessage,
                          isError: true,
                          delay: 3,
                        ).show(context),
                      );
                    userProfileBloc.add(CachedProfileToSet(true));
                  } else if (state.isSuccess) {
                    editProfileBloc.add(ResetForm());
                    userProfileBloc.add(UpdateProfileSuccess('Success'));
                    userProfileBloc.add(CachedProfileToSet(false));
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SpacingsAndHeights.addAssignmentPageSidePadding),
                      child: Column(
                        children: <Widget>[
                          _getNonTextFields(state),
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
                                Strings.addAssignmentButtonText,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _getNonTextFields(EditTutorProfileState state) {
    return Column(
      children: <Widget>[
        ToggleButton(
          title: 'Gender',
          errorText: state.isGenderValid ? null : 'Please state your gender',
          fontFamily: ColorsAndFonts.primaryFont,
          activeBgColor: ColorsAndFonts.primaryColor,
          activeTextColor: ColorsAndFonts.backgroundColor,
          inactiveTextColor: ColorsAndFonts.primaryColor,
          labels: state.genderLabels,
          icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
          onPressed: (int index) {
            editProfileBloc.add(
              HandleToggleButtonClick(fieldName: GENDER, index: index),
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
          labels: state.classFormatLabels,
          onPressed: (int index) {
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: CLASS_FORMATS, index: index));
            setState(() {});
          },
          initialLabelIndex: state.classFormatSelection,
        ),
        MultiFilterSelect(
          placeholder: 'Levels',
          allItems: state.levelsLabels
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
            setState(() {});
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: LEVELS_TAUGHT, index: selectedValue));
          },
        ),
        SizedBox(height: 15.0),
        MultiFilterSelect(
          placeholder: state.subjectHint,
          allItems: state.subjectsLabels
              .map<Item<String, String, String>>(
                (e) => Item<String, String, String>.build(
                  value: e,
                  display: e,
                  content: e,
                ),
              )
              .toList(),
          initValue: state.subjectsTaught,
          selectCallback: (List selectedValue) {
            print(selectedValue.toString());
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: SUBJECTS, index: selectedValue));
          },
        ),
        SizedBox(height: 15.0),
        MultiFilterSelect(
          placeholder: 'Tutor Occupation',
          allItems: state.tutorOccupationLabels
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
          labels: state.rateTypeLabels,
          onPressed: (int index) {
            editProfileBloc.add(
                HandleToggleButtonClick(fieldName: RATE_TYPE, index: index));
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
              Strings.rateLabel,
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
                    labelText: Strings.rateMinLabel,
                    initialText: state.initialRateMin,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: _handleSubmitted,
                    errorText:
                        state.isRateMinValid ? null : Strings.errorRateInvalid,
                    prefixIcon: Icon(Icons.attach_money),
                    onChanged: (String value) {
                      editProfileBloc
                          .add(HandleRates(fieldName: MIN_RATE, value: value));
                    },
                  ),
                ),
                SizedBox(
                    width: SpacingsAndHeights.addAssignmentPageFieldSpacing),
                Expanded(
                  flex: 10,
                  child: CustomTextField(
                    labelText: Strings.rateMaxLabel,
                    initialText: state.initialRateMax,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: _handleSubmitted,
                    errorText:
                        state.isRateMaxValid ? null : Strings.errorRateInvalid,
                    prefixIcon: Icon(Icons.attach_money),
                    onChanged: (String value) {
                      editProfileBloc
                          .add(HandleRates(fieldName: MAX_RATE, value: value));
                    },
                  ),
                ),
              ],
            ),
            CustomTextField(
              labelText: Strings.timing,
              helpText: Strings.timingHint,
              maxLines: SpacingsAndHeights.timingMaxLines,
              textInputAction: TextInputAction.newline,
              // onFieldSubmitted: _handleSubmitted,
              initialText: state.initialTiming,
              errorText: state.isTimingValid ? null : Strings.errorFieldEmpty,
              prefixIcon: Icon(Icons.watch),
              onChanged: (String value) {
                editProfileBloc
                    .add(HandleTextField(fieldName: TIMING, value: value));
              },
            ),
            CustomTextField(
              labelText: Strings.locationLabel,
              helpText: Strings.locationHint,
              maxLines: SpacingsAndHeights.locationMaxLines,
              textInputAction: TextInputAction.newline,
              prefixIcon: Icon(Icons.location_on),
              initialText: state.initiallocation,
              errorText: state.isLocationValid ? null : Strings.errorFieldEmpty,
              onChanged: (String value) {
                editProfileBloc
                    .add(HandleTextField(fieldName: LOCATION, value: value));
              },
            ),
            CustomTextField(
              labelText: Strings.qualificationsLabel,
              helpText: Strings.freqHintLabel,
              textInputAction: TextInputAction.newline,
              onFieldSubmitted: _handleSubmitted,
              errorText:
                  state.isQualificationValid ? null : Strings.errorFieldEmpty,
              initialText: state.initialQualification,
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                child: FaIcon(FontAwesomeIcons.certificate),
              ),
              onChanged: (String value) {
                editProfileBloc.add(
                    HandleTextField(fieldName: QUALIFICATIONS, value: value));
              },
            ),
            CustomTextField(
              labelText: Strings.sellingPointsLabel,
              helpText: Strings.additionalRemarksHint,
              maxLines: SpacingsAndHeights.addRemarksMaxLines,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _focusScopeNode.unfocus(),
              prefixIcon: Icon(Icons.speaker_notes),
              errorText:
                  state.isSellingPointValid ? null : Strings.errorFieldEmpty,
              initialText: state.initialSellingPoint,
              onChanged: (String value) {
                editProfileBloc.add(
                    HandleTextField(fieldName: SELLING_POINTS, value: value));
              },
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
        setState(() {});
      },
      secondary: const Icon(FontAwesomeIcons.universalAccess),
    );
  }

  void _formSubmit() {
    // editProfileBloc.add(CheckDropDownNotEmpty(fieldName: TUTOR_OCCUPATION));
    editProfileBloc.add(SubmitForm());
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }
}
