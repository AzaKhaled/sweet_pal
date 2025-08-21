import 'package:flutter/material.dart';
import 'package:sweet_pal/auth/presentation/views/change_profile_view.dart';
import 'package:sweet_pal/core/utils/app_performance.dart';

import 'package:sweet_pal/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:sweet_pal/features/orders/presentation/views/order_history_view.dart';

class HomeView extends StatefulWidget {
  final int initialTab;
  const HomeView({super.key, this.initialTab = 0});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late int _currentIndex;

  static const List<Widget> _screens = [
    HomeViewBody(),
    OrderHistoryView(),
    ChangeProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            AppPerformance.deferToNextFrame(() {
              setState(() => _currentIndex = index);
            });
          },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
