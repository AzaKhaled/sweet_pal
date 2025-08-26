import 'package:flutter/material.dart';
import 'package:sweet_pal/core/utils/app_performance.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:sweet_pal/features/map/presentation/views/widgets/map_view.dart';
import 'package:sweet_pal/features/orders/presentation/views/order_history_view.dart';
import 'package:sweet_pal/features/setting/setting_view.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';

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
    MapScreen(),
    SettingView(),
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
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home), 
              label: LocalizationHelper.translate('Home', 'الرئيسية'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag),
              label: LocalizationHelper.translate('Orders', 'الطلبات'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map), 
              label: LocalizationHelper.translate('Map', 'الخريطة'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings), 
              label: LocalizationHelper.translate('Settings', 'الإعدادات'),
            ),
          ],
        ),
      ),
    );
  }
}
