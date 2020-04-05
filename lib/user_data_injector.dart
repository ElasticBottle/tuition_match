import 'package:cotor/features/add_tutee_assignment/bloc/add_tutee_assignment_bloc.dart';
import 'package:cotor/features/sign-in/services/auth_service.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/tutee_assginments_bloc.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Used to create user-dependent objects that need to be accessible by all widgets.
/// This widgets should live above the [MaterialApp].
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class UserDataInjector extends StatelessWidget {
  const UserDataInjector({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        final User user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<User>.value(value: user),
              // NOTE: Any other user-bound providers here can be added here
              BlocProvider<AssignmentsBloc>(
                create: (context) => sl<AssignmentsBloc>(),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
