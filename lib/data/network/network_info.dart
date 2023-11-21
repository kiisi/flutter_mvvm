import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImplementor implements NetworkInfo {
  InternetConnectionChecker _internetConnectionChecker;

  NetworkInfoImplementor(this._internetConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => _internetConnectionChecker.hasConnection;
}
