import 'package:equatable/equatable.dart';

class WithheldInfo extends Equatable {
  const WithheldInfo({
    String phoneNum,
    String countryCode,
    Map<String, String> allowed,
  })  : _phoneNum = phoneNum,
        _countryCode = countryCode,
        _allowed = allowed;

  final String _phoneNum;
  final String _countryCode;
  final Map<String, String> _allowed;

  String get phoneNum => _phoneNum;
  String get countryCode => _countryCode;
  Map<String, String> get allowed => _allowed;

  @override
  List<Object> get props => [
        phoneNum,
        countryCode,
        allowed,
      ];

  @override
  String toString() =>
      'WithheldInfo(phoneNum: $phoneNum, countryCode: $countryCode, allowed: $allowed)';
}
