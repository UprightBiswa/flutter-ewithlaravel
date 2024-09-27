import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _isConnected = results.isNotEmpty && results.contains(ConnectivityResult.none) == false;
    notifyListeners();
  }
}
