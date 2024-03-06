import "package:json_annotation/json_annotation.dart";
import "package:task_manager/src/domain/enums/user_login_provider_enum.dart";

part "user_model.g.dart";

@JsonSerializable()
class UserModel {
  late String? id;
  late String? name;
  late String? email;

  late UserLoginProviderEnum loginType;
  // late CompanyModel? company;
  // late List<AppPermissionsEnum>? permissions;
  // late UserStatusEnum status;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.loginType = UserLoginProviderEnum.email,
    // this.company,
    // this.permissions,
    // this.status = UserStatusEnum.valid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
