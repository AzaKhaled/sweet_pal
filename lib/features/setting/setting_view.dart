import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/auth/presentation/views/change_profile_view.dart';
import 'package:sweet_pal/auth/presentation/views/sigin_view.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';
import 'package:sweet_pal/core/widgets/language_switch_tile.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        title: Text(LocalizationHelper.settingsText,style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(LocalizationHelper.changeProfileText),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeProfileView(),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text(LocalizationHelper.darkModeText),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          const LanguageSwitchTile(), // Use the LanguageSwitchTile widget here
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(LocalizationHelper.translate('Logout', 'تسجيل الخروج')),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SiginView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
