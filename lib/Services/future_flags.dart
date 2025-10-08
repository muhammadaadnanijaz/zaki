import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Services/mode_services.dart';

class FeatureFlags {
  static bool has(BuildContext context, String flag) =>
      Provider.of<ModeService>(context, listen: false).hasFeature(flag);

  static AppMode mode(BuildContext context) =>
      Provider.of<ModeService>(context, listen: false).mode;

  static Map<String, bool> all(BuildContext context) =>
      Provider.of<ModeService>(context, listen: false).allFlags;
}
