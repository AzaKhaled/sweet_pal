import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sweet_pal/auth/presentation/cubits/signup/signup_cubit.dart';
import 'package:sweet_pal/auth/presentation/views/sigin_view.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/have_an_account_section.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/or_divider.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/password_field.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/public_offer_section.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';
import 'package:sweet_pal/core/utils/widgets/custombutton.dart';
import 'package:sweet_pal/core/utils/widgets/customtextfiled.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String email, userName, password;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Text('Create an account', style: TextStyles.montserrat700_36),
                SizedBox(height: 24.h),

                // Username field
                CustomTextFormField(
                  onSaved: (value) {
                    userName = value!;
                  },
                  preffixIcon: const Icon(Icons.person),
                  hintText: 'Username',
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Email field
                CustomTextFormField(
                  onSaved: (value) {
                    email = value!;
                  },
                  preffixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  } else if (!EmailValidator.validate(value)) {
    return 'Invalid email address';
  }
  return null;
}
),
                SizedBox(height: 16.h),

                // Password
                PasswordField(
                  controller: passwordController,
                  hintText: 'Password',
                  onSaved: (value) => password = value!,
                ),
                SizedBox(height: 16.h),

                // Confirm Password
                PasswordField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                PublicOffireSection(),
                SizedBox(height: 30.h),

                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      context.read<SignupCubit>().signUp(email, password, userName);

                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  text: 'Create Account',
                ),
                SizedBox(height: 16.h),

                const OrDivider(),
                SizedBox(height: 16.h),

                HaveAnAccountSection(
                  leadingText: 'I Already Have an Account ',
                  actionText: 'Login',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SiginView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
