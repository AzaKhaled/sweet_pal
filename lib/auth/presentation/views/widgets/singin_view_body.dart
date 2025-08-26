import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/auth/presentation/cubits/signin/signin_cubit.dart';
import 'package:sweet_pal/auth/presentation/views/singup_view.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/have_an_account_section.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/or_divider.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/password_field.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/unified_password_reset.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';
import 'package:sweet_pal/core/utils/widgets/custombutton.dart';
import 'package:sweet_pal/core/utils/widgets/customtextfiled.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password;
  late bool isTermsAccepted = false;

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
                SizedBox(height: 32.h),

                Text(
                  LocalizationHelper.welcomeBackText,
                  style: TextStyles.montserrat700_36.copyWith(
                    color: Provider.of<ThemeProvider>(context).textColor,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomTextFormField(
                  onSaved: (value) {
                    email = value!;
                  },
                  preffixIcon: const Icon(Icons.person_rounded),
                  hintText: LocalizationHelper.usernameOrEmailText,
                  textInputType: TextInputType.name,
                ),

                SizedBox(height: 16.h),
                PasswordField(
                  hintText: LocalizationHelper.passwordText,
                  onSaved: (value) {
                    password = value!;
                  },
                ),

                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordView(),
                          ),
                        );
                      },
                      child: Text(
                        LocalizationHelper.forgotPasswordText,
                        style: TextStyles.montserrat400_12_red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35.h),
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      context.read<SigninCubit>().signIn(email, password);
                    } else {
                      autovalidateMode = AutovalidateMode.always;
                      setState(() {});
                    }
                  },

                  text: LocalizationHelper.loginText,
                ),
                SizedBox(height: 16.h),
                const OrDivider(),

                SizedBox(height: 16.h),
                HaveAnAccountSection(
                  leadingText: LocalizationHelper.alreadyHaveAccountText,
                  actionText: 'Sign Up',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingUpView(),
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
