import 'package:cotor/domain/entities/post/base_post/post_base.dart';

abstract class PostBaseEntity<T> extends PostBase {
  T toDomainEntity();
  Map<String, dynamic> toJson();
  Map<String, dynamic> toDocumentSnapshot({bool isNew, bool freeze = false});
  Map<String, dynamic> toApplicationJson();
  Map<String, dynamic> toApplicationMap({bool isNew, bool freeze});
}
