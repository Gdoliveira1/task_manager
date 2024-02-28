import "package:json_annotation/json_annotation.dart";

part "version_model.g.dart";

@JsonSerializable()
class VersionModel {
  final int major;
  final int minor;
  final int patch;

  const VersionModel({
    this.major = 0,
    this.minor = 0,
    this.patch = 0,
  });

  String getVersion() {
    return "$major.$minor.$patch";
  }

  factory VersionModel.fromInt(int version) {
    final String payload = "$version".padRight(3, "0");
    return VersionModel(
      major: int.parse(payload[0]),
      minor: int.parse(payload[1]),
      patch: int.parse(payload[2]),
    );
  }

  factory VersionModel.fromJson(Map<String, dynamic> json) =>
      _$VersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$VersionModelToJson(this);
}
