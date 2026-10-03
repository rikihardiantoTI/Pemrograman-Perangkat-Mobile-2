import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/catalog.dart';
import 'screens/product_detail_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const StoreApp());
}

class StoreApp extends StatefulWidget {
  const StoreApp({super.key});

  @override
  State<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends State<StoreApp> {
  late final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _state,
      child: MaterialApp(
        title: 'TI24G Store - ${Catalog.featured.name}',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const ProductDetailScreen(product: Catalog.featured),
        builder: (BuildContext context, Widget? child) {
          // Skala teks dibatasi agar layout padat tidak pecah di font besar.
          return MediaQuery.withClampedTextScaling(
            minScaleFactor: 1,
            maxScaleFactor: 1.3,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
