import 'package:cotor/features/request_tutor/bloc/request_tutor_page_bloc.dart';
import 'package:cotor/features/request_tutor/request_tutor_form/pages/request_tutor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestTutorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestTutorPageBloc, RequestTutorPageState>(
      builder: (context, state) {
        if (state.userAssignments.isEmpty) {
          return RequestTutorForm();
        } else {
          return Container();
        }
      },
    );
  }
}
