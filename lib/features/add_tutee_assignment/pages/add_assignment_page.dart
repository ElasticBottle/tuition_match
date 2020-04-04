import 'package:cotor/common_widgets/custom_radio_button.dart';
import 'package:cotor/common_widgets/custom_check_box_group.dart';
import 'package:cotor/common_widgets/custom_sliver_app_bar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/add_tutee_assignment/bloc/add_tutee_assignment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAssignmentPage extends StatefulWidget {
  @override
  _AddAssignmentPageState createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  FocusScopeNode _focusScopeNode = FocusScopeNode();

  final _controller1 = TextEditingController();

  final _controller2 = TextEditingController();

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
    return CustomScrollView(
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
                child: Column(
                  children: <Widget>[
                    _getRadioSelectors(),
                  ],
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
        // FocusScope(
        //   node: _focusScopeNode,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: TextFormField(
        //           textInputAction: TextInputAction.next,
        //           onFieldSubmitted: _handleSubmitted,
        //           controller: _controller1,
        //           decoration: InputDecoration(border: OutlineInputBorder()),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: TextFormField(
        //           textInputAction: TextInputAction.next,
        //           onFieldSubmitted: _handleSubmitted,
        //           controller: _controller2,
        //           decoration: InputDecoration(border: OutlineInputBorder()),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
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

  @override
  void dispose() {
    _focusScopeNode.dispose();
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
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
      ),
    );
  }
}
