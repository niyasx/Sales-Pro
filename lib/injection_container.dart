import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/customers/data/datasources/customer_remote_data_source.dart';
import 'features/customers/data/repositories/customer_repository_impl.dart';
import 'features/customers/domain/repositories/customer_repository.dart';
import 'features/customers/domain/usecases/create_customer.dart';
import 'features/customers/domain/usecases/delete_customer.dart';
import 'features/customers/domain/usecases/get_customer_areas.dart';
import 'features/customers/domain/usecases/get_customer_categories.dart';
import 'features/customers/domain/usecases/get_customers.dart';
import 'features/customers/domain/usecases/update_customer.dart';
import 'features/customers/presentation/bloc/customer_bloc.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/create_product.dart';
import 'features/products/domain/usecases/delete_product.dart';
import 'features/products/domain/usecases/get_product_brands.dart';
import 'features/products/domain/usecases/get_product_categories.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/domain/usecases/update_product.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/sales/data/datasources/sale_remote_data_source.dart';
import 'features/sales/data/repositories/sale_repository_impl.dart';
import 'features/sales/domain/repositories/sale_repository.dart';
import 'features/sales/domain/usecases/create_sale.dart';
import 'features/sales/domain/usecases/delete_sale.dart';
import 'features/sales/domain/usecases/generate_invoice_number.dart';
import 'features/sales/domain/usecases/get_sale_details.dart';
import 'features/sales/domain/usecases/get_sales.dart';
import 'features/sales/presentation/bloc/sale_bloc.dart';
import 'features/reports/data/datasources/report_remote_data_source.dart';
import 'features/reports/data/repositories/report_repository_impl.dart';
import 'features/reports/domain/repositories/report_repository.dart';
import 'features/reports/domain/usecases/get_report_categories.dart';
import 'features/reports/domain/usecases/get_report_customers.dart';
import 'features/reports/domain/usecases/get_sales_report.dart';
import 'features/reports/presentation/bloc/report_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      logout: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      secureStorage: sl(),
    ),
  );

  // ! External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => const FlutterSecureStorage());



  // ! Features - Customers
  // Bloc
  sl.registerFactory(
    () => CustomerBloc(
      getCustomers: sl(),
      createCustomer: sl(),
      updateCustomer: sl(),
      deleteCustomer: sl(),
      getCustomerAreas: sl(),
      getCustomerCategories: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCustomers(sl()));
  sl.registerLazySingleton(() => CreateCustomer(sl()));
  sl.registerLazySingleton(() => UpdateCustomer(sl()));
  sl.registerLazySingleton(() => DeleteCustomer(sl()));
  sl.registerLazySingleton(() => GetCustomerAreas(sl()));
  sl.registerLazySingleton(() => GetCustomerCategories(sl()));

  // Repository
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<CustomerRemoteDataSource>(
    () => CustomerRemoteDataSourceImpl(firestore: sl()),
  );



  // ! Features - Products
  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getProducts: sl(),
      createProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      getProductBrands: sl(),
      getProductCategories: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => GetProductBrands(sl()));
  sl.registerLazySingleton(() => GetProductCategories(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );

  // ! Features - Sales
  // Bloc
  sl.registerFactory(
    () => SaleBloc(
      getSales: sl(),
      getSaleDetails: sl(),
      createSale: sl(),
      deleteSale: sl(),
      generateInvoiceNumber: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSales(sl()));
  sl.registerLazySingleton(() => GetSaleDetails(sl()));
  sl.registerLazySingleton(() => CreateSale(sl()));
  sl.registerLazySingleton(() => DeleteSale(sl()));
  sl.registerLazySingleton(() => GenerateInvoiceNumber(sl()));

  // Repository
  sl.registerLazySingleton<SaleRepository>(
    () => SaleRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SaleRemoteDataSource>(
    () => SaleRemoteDataSourceImpl(firestore: sl()),
  );


// ! Features - Reports
  // Bloc
  sl.registerFactory(
    () => ReportBloc(
      getSalesReport: sl(),
      getReportCategories: sl(),
      getReportCustomers: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSalesReport(sl()));
  sl.registerLazySingleton(() => GetReportCategories(sl()));
  sl.registerLazySingleton(() => GetReportCustomers(sl()));

  // Repository
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(firestore: sl()),
  );






}