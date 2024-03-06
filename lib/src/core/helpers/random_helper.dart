import "package:uuid/uuid.dart";

abstract class RandomHelper {
  static const Uuid _uuid = Uuid();

  static String generateUuid() {
    return _uuid.v6();
  }
}
