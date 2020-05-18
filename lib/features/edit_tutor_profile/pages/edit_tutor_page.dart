import 'dart:math' as math;

import 'package:cotor/common_widgets/bars/custom_app_bar.dart';
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/buttons/toggle_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/common_widgets/information_capture/multi_filter_select/multi_filter_select_export.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/common_widgets/platform_alert_dialog.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/form_field_keys.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/edit_tutor_profile/bloc/edit_tutor_profile_bloc.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              CustomAppBar(
                title: Strings.editTutorProfile,
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
                          toDisplay: Text(
                            state.failureMessage,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
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
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
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
                              child: Text(
                                Strings.addAssignmentButtonText,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(fontWeight: FontWeight.bold)
                                    .apply(fontSizeFactor: 1.2),
                              ),
                            ),
                          ),
                          SizedBox(height: 20)
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
        SizedBox(height: 30),
        ToggleButton(
          title: Strings.genderLabel,
          errorText: state.isGenderValid ? null : 'Please state your gender',
          allItems: state.genderLabels,
          icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
          onPressed: (int index) {
            editProfileBloc.add(
              HandleToggleButtonClick(
                  fieldName: FormFieldKey.GENDER, index: index),
            );
          },
          initialLabelIndex: [state.genderSelection],
        ),
        SizedBox(height: 30),
        ToggleButton(
          title: Strings.classFormatLabel,
          allItems: state.classFormatLabels,
          errorText: state.isClassFormatsValid ? null : Strings.errorFieldEmpty,
          onPressed: (int index) {
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: FormFieldKey.CLASS_FORMATS, index: index));
            setState(() {});
          },
          initialLabelIndex: state.classFormatSelection,
        ),
        SizedBox(height: 30),
        MultiFilterSelect(
          labelText: Strings.levelLabel,
          errorText: state.isSelectedLevelsTaughtValid
              ? null
              : Strings.errorFieldEmpty,
          hintText: Strings.levelHint,
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
            setState(() {});
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: FormFieldKey.LEVELS_TAUGHT, index: selectedValue));
          },
        ),
        SizedBox(height: 30.0),
        MultiFilterSelect(
          labelText: Strings.subjectsTaughtLabel,
          hintText: state.subjectHint,
          errorText:
              state.isSelectedSubjectsValid ? null : Strings.errorFieldEmpty,
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
                fieldName: FormFieldKey.SUBJECTS_TAUGHT, index: selectedValue));
          },
        ),
        SizedBox(height: 30.0),
        MultiFilterSelect(
          isSingleSelect: true,
          labelText: Strings.tutorOccupationLabel,
          hintText: Strings.tutorOccupationHint,
          errorText:
              state.isTutorOccupationValid ? null : Strings.errorFieldEmpty,
          allItems: state.tutorOccupationLabels
              .map<Item<String, String, String>>(
                (e) => Item<String, String, String>.build(
                  value: e,
                  display: e,
                  content: e,
                ),
              )
              .toList(),
          initValue: state.tutorOccupation.isNotEmpty
              ? <String>[state.tutorOccupation]
              : null,
          selectCallback: (List selectedValue) {
            // print(selectedValue.toString());
            // selectedValue.removeWhere((dynamic element) => element == null);
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: FormFieldKey.TUTOR_OCCUPATION,
                index: selectedValue));
            setState(() {});
          },
        ),
        SizedBox(height: 30.0),
        ToggleButton(
          title: 'Rate Type',
          errorText: state.isTypeRateValid ? null : Strings.errorFieldEmpty,
          allItems: state.rateTypeLabels,
          onPressed: (int index) {
            editProfileBloc.add(HandleToggleButtonClick(
                fieldName: FormFieldKey.RATE_TYPE, index: index));
          },
          initialLabelIndex: [state.rateTypeSelction],
        ),
        SizedBox(height: 30.0),
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
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
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
                    errorText: state.isRateMinValid
                        ? null
                        : Strings.errorNumberInvalid,
                    prefixIcon: Icon(Icons.attach_money),
                    onChanged: (String value) {
                      editProfileBloc.add(HandleRates(
                          fieldName: FormFieldKey.MIN_RATE, value: value));
                    },
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  flex: 10,
                  child: CustomTextField(
                    labelText: Strings.rateMaxLabel,
                    initialText: state.initialRateMax,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: _handleSubmitted,
                    errorText: state.isRateMaxValid
                        ? null
                        : Strings.errorNumberInvalid,
                    prefixIcon: Icon(Icons.attach_money),
                    onChanged: (String value) {
                      editProfileBloc.add(HandleRates(
                          fieldName: FormFieldKey.MAX_RATE, value: value));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            CustomTextField(
              labelText: Strings.timingLabel,
              helpText: Strings.timingHint,
              maxLines: SpacingsAndHeights.timingMaxLines,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              // onFieldSubmitted: _handleSubmitted,
              initialText: state.initialTiming,
              errorText: state.isTimingValid ? null : Strings.errorFieldEmpty,
              prefixIcon: Icon(Icons.watch),
              onChanged: (String value) {
                editProfileBloc.add(HandleTextField(
                    fieldName: FormFieldKey.TIMING, value: value));
              },
            ),
            SizedBox(height: 30),
            CustomTextField(
              labelText: Strings.locationLabel,
              helpText: Strings.locationHint,
              maxLines: SpacingsAndHeights.locationMaxLines,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              prefixIcon: Icon(Icons.location_on),
              initialText: state.initiallocation,
              errorText: state.isLocationValid ? null : Strings.errorFieldEmpty,
              onChanged: (String value) {
                editProfileBloc.add(HandleTextField(
                    fieldName: FormFieldKey.LOCATION, value: value));
              },
            ),
            SizedBox(height: 30),
            CustomTextField(
              labelText: Strings.qualificationsLabel,
              helpText: Strings.freqHintLabel,
              textInputType: TextInputType.multiline,
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
                editProfileBloc.add(HandleTextField(
                    fieldName: FormFieldKey.QUALIFICATIONS, value: value));
              },
            ),
            SizedBox(height: 30),
            CustomTextField(
              labelText: Strings.sellingPointsLabel,
              helpText: Strings.additionalRemarksHint,
              textInputType: TextInputType.multiline,
              maxLines: SpacingsAndHeights.addRemarksMaxLines,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _focusScopeNode.unfocus(),
              prefixIcon: Icon(Icons.speaker_notes),
              errorText:
                  state.isSellingPointValid ? null : Strings.errorFieldEmpty,
              initialText: state.initialSellingPoint,
              onChanged: (String value) {
                editProfileBloc.add(HandleTextField(
                    fieldName: FormFieldKey.SELLING_POINTS, value: value));
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
        editProfileBloc.add(HandleToggleButtonClick(
            fieldName: FormFieldKey.IS_OPEN, index: value));
        setState(() {});
      },
      secondary: const Icon(FontAwesomeIcons.universalAccess),
    );
  }

  void _formSubmit() {
    editProfileBloc.add(SubmitForm());
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }
}
