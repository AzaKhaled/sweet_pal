import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sweet_pal/auth/presentation/cubits/signup/signup_cubit.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/signup_view_body.dart';
import 'package:sweet_pal/core/helper_functions/build_error_bar.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/home_view.dart';

class SignUpViewBodyBlocConsumer extends StatelessWidget {
  const SignUpViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(child: Text('Signup Success')),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            }
            if (state is SignupFailure) {
              buildErrorBar(context, state.message);
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is SignupLoading ? true : false,
              child: SignupViewBody(),
            );
          },
        );
      },
    );
  }
}
