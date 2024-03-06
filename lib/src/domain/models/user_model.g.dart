// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      loginType: $enumDecodeNullable(
              _$UserLoginProviderEnumEnumMap, json['loginType']) ??
          UserLoginProviderEnum.email,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'loginType': _$UserLoginProviderEnumEnumMap[instance.loginType]!,
    };

const _$UserLoginProviderEnumEnumMap = {
  UserLoginProviderEnum.email: 'email',
  UserLoginProviderEnum.google: 'google',
};
