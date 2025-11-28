# SalesPro - Sales Management Application

A complete sales management solution built with Flutter, following clean architecture principles and BLoC pattern for state management.


# Setup Instructions

# Prerequisites
- Flutter SDK 3.x or higher
- Android Studio or VS Code with Flutter extensions
- A Firebase project with Firestore and Authentication enabled

# Installation Steps

1. Extract the project ZIP file to your desired location

2. Open terminal in the project directory and run: 
  " flutter pub get "


3. Add your Firebase configuration files:
   - Place `google-services.json` in the `android/app/` directory
   - Place `GoogleService-Info.plist` in the `ios/Runner/` directory

4. Run the application:
   "flutter run"


# Building the APK

 run  "flutter build apk --release"

The generated APK will be available at `build/app/outputs/flutter-apk/app-release.apk`



# Package Dependencies

pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0

  # Dependency Injection
  get_it: ^7.6.7
  dartz: ^0.10.1

  # Local Storage
  flutter_secure_storage: ^9.0.0

  # Network Monitoring
  connectivity_plus: ^5.0.2

  # Data Grid for Reports
  syncfusion_flutter_datagrid: ^27.1.58

  # Utilities
  intl: ^0.19.0
  image_picker: ^1.0.7
  cupertino_icons: ^1.0.6


# State Management

The application uses BLoC (Business Logic Component) pattern for state management. This was chosen because:

- Separates business logic from UI completely
- Makes the code testable and maintainable
- Provides predictable state changes through events and states
- Works well with clean architecture

# BLoC Implementation Per Module
```bash
AuthBloc - Manages user authentication
- Events: LoginEvent, LogoutEvent, CheckAuthStatusEvent
- States: AuthInitial, AuthLoading, Authenticated, Unauthenticated, AuthError

CustomerBloc - Handles customer CRUD operations
- Events: LoadCustomers, LoadCustomerAreas, LoadCustomerCategories, CreateCustomer, UpdateCustomer, DeleteCustomer
- States: CustomerInitial, CustomerLoading, CustomersLoaded, CustomerAreasLoaded, CustomerCategoriesLoaded, CustomerOperationSuccess, CustomerError

ProductBloc - Manages product inventory
- Events: LoadProducts, LoadProductBrands, LoadProductCategories, CreateProduct, UpdateProduct, DeleteProduct
- States: ProductInitial, ProductLoading, ProductsLoaded, ProductBrandsLoaded, ProductCategoriesLoaded, ProductOperationSuccess, ProductError

SaleBloc - Controls invoice creation
- Events: LoadSales, LoadSaleDetails, CreateSale, DeleteSale, GenerateInvoiceNumber
- States: SaleInitial, SaleLoading, SalesLoaded, SaleDetailsLoaded, InvoiceNumberGenerated, SaleOperationSuccess, SaleError

ReportBloc - Handles report generation and filtering
- Events: LoadSalesReport, FilterByDateRange, FilterByCustomer, LoadCategories, LoadCustomers
- States: ReportInitial, ReportLoading, ReportLoaded, ReportError

Dependencies are registered using `get_it` package in `injection_container.dart`.

```


# Firebase Collections (API Endpoints)

Since the backend uses Firebase Firestore, all data operations are performed on these collections:

# Master Data Collections (Pre-seeded)
```bash
| Collection         | Fields         | Description 

| customerAreas      | id, name       | Dropdown options for customer areas 
| customerCategories | id, name       | Dropdown options for customer types 
| productBrands      | id, name       | Dropdown options for product brands
| productCategories  | id, name       | Dropdown options for product categories 
```
### Transaction Collections (Created via App)
```bash
| Collection       | Fields                                                          

| users            | id, name, email, password                                                                             - User login credentials
| customers        | id, name, address, areaId, categoryId, createdAt                                                      - Customer master records 
| products         | id, name, categoryId, brandId, purchaseRate, salesRate, imageBase64, createdAt                        - Product master records 
| sales            | id, invoiceNo, date, customerId, customerName, customerAddress, totalQuantity, totalAmount, createdAt - Invoice headers 
| sales/{id}/items | id, sno, productId, productName, quantity, rate, discount, amount                                     - Invoice line items (subcollection) 
```

# Project Structure
```bash
lib/
│
├── main.dart
├── injection_container.dart
│
├── core/
│   │
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   │
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   ├── network/
│   │   └── network_info.dart
│   │
│   ├── router/
│   │   └── app_router.dart
│   │
│   ├── usecases/
│   │   └── usecase.dart
│   │
│   ├── utils/
│   │   └── validators.dart
│   │
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── dashboard_page.dart
│       ├── loading_widget.dart
│       └── network_aware_widget.dart
│
└── features/
    │
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_remote_data_source.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── get_current_user.dart
    │   │       ├── login.dart
    │   │       └── logout.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       └── pages/
    │           └── login_page.dart
    │
    ├── customers/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── customer_remote_data_source.dart
    │   │   ├── models/
    │   │   │   ├── customer_model.dart
    │   │   │   ├── customer_area_model.dart
    │   │   │   └── customer_category_model.dart
    │   │   └── repositories/
    │   │       └── customer_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── customer.dart
    │   │   │   ├── customer_area.dart
    │   │   │   └── customer_category.dart
    │   │   ├── repositories/
    │   │   │   └── customer_repository.dart
    │   │   └── usecases/
    │   │       ├── create_customer.dart
    │   │       ├── delete_customer.dart
    │   │       ├── get_customer_areas.dart
    │   │       ├── get_customer_categories.dart
    │   │       ├── get_customers.dart
    │   │       └── update_customer.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── customer_bloc.dart
    │       │   ├── customer_event.dart
    │       │   └── customer_state.dart
    │       ├── pages/
    │       │   ├── customers_page.dart
    │       │   └── customer_form_page.dart
    │       └── widgets/
    │           └── customer_list_item.dart
    │
    ├── products/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── product_remote_data_source.dart
    │   │   ├── models/
    │   │   │   ├── product_model.dart
    │   │   │   ├── product_brand_model.dart
    │   │   │   └── product_category_model.dart
    │   │   └── repositories/
    │   │       └── product_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── product.dart
    │   │   │   ├── product_brand.dart
    │   │   │   └── product_category.dart
    │   │   ├── repositories/
    │   │   │   └── product_repository.dart
    │   │   └── usecases/
    │   │       ├── create_product.dart
    │   │       ├── delete_product.dart
    │   │       ├── get_product_brands.dart
    │   │       ├── get_product_categories.dart
    │   │       ├── get_products.dart
    │   │       └── update_product.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── product_bloc.dart
    │       │   ├── product_event.dart
    │       │   └── product_state.dart
    │       ├── pages/
    │       │   ├── products_page.dart
    │       │   └── product_form_page.dart
    │       └── widgets/
    │           └── product_list_item.dart
    │
    ├── sales/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── sale_remote_data_source.dart
    │   │   ├── models/
    │   │   │   ├── sale_model.dart
    │   │   │   └── sale_detail_model.dart
    │   │   └── repositories/
    │   │       └── sale_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── sale.dart
    │   │   │   ├── sale_detail.dart
    │   │   │   └── sale_item.dart
    │   │   ├── repositories/
    │   │   │   └── sale_repository.dart
    │   │   └── usecases/
    │   │       ├── create_sale.dart
    │   │       ├── delete_sale.dart
    │   │       ├── generate_invoice_number.dart
    │   │       ├── get_sale_details.dart
    │   │       └── get_sales.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── sale_bloc.dart
    │       │   ├── sale_event.dart
    │       │   └── sale_state.dart
    │       ├── pages/
    │       │   ├── sales_page.dart
    │       │   ├── create_sale_page.dart
    │       │   └── sale_details_page.dart
    │       └── widgets/
    │           ├── cart_item_widget.dart
    │           ├── product_selector_dialog.dart
    │           └── sale_list_item.dart
    │
    └── reports/
        ├── data/
        │   ├── datasources/
        │   │   └── report_remote_data_source.dart
        │   ├── models/
        │   │   ├── sales_report_item_model.dart
        │   │   └── sales_report_filter_model.dart
        │   └── repositories/
        │       └── report_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   ├── sales_report_item.dart
        │   │   ├── sales_report_summary.dart
        │   │   └── sales_report_filter.dart
        │   ├── repositories/
        │   │   └── report_repository.dart
        │   └── usecases/
        │       ├── get_sales_report.dart
        │       ├── get_report_categories.dart
        │       └── get_report_customers.dart
        └── presentation/
            ├── bloc/
            │   ├── report_bloc.dart
            │   ├── report_event.dart
            │   └── report_state.dart
            └── pages/
                └── reports_page.dart
```

# Application Modules

# Login Screen
- Email and password authentication against Firestore users collection
- Form validation with error messages
- Secure token storage using flutter_secure_storage
- Auto-redirect to dashboard on successful login

# Dashboard
- Central navigation hub with cards for each module
- Quick access to Customers, Products, Sales, and Reports
- Logout functionality

# Customer Master
- List view with search functionality
- Add new customer with name, address, area (dropdown), and category (dropdown)
- Edit existing customer details
- Delete customer with confirmation dialog
- Pull-to-refresh for data reload

# Product Master
- Grid/list view of all products
- Add product with name, category, brand, purchase rate, and sales rate
- Image picker for product photos (stored as Base64)
- Edit and delete operations
- Category and brand dropdowns populated from master data

# Sales Invoice
- Auto-generated invoice number
- Date picker for invoice date
- Customer selection dropdown
- Product selector with quantity, rate, and discount inputs
- Dynamic cart with add/remove items
- Real-time total calculation
- Save invoice to Firestore with line items as subcollection

# Sales Report
- Syncfusion DataGrid for professional table display
- Date range filter (From Date - To Date)
- Customer name filter
- Columns: Invoice No, Date, Customer Name, Total Amount


# Additional Features

# Offline Detection
The app monitors network connectivity and displays a banner when the device goes offline. This is handled through:
- `connectivity_plus` package for network state monitoring
- `NetworkAwareWidget` wrapper that shows offline indicator
- Automatic retry when connection is restored

# Error Handling
- All API calls wrapped in try-catch blocks
- User-friendly error messages displayed via SnackBars
- Loading indicators during async operations

# Form Validation
- Required field validation
- Email format validation
- Numeric input validation for rates and quantities


# Notes

- Product images are stored as Base64 strings in Firestore to simplify the setup (no Firebase Storage required)
- The app uses Material 3 design components
- All UI elements are responsive and work on various screen sizes
- Pre-seeded data must be added to Firebase before first use (customerAreas, customerCategories, productBrands, productCategories)