import "package:uuid/uuid.dart";

// RandomHelper: A utility class for generating random identifiers.
abstract class RandomHelper {
  // Uuid instance for generating universally unique identifiers (UUIDs).
  static const Uuid _uuid = Uuid();

  // Generates a UUID (Universally Unique Identifier) using the Uuid package.
  static String generateUuid() {
    return _uuid.v6();
  }
}
