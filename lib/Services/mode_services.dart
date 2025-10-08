import 'package:flutter/foundation.dart';

enum AppMode { FULL, LITE }

class ModeService with ChangeNotifier {
  late AppMode _mode;
  final Map<String, bool> _features = {};
  static bool appMode = false;

  AppMode get mode => _mode;
  Map<String, bool> get allFlags => _features;

  Future<void> loadMode() async {
    _mode = AppMode.FULL; // flip to LITE for testing

    _features
      ..clear()
      ..addAll({
        'feature.bankIntegration': _mode == AppMode.FULL,
        'feature.debitCard': _mode == AppMode.LITE,
        'feature.externalTopup.card': _mode == AppMode.FULL,
        'feature.externalTopup.bank': _mode == AppMode.FULL,
        'feature.manageCards': _mode == AppMode.FULL,
        'feature.manualTxUpload': true,
        'feature.virtualCredits': _mode == AppMode.LITE,
      });

    notifyListeners();
  }

  bool hasFeature(String flag) => _features[flag] ?? false;
}
