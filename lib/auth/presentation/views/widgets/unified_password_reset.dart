import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/auth/presentation/views/sigin_view.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';
import 'package:sweet_pal/core/utils/customtextfiled.dart';
import 'package:sweet_pal/core/utils/widgets/custombutton.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/password_field.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isResetMode = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              Center(
                child: Text(
                  _isResetMode ? LocalizationHelper.changePasswordText : LocalizationHelper.forgotPasswordText,
                  style: TextStyles.montserrat700_36.copyWith(fontSize: 28.sp),
                ),
              ),
              SizedBox(height: 35.h),

              // ===== Forget Password Mode =====
              if (!_isResetMode) ...[
                CustomTextFormField(
                  onSaved: (value) {
                    email = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationHelper.pleaseEnterEmailText;
                    }
                    if (!value.contains('@')) {
                      return LocalizationHelper.invalidEmailText;
                    }
                    return null;
                  },
                  preffixIcon: const Icon(Icons.email_rounded),
                  hintText: LocalizationHelper.emailText,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text('*', style: TextStyles.montserrat400_12_red),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        LocalizationHelper.translate(
                          'We will send you a message to reset your password',
                          'سنرسل لك رسالة لإعادة تعيين كلمة المرور'
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  text: LocalizationHelper.translate('Send Reset Email', 'إرسال بريد إعادة التعيين'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      try {
                        final supabase = Supabase.instance.client;
                        await supabase.auth.resetPasswordForEmail(
                          email,
                          redirectTo: 'myapp://reset-password?type=recovery',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(LocalizationHelper.passwordResetEmailSentText),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() {
                          _isResetMode = true;
                        });
                      } on AuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(LocalizationHelper.unexpectedErrorText),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                ),
              ] 

              // ===== Reset Password Mode =====
              else ...[
                PasswordField(
                  controller: passwordController,
                  hintText: LocalizationHelper.translate('New Password', 'كلمة المرور الجديدة'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationHelper.translate('Enter new password', 'يرجى إدخال كلمة المرور الجديدة');
                    }
                    if (value.length < 6) {
                      return LocalizationHelper.translate('Password must be at least 6 characters', 'يجب أن تكون كلمة المرور 6 أحرف على الأقل');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                PasswordField(
                  controller: confirmPasswordController,
                  hintText: LocalizationHelper.confirmPasswordText,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return LocalizationHelper.passwordsDoNotMatchText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  text: LocalizationHelper.changePasswordText,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await Supabase.instance.client.auth.updateUser(
                          UserAttributes(password: passwordController.text),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(LocalizationHelper.passwordUpdatedText),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // بعد النجاح روح مباشرة لصفحة تسجيل الدخول
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SiginView(),
                          ),
                        );
                      } on AuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
