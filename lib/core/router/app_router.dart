import 'package:flutter/material.dart';
import 'package:sales_management_app/core/widgets/dashboard_page.dart';
import 'package:sales_management_app/features/customers/presentation/pages/customers_page.dart';
import 'package:sales_management_app/features/products/presentation/pages/products_page.dart';
import 'package:sales_management_app/features/reports/presentation/pages/reports_page.dart';
import 'package:sales_management_app/features/sales/presentation/pages/sales_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';


class AppRouter {
  static const String login = '/';
  static const String dashboard = '/dashboard';
  static const String customers = '/customers';
  static const String products = '/products';
  static const String sales = '/sales';
  static const String reports = '/reports';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case customers:
        return MaterialPageRoute(builder: (_) => const CustomersPage());
      case products:
        return MaterialPageRoute(builder: (_) => const ProductsPage());
      case sales:
        return MaterialPageRoute(builder: (_) => const SalesPage());
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}