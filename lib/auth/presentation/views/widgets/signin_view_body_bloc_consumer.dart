import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_pal/auth/presentation/cubits/signin/signin_cubit.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/singin_view_body.dart';
import 'package:sweet_pal/core/helper_functions/build_error_bar.dart';
import 'package:sweet_pal/core/utils/widgets/custom_progress_hud.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/home_view.dart';

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Signin Success')),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        }
        if (state is SigninFailure) {
          buildErrorBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgressHUD(
          
          isLoading: state is SigninLoading ? true : false,
          child: SigninViewBody(),
        );
      },
    );
  }
}
