enum UserLoginProviderEnum {
  email("password"),
  google("google");

  final String provider;

  const UserLoginProviderEnum(this.provider);
}
