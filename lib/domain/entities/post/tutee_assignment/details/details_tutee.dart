import 'package:cotor/domain/entities/core/details_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/date_details.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/additional_remarks.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/grade_records.dart';
import 'package:equatable/equatable.dart';

class DetailsTutee extends Equatable implements DetailsBase {
  const DetailsTutee({
    AdditionalRemarks additionalRemarks,
    DateDetails dateDetails,
    GradeRecords gradeRecords,
    List<Level> levels,
    List<SubjectArea> subjects,
  })  : _additionalRemarks = additionalRemarks,
        _dateDetails = dateDetails,
        _gradeRecords = gradeRecords,
        _levels = levels,
        _subjects = subjects;

  final AdditionalRemarks _additionalRemarks;
  final DateDetails _dateDetails;
  final GradeRecords _gradeRecords;
  final List<Level> _levels;
  final List<SubjectArea> _subjects;

  AdditionalRemarks get additionalRemarks => _additionalRemarks;

  @override
  DateDetails get dateDetails => _dateDetails;

  GradeRecords get gradeRecords => _gradeRecords;

  List<Level> get levels => _levels;

  List<SubjectArea> get subjects => _subjects;

  @override
  List<Object> get props => [
        _additionalRemarks,
        _dateDetails,
        _gradeRecords,
        _levels,
        _subjects,
      ];

  @override
  String toString() => ''' DetailsTutee(
      additionalRemarks: $additionalRemarks,
      dateDetails: $dateDetails,
      levels: $levels,
      subjects: $subjects,
      gradeRecords: $gradeRecords,
    )''';
}
