import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/selling_points.dart';

class SellingPointsEntity extends SellingPoints
    implements EntityBase<SellingPoints> {
  const SellingPointsEntity({String sellingPt}) : super(sellingPt: sellingPt);

  factory SellingPointsEntity.fromString(String pt) {
    return SellingPointsEntity(sellingPt: pt);
  }

  factory SellingPointsEntity.fromDomainEntity(SellingPoints entity) {
    return SellingPointsEntity(sellingPt: entity.pointers);
  }

  @override
  SellingPoints toDomainEntity() {
    return SellingPoints(sellingPt: pointers);
  }
}
