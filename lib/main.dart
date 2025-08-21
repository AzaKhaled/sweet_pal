import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/services/deep_link_handler.dart';
import 'package:sweet_pal/core/services/serv_locator.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';
import 'package:sweet_pal/core/utils/widgets/constat_keys.dart';
import 'package:sweet_pal/core/utils/app_performance.dart';
import 'package:sweet_pal/core/utils/performance_optimizations.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/category/category_cubit.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/products/product_cubit.dart';
import 'package:sweet_pal/features/orders/cubit/cart_cubit.dart';
import 'package:sweet_pal/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:sweet_pal/features/orders/cubit/order_cubit.dart';
import 'package:sweet_pal/features/orders/services/order_service.dart';
import 'package:sweet_pal/features/orders/presentation/views/order_history_view.dart';

//azakhaled813@gmail.com
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة تحسينات الأداء
  AppPerformance.initialize();
  PerformanceOptimizations.enablePerformanceOptimizations();
  PerformanceOptimizations.optimizeMemoryUsage();

  // تحسين إعدادات Flutter للأداء
  if (kDebugMode) {
    // تقليل debug prints
    debugPrint = (String? message, {int? wrapWidth}) {
      // طباعة الأخطاء فقط
      if (message != null && message.contains('ERROR')) {
        // print(message);
      }
    };

    // تحسين إعدادات الأداء
    debugPrintRebuildDirtyWidgets = false;
    debugPrint = (String? message, {int? wrapWidth}) {
      // إزالة معظم debug prints لتحسين الأداء
      if (message != null && message.contains('ERROR')) {
        // print(message);
      }
    };
  }

  await Supabase.initialize(
    url: AppConstants.Supabase_URL,
    anonKey: AppConstants.Supabase_Key,
  );
  setupServiceLocator();
  runApp(const Resturant());
}

class Resturant extends StatelessWidget {
  const Resturant({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CartCubit()),
            BlocProvider(
              create: (_) =>
                  CategoryCubit(SupabaseAuthService())..fetchCategories(),
            ),
            BlocProvider(create: (_) => ProductCubit(SupabaseAuthService())),
            BlocProvider(create: (_) => OrderCubit(OrderService())),
          ],
          child: Builder(
            builder: (context) {
              // هنا بعد ما الـ context اتبنى
              WidgetsBinding.instance.addPostFrameCallback((_) {
                DeepLinkHandler.init(context);
              });

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Sweet Pal',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  useMaterial3: true,
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    },
                  ),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  splashFactory: InkRipple.splashFactory,
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => const OnboardingView(),
                  '/order-history': (context) => const OrderHistoryView(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
