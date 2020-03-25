import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OnboardInfo extends Equatable {
  const OnboardInfo({
    @required this.title,
    @required this.description,
    @required this.image,
  })  : assert(title != null),
        assert(description != null);
  final String title;
  final String description;
  final AssetImage image;

  @override
  List<Object> get props => [title, description, image];
}
