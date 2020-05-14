import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/additional_remarks.dart';

class AdditionalRemarksEntity extends AdditionalRemarks
    implements EntityBase<AdditionalRemarks> {
  const AdditionalRemarksEntity({String remark}) : super(remark: remark);

  factory AdditionalRemarksEntity.fromString(String remark) {
    return AdditionalRemarksEntity(remark: remark);
  }

  factory AdditionalRemarksEntity.fromDomainEntity(AdditionalRemarks entity) {
    return AdditionalRemarksEntity(remark: entity.remarks);
  }

  @override
  AdditionalRemarks toDomainEntity() {
    return AdditionalRemarks(remark: remarks);
  }
}
