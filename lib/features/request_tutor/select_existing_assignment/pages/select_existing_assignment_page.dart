import 'package:cotor/common_widgets/bars/bottom_action_bar_new.dart';
import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/paginated_sliver_list.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/request_tutor/select_existing_assignment/bloc/select_existing_assignment_bloc.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/assignment_item_tile.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectExistingAssignmentPage extends StatefulWidget {
  const SelectExistingAssignmentPage({Key key}) : super(key: key);
  @override
  _SelectExistingAssignmentPageState createState() =>
      _SelectExistingAssignmentPageState();
}

class _SelectExistingAssignmentPageState
    extends State<SelectExistingAssignmentPage> {
  SelectExistingAssignmentBloc selectExistingAssignmentBloc;

  @override
  void initState() {
    super.initState();
    selectExistingAssignmentBloc =
        BlocProvider.of<SelectExistingAssignmentBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          ///First sliver is the App Bar
          CustomSliverAppbar(
            title: Strings.selectExistingAssignment,
            isPinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: Theme.of(context).colorScheme.primary,
            ),
            showActions: false,
          ),
          BlocConsumer<SelectExistingAssignmentBloc,
              SelectExistingAssignmentState>(
            bloc: selectExistingAssignmentBloc,
            listener: (context, state) {
              if (state is AssignmentSelected) {
                Navigator.of(context).popAndPushNamed(Routes.requestTutorForm);
              }
            },
            builder:
                (BuildContext context, SelectExistingAssignmentState state) {
              if (state is AssignmentsLoaded) {
                return PaginatedSliverList<TuteeAssignment>(
                  displayItems: state.userAssignmentList,
                  loadState: LoadState.allLoaded,
                  builder: (BuildContext context, TuteeAssignment assignment) {
                    return AssignmentItemTile(
                      assignment: assignment,
                      bottombar: BottomActionBarNew(
                        buttonText: const ['Select'],
                        buttonTextStyles: [
                          Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ],
                        buttonOnPress: [
                          () {
                            selectExistingAssignmentBloc.add(
                              SelectedAssignment(
                                isNew: false,
                                selectedAssignment: assignment,
                                context: context,
                              ),
                            );
                          }
                        ],
                      ),
                    );
                  },
                );
              }
              return SliverToBoxAdapter(
                child: Container(
                  color: Colors.red,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
