import 'package:flutter/foundation.dart';

/// Prints a message to the console only when the app is in debug mode.
/// In release and profile builds, calls to this function are tree-shaken away,
/// resulting in zero performance impact.
void debugOnlyPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}
