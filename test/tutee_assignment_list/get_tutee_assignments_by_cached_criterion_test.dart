import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_tutee_assignments_by_cached_criterion.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTuteeAssignmentRepo extends Mock implements TuteeAssignmentRepo {}

void main() {
  MockTuteeAssignmentRepo mockRepo;
  GetTuteeAssignmentsByCachedCriterion usecase;

  setUp(() {
    mockRepo = MockTuteeAssignmentRepo();
    usecase = GetTuteeAssignmentsByCachedCriterion(repo: mockRepo);
  });

  group('Retrieving tutee assingments based on various criterion', () {
    final TuteeAssignment tTuteeAssignment = TuteeAssignment(
      level: Level.pri2,
      subject: Subject(
        level: Level.pri2,
        subjectArea: Languages.CHI,
      ),
      timing: 'Mon-Fri 7pm Onwards',
      format: ClassFormat.private,
      applied: 20,
      gender: Gender.female,
      freq: '1 hour x 1 per week',
      location: '4 Everton park',
      tutorOccupation: TutorOccupation.moe,
      rateMax: 80.0,
      rateMin: 60.0,
      additionalRemarks:
          'Sch girl who tries her best for the subject but can be a little distracted when learning. It\'d be good if the tutor could inspire her through different teaching methods like games and fun quizzes.',
      status: Status.open,
      username: 'test',
    );

    void _setUpMockRepoCriterionCall({bool success}) {
      when(mockRepo.getByCachedCriterion()).thenAnswer((realInvocation) async =>
          success
              ? Right<Failure, List<TuteeAssignment>>([tTuteeAssignment])
              : Left<Failure, List<TuteeAssignment>>(ServerFailure()));
    }

    test('Should call MockTuteeAssignmentRepo', () async {
      _setUpMockRepoCriterionCall(success: true);

      await usecase(NoParams());

      verify(mockRepo.getByCachedCriterion()).called(1);
    });

    test('Should return Right(List<TuteeAssignemnt>) on successful search',
        () async {
      _setUpMockRepoCriterionCall(success: true);

      final result = await usecase(NoParams());
      final List<Object> remarks = result.fold((l) => null, (r) => r[0].props);
      final List<Object> expected =
          Right<Failure, List<TuteeAssignment>>([tTuteeAssignment])
              .fold((l) => null, (r) => r[0].props);

      expect(remarks, expected);
    });

    test('Should return Left(Failure) on unsuccessful search', () async {
      _setUpMockRepoCriterionCall(success: false);

      final result = await usecase(NoParams());

      expect(result, Left<Failure, List<TuteeAssignment>>(ServerFailure()));
    });

    test('Should return empty list if no result match criteria', () async {
      when(mockRepo.getByCachedCriterion())
          .thenAnswer((_) async => Right<Failure, List<TuteeAssignment>>([]));

      final result = await usecase(NoParams());
      verify(mockRepo.getByCachedCriterion());
      final bool actual = result.fold((l) => null, (r) => r.isEmpty);
      final bool expected = Right<Failure, List<TuteeAssignment>>([])
          .fold((l) => null, (r) => r.isEmpty);
      expect(actual, expected);
    });
  });
}
