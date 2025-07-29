import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/custom_search.dart';


class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  final TextEditingController searchController = TextEditingController();
  String? name;
  String? avatarUrl;
  bool isValidImageUrl(String? url) {
    return url != null &&
        (url.endsWith('.png') ||
            url.endsWith('.jpg') ||
            url.endsWith('.jpeg') ||
            url.endsWith('.webp')) &&
        Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('auth_id', user.id)
          .maybeSingle(); // ✅ safer

      if (response != null) {
        setState(() {
          name = response['name'];
          avatarUrl = response['avatar_url'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name != null ? 'Welcome $name' : 'Welcome',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: isValidImageUrl(avatarUrl)
                    ? NetworkImage(avatarUrl!)
                    : const AssetImage('assets/images/g14.png'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomSearch(
            controller: searchController,
            onChanged: (value) {
              print("Searching for: $value");
            },
          ),
        ],
      ),
    );
  }
}
