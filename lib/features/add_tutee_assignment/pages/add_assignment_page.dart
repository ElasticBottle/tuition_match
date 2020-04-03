import 'package:cotor/common_widgets/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/drop_down_field.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/add_tutee_assignment/bloc/add_tutee_assignment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAssignmentPage extends StatelessWidget {
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
        )
      ],
    );
  }
}

class BuildLevelSelector extends StatelessWidget {
  const BuildLevelSelector({this.levels});
  final List<String> levels;
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
          DropDownField(
            value: '',
            icon: Icon(Icons.subject),
            required: true,
            hintText: Strings.levelDropDownHint,
            labelText: Strings.levelDropDownLabel,
            items: levels,
            itemsVisibleInDropdown:
                SpacingsAndHeights.levelDropDownVisibleItems,
            textStyle: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
            ),
            labelStyle: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
            ),
            setter: (dynamic newValue) {
              print(newValue);
            },
            onValueChanged: (dynamic value) =>
                BlocProvider.of<AddTuteeAssignmentBloc>(context)
                    .add(LevelChanged(level: value.toString())),
          ),
        ],
      ),
    );
  }
}
