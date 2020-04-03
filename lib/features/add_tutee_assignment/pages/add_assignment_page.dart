import 'package:cotor/common_widgets/custom_radio_button.dart';
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
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CustomSliverAppbar(
          title: Strings.addAssignment,
          isTitleCenter: true,
          showActions: false,
        ),
        BuildLevelSelector(
          levels: BlocProvider.of<AddTuteeAssignmentBloc>(context)
              .initialState
              .props[0],
          levelValues: BlocProvider.of<AddTuteeAssignmentBloc>(context)
              .initialState
              .props[1],
        ),
        BlocBuilder<AddTuteeAssignmentBloc, AddTuteeAssignmentState>(
          bloc: BlocProvider.of<AddTuteeAssignmentBloc>(context),
          builder: (context, state) {
            if (state is SubjectLoaded) {
              return BuildLevelSelector(
                levels: state.subjects,
              );
            }
            return SliverToBoxAdapter(
              child: Container(),
            );
          },
        ),
        FocusScope(
          node: _focusScopeNode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: _handleSubmitted,
                  controller: _controller1,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: _handleSubmitted,
                  controller: _controller2,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
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

class BuildLevelSelector extends StatelessWidget {
  const BuildLevelSelector({this.levels, this.levelValues});
  final List<String> levels;
  final List<Level> levelValues;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Strings.level,
            style: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
            ),
          ),
          CustomRadioButton(
            elevation: 0.0,
            buttonColor: Theme.of(context).canvasColor,
            buttonLables: levels,
            buttonValues: levelValues,
            radioButtonValue: (dynamic value) {
              BlocProvider.of<AddTuteeAssignmentBloc>(context)
                  .add(LevelChanged(level: value));
            },
            vertical: false,
            width: 80,
            height: 40,
            fontSize: ColorsAndFonts.addAssignmentSelectionFontSize,
            selectedColor: Theme.of(context).accentColor,
            enableShape: true,
            defaultSelected: 0,
          ),
          BlocBuilder<AddTuteeAssignmentBloc, AddTuteeAssignmentState>(
            builder: (context, state) {
              return CustomRadioButton(
                elevation: 0.0,
                vertical: false,
                buttonColor: Theme.of(context).canvasColor,
                width: 100,
                height: 40,
                fontSize: ColorsAndFonts.addAssignmentSelectionFontSize,
                buttonLables: const [
                  'Student',
                  'Parent',
                  'Teacher',
                ],
                buttonValues: const <String>[
                  "STUDENT",
                  "PARENT",
                  "TEACHER",
                ],
                radioButtonValue: (dynamic value) {
                  print(value);
                },
                selectedColor: Theme.of(context).accentColor,
              );
            },
          )
        ],
      ),
    );
  }
}
