import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_pal/auth/presentation/views/change_profile_view.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/category/category_cubit.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/products/product_cubit.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:sweet_pal/features/orders/presentation/views/order_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeViewBody(),
    OrderView(),
    ChangeProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CategoryCubit(SupabaseAuthService())..fetchCategories(),
        ),
        BlocProvider(create: (_) => ProductCubit(SupabaseAuthService())),
      ],
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Order',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
