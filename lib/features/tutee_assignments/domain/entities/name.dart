import 'package:equatable/equatable.dart';

class Name extends Equatable {
  const Name({
    this.firstName,
    this.lastName,
  });
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName];
}
