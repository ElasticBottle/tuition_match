import 'package:cotor/domain/entities/review/scores_base.dart';

abstract class ScoresTutor extends ScoresBase {
  int get patience;
  int get engagement;
  int get clarity;
  int get punctuality;
}
