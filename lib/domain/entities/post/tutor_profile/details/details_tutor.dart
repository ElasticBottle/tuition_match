import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:cotor/domain/entities/core/details_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/date_details.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';
import 'package:cotor/domain/entities/post/base_post/tutor_occupation.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/qualifications.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/selling_points.dart';

class DetailsTutor extends Equatable implements DetailsBase {
  const DetailsTutor({
    DateDetails dateDetails,
    @required List<Level> levelsTaught,
    @required List<SubjectArea> subjectsTaught,
    @required TutorOccupation tutorOccupation,
    @required Qualifications qualification,
    @required SellingPoints sellingPoints,
  })  : _dateDetails = dateDetails,
        _levelsTaught = levelsTaught,
        _tutorOccupation = tutorOccupation,
        _qualification = qualification,
        _sellingPoints = sellingPoints,
        _subjectsTaught = subjectsTaught;

  final DateDetails _dateDetails;
  final List<Level> _levelsTaught;
  final List<SubjectArea> _subjectsTaught;
  final TutorOccupation _tutorOccupation;
  final Qualifications _qualification;
  final SellingPoints _sellingPoints;

  @override
  DateDetails get dateDetails => _dateDetails;

  List<Level> get levelsTaught => _levelsTaught;

  SellingPoints get sellingPoints => _sellingPoints;

  TutorOccupation get occupation => _tutorOccupation;

  Qualifications get qualification => _qualification;

  List<SubjectArea> get subjectsTaught => _subjectsTaught;

  @override
  List<Object> get props => [
        _dateDetails,
        _levelsTaught,
        _subjectsTaught,
        _tutorOccupation,
        _qualification,
        _sellingPoints,
      ];

  @override
  String toString() {
    return '''DetailsTutor(
      dateDetails: $dateDetails,
      levelsTaught: $levelsTaught, 
      subjectsTaught: $subjectsTaught, 
      tutorOccupation: $occupation, 
      qualification: $qualification, 
      sellingPoints: $sellingPoints
    )''';
  }
}
