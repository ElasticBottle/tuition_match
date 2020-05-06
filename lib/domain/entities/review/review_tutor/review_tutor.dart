import 'package:cotor/domain/entities/review/review_tutor/identity_tutee_reviewer.dart';
import 'package:cotor/domain/entities/review/review_tutor/scores_tutor.dart';
import 'package:cotor/domain/entities/review/review_tutor/testimonial_tutor.dart';

abstract class ReviewTutor {
  IdentityTuteeReviewer get identity;
  ScoresTutor get scores;
  TestimonialTutor get details;
}
