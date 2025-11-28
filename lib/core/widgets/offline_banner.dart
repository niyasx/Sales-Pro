import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/connectivity_cubit.dart';

class OfflineBanner extends StatelessWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityStatus>(
      listener: (context, status) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars(); // remove any previous snackbars

        if (status == ConnectivityStatus.offline || status == ConnectivityStatus.online) {
          final isOffline = status == ConnectivityStatus.offline;
          final text = isOffline ? 'You are offline' : 'Back online';
          final color = isOffline ? Colors.red : Colors.green;
          final icon = isOffline ? Icons.wifi_off : Icons.wifi;

          messenger.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.transparent, // we use container decoration
              elevation: 0,
              duration: Duration(seconds: isOffline ? 4 : 2),
              content: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: isOffline
                      ? const LinearGradient(
                          colors: [Color(0xFFE53935), Color(0xFFEF5350)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      child: child,
    );
  }
}
