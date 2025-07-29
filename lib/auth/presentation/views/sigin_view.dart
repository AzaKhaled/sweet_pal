import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_pal/auth/domain/repos/auth_repo.dart';
import 'package:sweet_pal/auth/presentation/cubits/signin/signin_cubit.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/signin_view_body_bloc_consumer.dart';
import 'package:sweet_pal/core/services/serv_locator.dart';

class SiginView extends StatelessWidget {
  const SiginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(getIt<AuthRepo>()),
      child: Scaffold(
      
        body: const SignInViewBodyBlocConsumer(),
      ),
    );
  }
}
