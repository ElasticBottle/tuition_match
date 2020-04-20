import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/buttons/toggle_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/class_format.dart';
import 'package:cotor/domain/entities/gender.dart';
import 'package:cotor/domain/entities/level.dart';
import 'package:cotor/domain/entities/rate_types.dart';
import 'package:cotor/domain/entities/tutor_occupation.dart';
import 'package:cotor/features/add_tutee_assignment/bloc/edit_tutee_assignment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiple_select/Item.dart';
import 'package:multiple_select/multi_filter_select.dart';
import 'package:multiple_select/multiple_select.dart';

class EditAssignmentPage extends StatefulWidget {
  @override
  EditAssignmentPageState createState() => EditAssignmentPageState();
}

class EditAssignmentPageState extends State<EditAssignmentPage> {
  List<String> selectedItems = <String>[];
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  EditTuteeAssignmentBloc editProfileBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool _isButtonPressable(EditTuteeAssignmentState state) {
    return state.isValid();
  }

  @override
  void initState() {
    editProfileBloc = BlocProvider.of<EditTuteeAssignmentBloc>(context);
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
      child: Material(
        child: CustomScrollView(
          slivers: <Widget>[
            CustomSliverAppbar(
              title: Strings.editAssignment,
              isTitleCenter: true,
              showActions: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsAndFonts.primaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            BlocListener<EditTuteeAssignmentBloc, EditTuteeAssignmentState>(
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
                }
              },
              child: BlocBuilder<EditTuteeAssignmentBloc,
                  EditTuteeAssignmentState>(
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
                              child: Text(
                                Strings.addAssignment,
                                style: TextStyle(
                                  color: ColorsAndFonts.backgroundColor,
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

  Widget _getRadioSelectors(EditTuteeAssignmentState state) {
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
            editProfileBloc
                .add(HandleToggleButtonClick(fieldName: GENDER, index: index));
            editProfileBloc.add(
              CheckDropDownNotEmpty(fieldName: GENDER),
            );
            editProfileBloc
                .add(SaveField(key: GENDER, value: Gender.genders[index]));
            setState(() {});
          },
          initialLabelIndex: state.genderSelection,
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
          initValue: selectedItems,
          selectCallback: (List selectedValue) {
            print(selectedValue);
          },
        ),
        // SearchableDropdown<dynamic>.multiple(
        //   items: Level.all
        //       .map<DropdownMenuItem<String>>(
        //         (String e) => DropdownMenuItem<String>(
        //           value: e,
        //           child: Text(e),
        //         ),
        //       )
        //       .toList(),
        //   selectedItems: state.levels,
        //   hint: Padding(
        //     padding: const EdgeInsets.all(12.0),
        //     child: Text('Select any'),
        //   ),
        //   searchHint: 'Select any',
        //   validator: (dynamic value) {
        //     return state.isSelectedLevelsValid
        //         ? null
        //         : 'Please select an option';
        //   },
        //   onChanged: (List<dynamic> value) {
        //     print(value);
        //     editProfileBloc.add(HandleToggleButtonClick(
        //         fieldName: LEVELS_TAUGHT, index: value));
        //     editProfileBloc.add(
        //       CheckDropDownNotEmpty(fieldName: LEVELS_TAUGHT),
        //     );
        //     editProfileBloc.add(SaveField(key: LEVELS_TAUGHT, value: value));
        //     setState(() {});
        //   },
        //   displayItem: (dynamic item, dynamic selected) {
        //     return Row(children: [
        //       selected
        //           ? Icon(
        //               Icons.check,
        //               color: Colors.green,
        //             )
        //           : Icon(
        //               Icons.check_box_outline_blank,
        //               color: Colors.grey,
        //             ),
        //       SizedBox(width: 7),
        //       Expanded(
        //         child: item,
        //       ),
        //     ]);
        //   },
        //   selectedValueWidgetFn: (dynamic item) {
        //     return Card(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           side: BorderSide(
        //             color: Colors.brown,
        //             width: 0.5,
        //           ),
        //         ),
        //         margin: EdgeInsets.all(12),
        //         child: Padding(
        //           padding: const EdgeInsets.all(8),
        //           child: Text(item.toString()),
        //         ));
        //   },
        //   doneButton: (dynamic selectedItemsDone, dynamic doneContext) {
        //     return RaisedButton(
        //         onPressed: () {
        //           Navigator.pop(doneContext);
        //           setState(() {});
        //         },
        //         child: Text('Save'));
        //   },
        //   closeButton: null,
        //   style: TextStyle(fontStyle: FontStyle.italic),
        //   searchFn: (String keyword, dynamic items) {
        //     List<int> ret = [];
        //     if (keyword != null && items != null && keyword.isNotEmpty) {
        //       keyword.split(' ').forEach((k) {
        //         int i = 0;
        //         items.forEach((dynamic item) {
        //           if (k.isNotEmpty &&
        //               (item.value[1]
        //                   .toString()
        //                   .toLowerCase()
        //                   .contains(k.toLowerCase()))) {
        //             ret.add(i);
        //           }
        //           i++;
        //         });
        //       });
        //     }
        //     if (keyword.isEmpty) {
        //       ret = Iterable<int>.generate(items.length).toList();
        //     }
        //     return ret;
        //   },
        //   clearIcon: Icon(Icons.clear_all),
        //   icon: Icon(Icons.arrow_drop_down_circle),
        //   label: 'Levels Taught',
        //   underline: Container(
        //     height: 1.0,
        //     decoration: BoxDecoration(
        //         border:
        //             Border(bottom: BorderSide(color: Colors.teal, width: 3.0))),
        //   ),
        //   iconDisabledColor: Colors.brown,
        //   iconEnabledColor: Colors.indigo,
        //   isExpanded: true,
        // ),
        // TODO(ElasticBottle): fix subject dropdown list
        // SearchableDropdown<dynamic>.multiple(
        //   items: state.subjectsToDisplay
        //       .map(
        //         (e) => DropdownMenuItem<String>(
        //           value: e,
        //           child: Text(e),
        //         ),
        //       )
        //       .toList(),
        //   selectedItems: state.subjects,
        //   hint: Padding(
        //     padding: const EdgeInsets.all(12.0),
        //     child: Text('Select any'),
        //   ),
        //   searchHint: 'Select any',
        //   validator: (dynamic value) {
        //     return state.isSelectedSubjectsValid
        //         ? null
        //         : 'Please select an option';
        //   },
        //   onChanged: (List<String> value) {
        //     print(value);
        //     editProfileBloc.add(
        //         HandleToggleButtonClick(fieldName: SUBJECTS, index: value));
        //     editProfileBloc.add(
        //       CheckDropDownNotEmpty(fieldName: SUBJECTS),
        //     );
        //     editProfileBloc.add(SaveField(key: SUBJECTS, value: value));
        //     setState(() {});
        //   },
        //   displayItem: (dynamic item, dynamic selected) {
        //     return Row(children: [
        //       selected
        //           ? Icon(
        //               Icons.check,
        //               color: Colors.green,
        //             )
        //           : Icon(
        //               Icons.check_box_outline_blank,
        //               color: Colors.grey,
        //             ),
        //       SizedBox(width: 7),
        //       Expanded(
        //         child: item,
        //       ),
        //     ]);
        //   },
        //   selectedValueWidgetFn: (dynamic item) {
        //     return Card(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           side: BorderSide(
        //             color: Colors.brown,
        //             width: 0.5,
        //           ),
        //         ),
        //         margin: EdgeInsets.all(12),
        //         child: Padding(
        //           padding: const EdgeInsets.all(8),
        //           child: Text(item.toString()),
        //         ));
        //   },
        //   doneButton: (dynamic selectedItemsDone, dynamic doneContext) {
        //     return RaisedButton(
        //         onPressed: () {
        //           Navigator.pop(doneContext);
        //           setState(() {});
        //         },
        //         child: Text('Save'));
        //   },
        //   closeButton: null,
        //   style: TextStyle(fontStyle: FontStyle.italic),
        //   searchFn: (String keyword, dynamic items) {
        //     List<int> ret = [];
        //     if (keyword != null && items != null && keyword.isNotEmpty) {
        //       keyword.split(' ').forEach((k) {
        //         int i = 0;
        //         items.forEach((dynamic item) {
        //           if (k.isNotEmpty &&
        //               (item.value[1]
        //                   .toString()
        //                   .toLowerCase()
        //                   .contains(k.toLowerCase()))) {
        //             ret.add(i);
        //           }
        //           i++;
        //         });
        //       });
        //     }
        //     if (keyword.isEmpty) {
        //       ret = Iterable<int>.generate(items.length).toList();
        //     }
        //     return ret;
        //   },
        //   clearIcon: Icon(Icons.clear_all),
        //   icon: Icon(Icons.arrow_drop_down_circle),
        //   label: 'Subjects Taught',
        //   underline: Container(
        //     height: 1.0,
        //     decoration: BoxDecoration(
        //         border:
        //             Border(bottom: BorderSide(color: Colors.teal, width: 3.0))),
        //   ),
        //   iconDisabledColor: Colors.brown,
        //   iconEnabledColor: Colors.indigo,
        //   isExpanded: true,
        // ),
        // SearchableDropdown<dynamic>.multiple(
        //   items: TutorOccupation.occupations
        //       .map<DropdownMenuItem<int>>(
        //           (String e) => DropdownMenuItem<int>(value: 1, child: Text(e)))
        //       .toList(),
        //   selectedItems: state.tutorOccupation,
        //   hint: 'Select one',
        //   searchHint: 'Select one',
        //   validator: (dynamic value) {
        //     return state.isTutorOccupationsValid
        //         ? null
        //         : 'Please select an option';
        //   },
        //   onChanged: (dynamic value) {
        //     print(value.toString());
        //     editProfileBloc.add(HandleToggleButtonClick(
        //         fieldName: TUTOR_OCCUPATION, index: value));
        //     editProfileBloc.add(
        //       CheckDropDownNotEmpty(fieldName: TUTOR_OCCUPATION),
        //     );
        //     editProfileBloc.add(SaveField(key: TUTOR_OCCUPATION, value: value));
        //   },
        //   doneButton: Text(''),
        //   closeButton: 'save',
        //   displayClearIcon: false,
        //   label: Text(
        //     'Occupation',
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   displayItem: (dynamic item, dynamic selected) {
        //     return Row(children: [
        //       selected
        //           ? Icon(
        //               Icons.radio_button_checked,
        //               color: Colors.grey,
        //             )
        //           : Icon(
        //               Icons.radio_button_unchecked,
        //               color: Colors.grey,
        //             ),
        //       SizedBox(width: 7),
        //       Expanded(
        //         child: item,
        //       ),
        //     ]);
        //   },
        //   isExpanded: true,
        // ),
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

  Widget _getTextFormFields(EditTuteeAssignmentState state) {
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
              onChanged: (String value) => editProfileBloc.add(
                  CheckTextFieldNotEmpty(
                      fieldName: QUALIFICATIONS, toCheck: value)),
              onSaved: (String field) => editProfileBloc.add(SaveField(
                value: field,
                key: QUALIFICATIONS,
              )),
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

  Widget _getOpenToApplicationSwitch(EditTuteeAssignmentState state) {
    return SwitchListTile(
      title: const Text('Accepting Students?'),
      value: state.isAcceptingTutors,
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

  @override
  void deactivate() {
    super.deactivate();
  }
}
