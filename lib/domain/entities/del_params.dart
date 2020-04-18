import 'package:cotor/domain/usecases/usecase.dart';
import 'package:flutter/material.dart';

class DelParams extends Params {
  const DelParams({this.postId, @required this.uid});

  final String postId;
  final String uid;

  @override
  List<Object> get props => [
        postId,
        uid,
      ];
}
