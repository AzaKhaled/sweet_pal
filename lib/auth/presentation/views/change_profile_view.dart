import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_pal/auth/presentation/cubits/profile/profile_cubit.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/change_profile_form.dart';
import 'package:sweet_pal/core/services/storage_service.dart';
import 'package:sweet_pal/core/services/supabase_auth_service.dart';

class ChangeProfileView extends StatelessWidget {
  const ChangeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(SupabaseAuthService(), StorageService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
        body: const ChangeProfileForm(),
      ),
    );
  }
}
