import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OnboardInfo extends Equatable {
  const OnboardInfo({
    @required this.title,
    @required this.description,
    @required this.image,
  })  : assert(title != null),
        assert(description != null);
  final AssetImage image;
  final String title;
  final String description;

  @override
  List<Object> get props => [image, title, description];
}
