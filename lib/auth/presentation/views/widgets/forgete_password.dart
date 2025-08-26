import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';
import 'package:sweet_pal/core/utils/customtextfiled.dart';
import 'package:sweet_pal/core/utils/widgets/custombutton.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';

class ForgetedPassword extends StatefulWidget {
  const ForgetedPassword({super.key});

  @override
  State<ForgetedPassword> createState() => _ForgetedPasswordState();
}

class _ForgetedPasswordState extends State<ForgetedPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email;

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
                  LocalizationHelper.translate('Forget Password', 'نسيت كلمة المرور'),
                  style: TextStyles.montserrat700_36.copyWith(fontSize: 28.sp),
                ),
              ),

              SizedBox(height: 35.h),

              CustomTextFormField(
                onSaved: (value) {
                  email = value!.trim();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocalizationHelper.translate('Please enter your email', 'يرجى إدخال بريدك الإلكتروني');
                  }
                  if (!value.contains('@')) {
                    return LocalizationHelper.translate('Enter a valid email address', 'أدخل عنوان بريد إلكتروني صالح');
                  }
                  return null;
                },
                preffixIcon: const Icon(Icons.email_rounded),
                hintText: LocalizationHelper.translate('Email', 'البريد الإلكتروني'),
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
                text: LocalizationHelper.translate('Submit', 'إرسال'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    try {
                      final supabase = Supabase.instance.client;

                      await supabase.auth.resetPasswordForEmail(
                        email,
                        redirectTo: 'myapp://reset-password',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            LocalizationHelper.translate(
                              'Password reset email sent. Check your inbox.',
                              'تم إرسال بريد إلكتروني لإعادة تعيين كلمة المرور. تحقق من صندوق الوارد الخاص بك.'
                            ),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
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
                          content: Text(
                            LocalizationHelper.translate(
                              'An unexpected error occurred',
                              'حدث خطأ غير متوقع'
                            ),
                          ),
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
          ),
        ),
      ),
    );
  }
}
