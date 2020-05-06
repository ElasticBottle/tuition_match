import 'package:cotor/domain/entities/review/scores_base.dart';

abstract class ScoresTutee extends ScoresBase {
  int get cooperativeness;
  int get attitude;
  int get feePayments;
}
