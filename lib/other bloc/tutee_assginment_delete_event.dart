import 'package:equatable/equatable.dart';

abstract class AssignmenttDeleteEvent extends Equatable {
  const AssignmenttDeleteEvent();
}

// Deleting Assignment
class DelAssignment extends AssignmenttDeleteEvent {
  @override
  List<Object> get props => [];
}
