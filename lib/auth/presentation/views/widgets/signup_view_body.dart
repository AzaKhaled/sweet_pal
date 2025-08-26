import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/auth/presentation/cubits/signup/signup_cubit.dart';
import 'package:sweet_pal/auth/presentation/views/sigin_view.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/have_an_account_section.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/or_divider.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/password_field.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/public_offer_section.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';
import 'package:sweet_pal/core/utils/widgets/custombutton.dart';
import 'package:sweet_pal/core/utils/widgets/customtextfiled.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';

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
                SizedBox(height: 32.h),
                Text(
                  LocalizationHelper.createAccountText,
                  style: TextStyles.montserrat700_36.copyWith(
                    color: Provider.of<ThemeProvider>(context).textColor,
                  ),
                ),
                SizedBox(height: 24.h),

                // Username field
                CustomTextFormField(
                  onSaved: (value) {
                    userName = value!;
                  },
                  preffixIcon: const Icon(Icons.person),
                  hintText: LocalizationHelper.usernameText,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationHelper.pleaseEnterUsernameText;
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
                  hintText: LocalizationHelper.emailText,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationHelper.pleaseEnterEmailText;
                    } else if (!EmailValidator.validate(value)) {
                      return LocalizationHelper.invalidEmailText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Password
                PasswordField(
                  controller: passwordController,
                  hintText: LocalizationHelper.passwordText,
                  onSaved: (value) => password = value!,
                ),
                SizedBox(height: 16.h),

                // Confirm Password
                PasswordField(
                  controller: confirmPasswordController,
                  hintText: LocalizationHelper.confirmPasswordText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationHelper.pleaseConfirmPasswordText;
                    } else if (value != passwordController.text) {
                      return LocalizationHelper.passwordsDoNotMatchText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                const PublicOffireSection(),
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
                  text: LocalizationHelper.createAccountButtonText,
                ),
                SizedBox(height: 16.h),

                const OrDivider(),
                SizedBox(height: 16.h),

                HaveAnAccountSection(
                  leadingText: LocalizationHelper.alreadyHaveAccountText,
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
