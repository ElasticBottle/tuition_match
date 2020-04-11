import 'package:cotor/core/usecases/usecase.dart';
import 'package:flutter/material.dart';

class DelParams extends Params {
  const DelParams({this.postId, @required this.username});

  final String postId;
  final String username;

  @override
  List<Object> get props => [
        postId,
        username,
      ];
}
