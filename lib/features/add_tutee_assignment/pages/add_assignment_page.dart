import 'package:cotor/common_widgets/custom_radio_button.dart';
import 'package:cotor/common_widgets/custom_check_box_group.dart';
import 'package:cotor/common_widgets/custom_raised_button.dart';
import 'package:cotor/common_widgets/custom_sliver_app_bar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/add_tutee_assignment/bloc/add_tutee_assignment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAssignmentPage extends StatefulWidget {
  @override
  _AddAssignmentPageState createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  @override
  void initState() {
    BlocProvider.of<AddTuteeAssignmentBloc>(context).add(SpecificLevelChanged(
        specificLevel: BlocProvider.of<AddTuteeAssignmentBloc>(context)
            .currentSpecificLevel,
        specificLevelIndex: BlocProvider.of<AddTuteeAssignmentBloc>(context)
            .currentSpecificLevelIndex));
    BlocProvider.of<AddTuteeAssignmentBloc>(context).add(SubjectClicked(
        value: BlocProvider.of<AddTuteeAssignmentBloc>(context).currentSubject,
        index: BlocProvider.of<AddTuteeAssignmentBloc>(context)
            .currentSubjectIndex));
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
      child: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppbar(
            title: Strings.addAssignment,
            isTitleCenter: true,
            showActions: false,
          ),
          BlocBuilder<AddTuteeAssignmentBloc, AddTuteeAssignmentState>(
            builder: (context, state) {
              print(state);
              if (state is Loaded || state is AddTuteeAssignmentInitial) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            SpacingsAndHeights.addAssignmentPageSidePadding),
                    child: Column(
                      children: <Widget>[
                        _getRadioSelectors(),
                        SizedBox(
                            height: SpacingsAndHeights
                                .addAssignmentPageFieldSpacing),
                        _getTextFormFields(),
                      ],
                    ),
                  ),
                );
              } else if (state is SubmissionLoading) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            SpacingsAndHeights.addAssignmentPageSidePadding),
                    child: Column(
                      children: <Widget>[
                        _getRadioSelectors(),
                        SizedBox(
                            height: SpacingsAndHeights
                                .addAssignmentPageFieldSpacing),
                        _getTextFormFields(isLoading: true),
                      ],
                    ),
                  ),
                );
              }
              return SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getRadioSelectors() {
    return Column(
      children: <Widget>[
        CustomSelector(
          title: 'Level',
          defaultSelected: BlocProvider.of<AddTuteeAssignmentBloc>(context)
              .currentLevelIndex,
          labels:
              BlocProvider.of<AddTuteeAssignmentBloc>(context).initialLevels,
          values: BlocProvider.of<AddTuteeAssignmentBloc>(context)
              .initialLevelsValue,
          onPressed: (dynamic value, int index) {
            BlocProvider.of<AddTuteeAssignmentBloc>(context).add(
              LevelChanged(
                level: value,
                currentIndex: index,
              ),
            );
          },
        ),
        CustomSelector(
          title: '',
          defaultSelected: BlocProvider.of<AddTuteeAssignmentBloc>(context)
              .currentSpecificLevelIndex,
          labels:
              BlocProvider.of<AddTuteeAssignmentBloc>(context).specificLevels,
          values: BlocProvider.of<AddTuteeAssignmentBloc>(context)
              .specificLevelsValue,
          onPressed: (dynamic value, int index) {
            BlocProvider.of<AddTuteeAssignmentBloc>(context).add(
              SpecificLevelChanged(
                specificLevel: value,
                specificLevelIndex: index,
              ),
            );
          },
        ),
        CustomSelector(
          title: 'Subject',
          defaultSelected: BlocProvider.of<AddTuteeAssignmentBloc>(context)
              .currentSubjectIndex,
          labels: BlocProvider.of<AddTuteeAssignmentBloc>(context).subjects,
          values: BlocProvider.of<AddTuteeAssignmentBloc>(context).subjects,
          onPressed: (dynamic value, int index) {
            BlocProvider.of<AddTuteeAssignmentBloc>(context).add(
              SubjectClicked(
                value: value,
                index: index,
              ),
            );
          },
        ),
        CustomSelector(
          title: 'Gender',
          labels: Gender.values.map((e) => describeEnum(e)).toList(),
          values: Gender.values,
          checkBoxOnPressed: (List<dynamic> value) {
            BlocProvider.of<AddTuteeAssignmentBloc>(context).add(
              EventClicked(
                value: value,
              ),
            );
          },
          isRadio: false,
        ),
        CustomSelector(
          title: 'Tutor Occupation',
          labels: TutorOccupation.values.map((e) => describeEnum(e)).toList(),
          values: TutorOccupation.values,
          checkBoxOnPressed: (List<dynamic> value) {
            BlocProvider.of<AddTuteeAssignmentBloc>(context).add(
              EventClicked(
                value: value,
              ),
            );
          },
          isRadio: false,
        ),
        CustomSelector(
          title: 'Class Format',
          labels: ClassFormat.values.map((e) => describeEnum(e)).toList(),
          values: ClassFormat.values,
          checkBoxOnPressed: (List<dynamic> value) {
            BlocProvider.of<AddTuteeAssignmentBloc>(context).add(
              EventClicked(
                value: value,
              ),
            );
          },
          isRadio: false,
        ),
      ],
    );
  }

  Widget _getTextFormFields({bool isLoading = false}) {
    return FocusScope(
      node: _focusScopeNode,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextField(
              labelText: Strings.location,
              helpText: Strings.locationHelperText,
              maxLines: SpacingsAndHeights.locationMaxLines,
              textInputAction: TextInputAction.newline,
              prefixIcon: Icon(Icons.location_on),
              onSaved: (String field) =>
                  BlocProvider.of<AddTuteeAssignmentBloc>(context)
                      .add(FormSaved(
                value: field,
                key: LOCATION,
              )),
            ),
            SizedBox(height: SpacingsAndHeights.addAssignmentPageFieldSpacing),
            CustomTextField(
              labelText: Strings.timing,
              helpText: Strings.timingHelperText,
              maxLines: SpacingsAndHeights.timingMaxLines,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: _handleSubmitted,
              prefixIcon: Icon(Icons.watch),
              onSaved: (String field) =>
                  BlocProvider.of<AddTuteeAssignmentBloc>(context)
                      .add(FormSaved(
                value: field,
                key: TIMING,
              )),
            ),
            SizedBox(height: SpacingsAndHeights.addAssignmentPageFieldSpacing),
            CustomTextField(
              labelText: Strings.freq,
              helpText: Strings.freqHelperText,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: _handleSubmitted,
              prefixIcon: Icon(Icons.av_timer),
              onSaved: (String field) =>
                  BlocProvider.of<AddTuteeAssignmentBloc>(context)
                      .add(FormSaved(
                value: field,
                key: FREQ,
              )),
            ),
            SizedBox(height: SpacingsAndHeights.addAssignmentPageFieldSpacing),
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: _handleSubmitted,
                    prefixIcon: Icon(Icons.attach_money),
                    onSaved: (String field) =>
                        BlocProvider.of<AddTuteeAssignmentBloc>(context)
                            .add(FormSaved(
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: _handleSubmitted,
                    prefixIcon: Icon(Icons.attach_money),
                    onSaved: (String field) =>
                        BlocProvider.of<AddTuteeAssignmentBloc>(context)
                            .add(FormSaved(
                      value: field,
                      key: RATEMAX,
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(height: SpacingsAndHeights.addAssignmentPageFieldSpacing),
            CustomTextField(
              labelText: Strings.additionalRemarks,
              helpText: Strings.additionalRemarksHelperText,
              maxLines: SpacingsAndHeights.addRemarksMaxLines,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => _formSubmit(),
              prefixIcon: Icon(Icons.speaker_notes),
              onSaved: (String field) =>
                  BlocProvider.of<AddTuteeAssignmentBloc>(context)
                      .add(FormSaved(
                value: field,
                key: ADDITIONAL_REMARKS,
              )),
            ),
            SizedBox(height: SpacingsAndHeights.addAssignmentPageFieldSpacing),
            Container(
              width: MediaQuery.of(context).size.width,
              child: CustomRaisedButton(
                onPressed: _formSubmit,
                loading: isLoading,
                color: ColorsAndFonts.primaryColor,
                child: Text(
                  Strings.addAssignment,
                  style: TextStyle(
                    color: ColorsAndFonts.backgroundColor,
                    fontFamily: ColorsAndFonts.primaryFont,
                    fontWeight: FontWeight.normal,
                    fontSize: ColorsAndFonts.AddAssignmntSubmitButtonFontSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: SpacingsAndHeights.addAssignmentPageFieldSpacing),
          ],
        ),
      ),
    );
  }

  void _formSubmit() {
    final FormState state = _formKey.currentState;
    state.save();
    BlocProvider.of<AddTuteeAssignmentBloc>(context).add(FormSubmit());
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.initialText = '',
    this.helpText,
    this.labelText,
    this.errorText,
    this.helperFontSize = 12.0,
    this.labelFontSize = 18.0,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.maxLines = 1,
  });
  final Function(String) onFieldSubmitted;
  final Function(String) onSaved;
  final Function(String) validator;
  final String initialText;
  final String helpText;
  final String labelText;
  final String errorText;
  final double labelFontSize;
  final double helperFontSize;
  final TextInputAction textInputAction;
  final Icon prefixIcon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (_) {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: TextFormField(
        initialValue: initialText,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          labelStyle: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontFamily: ColorsAndFonts.primaryFont,
            fontSize: labelFontSize,
          ),
          helperText: helpText,
          helperStyle: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontFamily: ColorsAndFonts.primaryFont,
            fontWeight: FontWeight.normal,
            fontSize: helperFontSize,
          ),
          errorText: errorText,
          prefixIcon: prefixIcon,
          fillColor: Colors.grey[200],
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsAndFonts.primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        maxLines: maxLines,
      ),
    );
  }
}

class CustomSelector extends StatelessWidget {
  const CustomSelector(
      {this.title,
      this.defaultSelected,
      this.labels,
      this.values,
      this.onPressed,
      this.fontSize = 12.0,
      this.isRadio = true,
      this.checkBoxOnPressed});
  final String title;
  final int defaultSelected;
  final List<String> labels;
  final List<dynamic> values;
  final Function(dynamic, int) onPressed;
  final Function(List<dynamic>) checkBoxOnPressed;
  final double fontSize;
  final bool isRadio;

  // final List<Level> levelValues;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontFamily: ColorsAndFonts.primaryFont,
            fontSize: fontSize,
          ),
        ),
        isRadio
            ? CustomRadioButton(
                elevation: 0.0,
                vertical: false,
                buttonColor: Theme.of(context).canvasColor,
                width: 95,
                height: 50,
                fontSize: ColorsAndFonts.addAssignmentSelectionFontSize,
                defaultSelected: defaultSelected,
                buttonLables: labels,
                buttonValues: values,
                radioButtonValue: onPressed,
                selectedColor: Theme.of(context).accentColor,
              )
            : CustomCheckBoxGroup(
                elevation: 0.0,
                vertical: false,
                buttonColor: Theme.of(context).canvasColor,
                width: 95,
                height: 50,
                fontSize: ColorsAndFonts.addAssignmentSelectionFontSize,
                defaultSelected: defaultSelected,
                buttonLables: labels,
                buttonValuesList: values,
                checkBoxButtonValues: checkBoxOnPressed,
                selectedColor: Theme.of(context).accentColor,
              ),
      ],
    );
  }
}
