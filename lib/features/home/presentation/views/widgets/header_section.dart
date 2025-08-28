import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';
import 'package:sweet_pal/features/home/presentation/views/cubit/products/product_cubit.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/custom_search.dart';

class HeaderSection extends StatefulWidget {
  final VoidCallback? onProfileImageChanged;

  const HeaderSection({super.key, this.onProfileImageChanged});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();

  static final GlobalKey<_HeaderSectionState> headerKey = GlobalKey<_HeaderSectionState>();
}

class _HeaderSectionState extends State<HeaderSection> {
  final TextEditingController searchController = TextEditingController();
  String? name;
  String? avatarUrl;
  bool _isLoading = true;

  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    // Check if it's a valid URL format
    try {
      final uri = Uri.parse(url);
      if (!uri.isAbsolute) return false;

      // Check if it's a Supabase storage URL or valid image URL
      final validExtensions = ['.png', '.jpg', '.jpeg', '.webp', '.gif'];
      final hasValidExtension = validExtensions.any(
        (ext) => url.toLowerCase().endsWith(ext),
      );

      return hasValidExtension || url.contains('supabase.co');
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .eq('auth_id', user.id)
            .maybeSingle();

        if (response != null && mounted) {
          setState(() {
            name = response['name'];
            avatarUrl = response['avatar_url'];
            _isLoading = false;
          });
          // print('Avatar URL loaded: $avatarUrl');
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // print('Error fetching user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      context.read<ProductCubit>().searchProducts(value);
    } else {
      context.read<ProductCubit>().clearProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name != null ? '${LocalizationHelper.welcomeText} $name' : LocalizationHelper.welcomeText,
                    style: TextStyle(
                      fontSize: 20,
                      color: Provider.of<ThemeProvider>(context).textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    await fetchUserData();
                    widget.onProfileImageChanged?.call();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                child: _isLoading
                        ? const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColor,
                              ),
                            ),
                          )
                        : CircleAvatar(
    radius: 25,
    backgroundImage: isValidImageUrl(avatarUrl) ? NetworkImage(avatarUrl!) : null,
    onBackgroundImageError: isValidImageUrl(avatarUrl)
        ? (_, __) {
            // print('Error loading image: $avatarUrl');
          }
        : null,
    child: !isValidImageUrl(avatarUrl)
        ? Icon(Icons.person, color: Provider.of<ThemeProvider>(context).secondaryTextColor)
        : null,
  ),
),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomSearch(
              controller: searchController,
              onChanged: _onSearchChanged,
            ),
          ],
        ),
      ),
    );
  }
}
