import 'dart:math' as math;

import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/buttons/toggle_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/common_widgets/information_display/info_line.dart';
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
import 'package:cotor/features/request_tutor/request_tutor_form/bloc/request_tutor_form_bloc.dart';
import 'package:cotor/features/request_tutor/request_tutor_form/helper.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiple_select/Item.dart';
import 'package:multiple_select/multi_filter_select.dart';

class RequestTutorForm extends StatefulWidget {
  @override
  RequestTutorFormWidgetState createState() => RequestTutorFormWidgetState();
}

class RequestTutorFormWidgetState extends State<RequestTutorForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  RequestTutorFormBloc requestTutorFormBloc;
  UserProfileBloc userProfileBloc;

  @override
  void initState() {
    requestTutorFormBloc = BlocProvider.of<RequestTutorFormBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool _isButtonPressable(RequestTutorFormState state) {
    return state.isValid();
  }

  void _formSubmit() {
    // requestTutorFormBloc.add(CheckDropDownNotEmpty(fieldName: TUTOR_OCCUPATION));
    requestTutorFormBloc.add(SubmitForm());
  }

  Future<bool> _confirmExit() async {
    final bool isLeaving = await PlatformAlertDialog(
      title: 'Leaving',
      content: 'Are you sure you want to leave? All your chagnes will be lost',
      defaultActionText: 'Exit',
      cancelActionText: 'Cancel',
    ).show(context);
    if (isLeaving != null && isLeaving) {
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
              BlocConsumer<RequestTutorFormBloc, RequestTutorFormState>(
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
                    requestTutorFormBloc.add(ResetForm());
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
                          if (state.isPublic) _getAdditionalFields(state),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _getNonTextFields(RequestTutorFormState state) {
    return Column(
      children: <Widget>[
        ToggleButton(
          title: 'Class Format',
          errorText:
              state.isClassFormatsValid ? null : 'Please select your options',
          fontFamily: ColorsAndFonts.primaryFont,
          activeBgColor: ColorsAndFonts.primaryColor,
          activeTextColor: ColorsAndFonts.backgroundColor,
          inactiveTextColor: ColorsAndFonts.primaryColor,
          labels: state.classFormatsToDisplay,
          onPressed: (int index) {
            requestTutorFormBloc.add(HandleToggleButtonClick(
                fieldName: CLASS_FORMATS, index: index));
            setState(() {});
          },
          initialLabelIndex: state.classFormatSelection,
        ),
        MultiFilterSelect(
          placeholder: 'Levels',
          allItems: state.levelsToDisplay
              .map<Item<String, String, String>>(
                (e) => Item<String, String, String>.build(
                  value: e,
                  display: '$e',
                  content: '$e',
                ),
              )
              .toList(),
          initValue: state.levels,
          selectCallback: (List selectedValue) {
            print(selectedValue.toString());
            setState(() {});
            requestTutorFormBloc.add(HandleToggleButtonClick(
                fieldName: LEVELS, index: selectedValue));
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
          initValue: state.subjects,
          selectCallback: (List selectedValue) {
            print(selectedValue.toString());
            requestTutorFormBloc.add(HandleToggleButtonClick(
                fieldName: SUBJECTS, index: selectedValue));
          },
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
            requestTutorFormBloc.add(
                HandleToggleButtonClick(fieldName: RATE_TYPE, index: index));
          },
          initialLabelIndex: [state.rateTypeSelction],
        ),
      ],
    );
  }

  Widget _getTextFormFields(RequestTutorFormState state) {
    return FocusScope(
      node: _focusScopeNode,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InfoLine(
              leading: Icon(
                Icons.attach_money,
              ),
              title: Text(
                Strings.tutorRate,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              info: Text(
                Helper.formatPrice(
                  rateMin: state.requestingProfile.rateMin,
                  ratemax: state.requestingProfile.rateMax,
                  rateType: state.requestingProfile.rateType,
                ),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              elevation: 0.0,
            ),
            CustomTextField(
              labelText: Strings.proposedRate,
              initialText: state.initialProposedRate,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: _handleSubmitted,
              errorText: state.isProposedRateValid ? null : Strings.rateError,
              prefixIcon: Icon(Icons.attach_money),
              onChanged: (String value) {
                requestTutorFormBloc
                    .add(HandleRates(fieldName: PROPOSED_RATE, value: value));
              },
            ),
            InfoLine(
              leading: Icon(
                Icons.watch,
              ),
              title: Text(
                Strings.tutorTimings,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              info: Text(
                state.requestingProfile.timing,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              elevation: 0.0,
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
              onChanged: (String value) {
                requestTutorFormBloc
                    .add(HandleTextField(fieldName: TIMING, value: value));
              },
            ),
            CustomTextField(
              labelText: Strings.freq,
              helpText: Strings.freqHelperText,
              textInputAction: TextInputAction.newline,
              onFieldSubmitted: _handleSubmitted,
              errorText:
                  state.isFreqValid ? null : Strings.invalidFieldCannotBeEmpty,
              initialText: state.initialFreq,
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                child: FaIcon(FontAwesomeIcons.certificate),
              ),
              onChanged: (String value) {
                requestTutorFormBloc
                    .add(HandleTextField(fieldName: FREQ, value: value));
              },
            ),
            InfoLine(
              leading: Icon(
                Icons.location_on,
              ),
              title: Text(
                Strings.tutorPreferredLocation,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              info: Text(
                state.requestingProfile.location,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              elevation: 0.0,
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
              onChanged: (String value) {
                requestTutorFormBloc
                    .add(HandleTextField(fieldName: LOCATION, value: value));
              },
            ),
            CustomTextField(
              labelText: Strings.additionalRemarks,
              helpText: Strings.additionalRemarksHelperText,
              maxLines: SpacingsAndHeights.addRemarksMaxLines,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _focusScopeNode.unfocus(),
              prefixIcon: Icon(Icons.speaker_notes),
              errorText: state.isAdditionalRemarksValid
                  ? null
                  : Strings.invalidFieldCannotBeEmpty,
              initialText: state.initialAdditionalRemarks,
              onChanged: (String value) {
                requestTutorFormBloc.add(HandleTextField(
                    fieldName: ADDITIONAL_REMARKS, value: value));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getOpenToApplicationSwitch(RequestTutorFormState state) {
    return SwitchListTile(
      title: const Text('Accepting Students?'),
      value: state.isPublic,
      onChanged: (bool value) {
        requestTutorFormBloc
            .add(HandleToggleButtonClick(fieldName: IS_PUBLIC, index: value));
        setState(() {});
      },
      secondary: const Icon(FontAwesomeIcons.universalAccess),
    );
  }

  Widget _getAdditionalFields(RequestTutorFormState state) {
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
            requestTutorFormBloc.add(
              HandleToggleButtonClick(fieldName: TUTOR_GENDER, index: index),
            );
          },
          initialLabelIndex: state.genderSelection,
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
            requestTutorFormBloc.add(HandleToggleButtonClick(
                fieldName: TUTOR_OCCUPATIONS, index: selectedValue[0]));
          },
          initValue: state.tutorOccupation,
        ),
        Text(
          Strings.rate,
          style: Theme.of(context).textTheme.headline6,
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
                onChanged: (String value) {
                  requestTutorFormBloc
                      .add(HandleRates(fieldName: RATEMIN, value: value));
                },
              ),
            ),
            SizedBox(width: SpacingsAndHeights.addAssignmentPageFieldSpacing),
            Expanded(
              flex: 10,
              child: CustomTextField(
                labelText: Strings.rateMax,
                initialText: state.initialRateMax,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: _handleSubmitted,
                errorText: state.isRateMaxValid ? null : Strings.rateError,
                prefixIcon: Icon(Icons.attach_money),
                onChanged: (String value) {
                  requestTutorFormBloc
                      .add(HandleRates(fieldName: RATEMAX, value: value));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
