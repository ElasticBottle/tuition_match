import 'package:cotor/core/usecases/usecase.dart';

class DelParams extends Params {
  const DelParams({this.postId});

  final String postId;

  @override
  List<Object> get props => [postId];
}
