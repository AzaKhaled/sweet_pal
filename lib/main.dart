import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/services/deep_link_handler.dart';
import 'package:sweet_pal/core/services/serv_locator.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';
import 'package:sweet_pal/core/services/localization_service.dart';
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
import 'package:sweet_pal/core/providers/theme_provider.dart';

//azakhaled813@gmail.com
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

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
  
  // Initialize localization service
  final localizationService = LocalizationService();
  await localizationService.init();
  
  runApp(Resturant(localizationService: localizationService));
}

class Resturant extends StatelessWidget {
  final LocalizationService localizationService;

  const Resturant({super.key, required this.localizationService});

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

              return MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(value: localizationService),
                  ChangeNotifierProvider(create: (context) => ThemeProvider()),
                ],
                child: Consumer2<LocalizationService, ThemeProvider>(
                  builder: (context, localizationService, themeProvider, child) {
                    return MaterialApp(
                      scaffoldMessengerKey: rootScaffoldMessengerKey,
                      debugShowCheckedModeBanner: false,
                      title: 'Sweet Pal',
                      theme: themeProvider.currentTheme,
                      locale: localizationService.currentLocale,
                      supportedLocales: localizationService.supportedLocales,
                      localizationsDelegates: const [
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
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
          ),
        );
      },
    );
  }
}
