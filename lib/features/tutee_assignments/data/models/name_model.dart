import 'package:cotor/features/tutee_assignments/domain/entities/name.dart';

import 'map_key_strings.dart';

class NameModel extends Name {
  const NameModel({
    String firstName,
    String lastName,
  }) : super(
          firstName: firstName,
          lastName: lastName,
        );

  factory NameModel.fromJson(Map json) {
    return NameModel(
      firstName: json[firstName],
      lastName: json[lastName],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      firstName: this.firstName,
      lastName: this.lastName,
    };
  }
}
