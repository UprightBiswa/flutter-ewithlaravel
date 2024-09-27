import 'package:provider/provider.dart';

import 'connction_provider/connectivity_provider.dart';
import 'login_provider/auth_token.dart';
import 'login_provider/login_provider.dart';

class CommonProviders {
  static ChangeNotifierProvider<ConnectivityProvider> connectionProvider() {
    return ChangeNotifierProvider<ConnectivityProvider>(
      create: (context) => ConnectivityProvider(),
    );
  }
static ChangeNotifierProvider<AuthState> authStateProvider() {
    return ChangeNotifierProvider<AuthState>(
      create: (context) => AuthState(),
    );
  }
  static ChangeNotifierProvider<LoginProvider> loginProvider() {
    return ChangeNotifierProvider<LoginProvider>(
      create: (context) => LoginProvider(),
    );
  }
}
