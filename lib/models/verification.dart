import 'package:json_annotation/json_annotation.dart';

part 'verification.g.dart';

@JsonSerializable()
class Verification {
  String? email;
  int? expiresIn;
  String? code;

  Verification({this.email, this.expiresIn, this.code});

  factory Verification.fromJson(Map<String, dynamic> json) =>
      _$VerificationFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationToJson(this);
}
