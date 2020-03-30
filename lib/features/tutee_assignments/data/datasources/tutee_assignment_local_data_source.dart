import 'dart:convert';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/get_tutee_assignments_by_criterion.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_ASSIGNMENT_LIST = 'CACHED_ASSIGNMENT_LIST';
const CACHED_CRITERION = 'CACHED_CRITERION';

abstract class TuteeAssignmentLocalDataSource {
  /// Gets the cached [TuteeAssignmnetModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<TuteeAssignmentModel>> getLastAssignmentList();

  Future<void> cacheAssignmentList(
    List<TuteeAssignmentModel> assignmnetsToCache,
  );

  Future<void> cacheToExistingAssignmentList(
    List<TuteeAssignmentModel> assignmnetsToCache,
  );

  Future<void> cacheCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  });

  /// Gets the cached [CriteriaParams] which was used when the user attempted
  /// to search for assignments matching a particular set of criterion
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<CriteriaParams> getCachedParams();
}

class TuteeAssignmentLocalDataSourceImpl
    implements TuteeAssignmentLocalDataSource {
  TuteeAssignmentLocalDataSourceImpl({this.sharedPreferences});
  SharedPreferences sharedPreferences;

  @override
  Future<void> cacheCriterion(
      {Level level, Subject subject, double rateMin, double rateMax}) {
    final List<String> toEncode = _criterionToListString(
      level: level,
      subject: subject,
      rateMin: rateMin,
      rateMax: rateMax,
    );
    print(toEncode);
    return sharedPreferences.setString(
      CACHED_CRITERION,
      json.encode(toEncode),
    );
  }

  List<String> _criterionToListString(
      {Level level, Subject subject, double rateMin, double rateMax}) {
    return [
      level.index.toString(),
      subject.level.index.toString(),
      subject.subjectArea,
      rateMin.toString(),
      rateMax.toString()
    ];
  }

  CriteriaParams _criterionFromListString(List<dynamic> toConvert) {
    return CriteriaParams(
      level: Level.values[int.parse(toConvert[0])],
      subject: Subject(
          level: Level.values[int.parse(toConvert[1])],
          subjectArea: toConvert[2]),
      rateMin: double.parse(toConvert[3]),
      rateMax: double.parse(toConvert[4]),
    );
  }

  @override
  Future<CriteriaParams> getCachedParams() {
    final String jsonString = sharedPreferences.getString(CACHED_CRITERION);
    if (jsonString != null) {
      final List<dynamic> criterionList = json.decode(jsonString);
      final CriteriaParams result = _criterionFromListString(criterionList);
      return Future.value(result);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheAssignmentList(
      List<TuteeAssignmentModel> assignmnetsToCache) {
    final List<Map<String, dynamic>> toEncode =
        assignmnetsToCache.map((TuteeAssignmentModel e) => e.toJson()).toList();
    return sharedPreferences.setString(
      CACHED_ASSIGNMENT_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<void> cacheToExistingAssignmentList(
      List<TuteeAssignmentModel> assignmnetsToCache) async {
    final List<Map<String, dynamic>> toEncode =
        assignmnetsToCache.map((TuteeAssignmentModel e) => e.toJson()).toList();

    final String jsonString =
        sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);
    if (jsonString != null) {
      final List<dynamic> assignmentString =
          List<dynamic>.from(json.decode(jsonString));
      assignmentString.addAll(toEncode);
      return sharedPreferences.setString(
        CACHED_ASSIGNMENT_LIST,
        json.encode(assignmentString),
      );
    }
    return sharedPreferences.setString(
      CACHED_ASSIGNMENT_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<List<TuteeAssignmentModel>> getLastAssignmentList() {
    final String jsonString =
        sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);
    if (jsonString != null) {
      final List<dynamic> assignmentString =
          List<dynamic>.from(json.decode(jsonString));
      final List<TuteeAssignmentModel> result = assignmentString
          .map((dynamic e) => TuteeAssignmentModel.fromJson(e))
          .toList();
      return Future.value(result);
    } else {
      throw CacheException();
    }
  }
}
