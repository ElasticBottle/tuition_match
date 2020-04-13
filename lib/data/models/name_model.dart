import 'package:cotor/domain/entities/name.dart';

import 'map_key_strings.dart';

class NameModel extends Name {
  const NameModel({
    String firstName,
    String lastName,
  }) : super(
          firstName: firstName,
          lastName: lastName,
        );

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstName: json[FIRSTNAME],
      lastName: json[LASTNAME],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FIRSTNAME: firstName,
      LASTNAME: lastName,
    };
  }
}
