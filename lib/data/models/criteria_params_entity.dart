abstract class CriteriaParamsEntity<T> {
  const CriteriaParamsEntity();
  Map<String, dynamic> toMap();
  T toDomainParams();
}
