import 'package:cotor/domain/entities/review/review_tutee/identity_tutor_reviewer.dart';
import 'package:cotor/domain/entities/review/review_tutee/scores_tutee.dart';
import 'package:cotor/domain/entities/review/review_tutee/testimonial_tutee.dart';

abstract class ReviewTutee {
  IdentityTutorReviewer get identity;
  ScoresTutee get scores;
  TestimonialTutee get details;
}
