import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  const Failure({this.properties = const <dynamic>[]});
  final List properties;

  @override
  List<Object> get props => [properties];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class FileFailure extends Failure {}

class NetworkFailure extends Failure {}

class NoUserFailure extends Failure {}

class SendEmailFailure extends Failure {}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({@required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
