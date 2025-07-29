import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/services/serv_locator.dart';
import 'package:sweet_pal/core/utils/widgets/constat_keys.dart';
import 'package:sweet_pal/features/onboarding/presentation/views/onboarding_view.dart';


//azakhaled813@gmail.com
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: OnboardingView(),
        );
      },
    );
  }
}
