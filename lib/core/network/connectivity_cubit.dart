import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity connectivity;

  ConnectivityCubit(this.connectivity) : super(ConnectivityStatus.online) {
    _initialize();
  }

  void _initialize() async {
    // Check initial connectivity
    final result = await connectivity.checkConnectivity();
    _updateConnectivityStatus(result);

    // Listen to connectivity changes
    connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    debugPrint('[ConnectivityCubit] Connectivity changed: $results');
    
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      debugPrint('[ConnectivityCubit] Status: ONLINE');
      emit(ConnectivityStatus.online);
    } else {
      debugPrint('[ConnectivityCubit] Status: OFFLINE');
      emit(ConnectivityStatus.offline);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}