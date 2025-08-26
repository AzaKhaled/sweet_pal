import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/services/localization_service.dart';

class LocalizationHelper {
  static String getLocalizedCategoryName(
    Map<String, dynamic> category, {
    String? locale,
    BuildContext? context,
  }) {
    final currentLocale = locale ?? _getCurrentLanguageCode(context);
    final nameEn = category['name_en'] as String? ?? '';
    final nameAr = category['name_ar'] as String? ?? '';
    
    if (currentLocale.startsWith('ar') && nameAr.isNotEmpty) {
      return nameAr;
    } else {
      return nameEn;
    }
  }

  static String getLocalizedProductName(
    Map<String, dynamic> product, {
    String? locale,
    BuildContext? context,
  }) {
    final currentLocale = locale ?? _getCurrentLanguageCode(context);
    final nameEn = product['name_en'] as String? ?? '';
    final nameAr = product['name_ar'] as String? ?? '';
    
    if (currentLocale.startsWith('ar') && nameAr.isNotEmpty) {
      return nameAr;
    } else {
      return nameEn;
    }
  }

  static String getLocalizedProductDescription(
    Map<String, dynamic> product, {
    String? locale,
    BuildContext? context,
  }) {
    final currentLocale = locale ?? _getCurrentLanguageCode(context);
    final descEn = product['description_en'] as String? ?? '';
    final descAr = product['description_ar'] as String? ?? '';
    
    if (currentLocale.startsWith('ar') && descAr.isNotEmpty) {
      return descAr;
    } else {
      return descEn;
    }
  }

  // Static text translations
  static String translate(String englishText, String arabicText, {String? locale, BuildContext? context}) {
    final currentLocale = locale ?? _getCurrentLanguageCode(context);
    
    if (currentLocale.startsWith('ar')) {
      return arabicText;
    } else {
      return englishText;
    }
  }

  // Helper method to get current language code with context awareness
  static String _getCurrentLanguageCode([BuildContext? context]) {
    if (context != null) {
      try {
        final localizationService = Provider.of<LocalizationService>(context, listen: false);
        return localizationService.getCurrentLanguageCode();
      } catch (e) {
        // Fallback to singleton if context is not available
        return LocalizationService().getCurrentLanguageCode();
      }
    } else {
      // Fallback to singleton if context is not provided
      return LocalizationService().getCurrentLanguageCode();
    }
  }

  // Common static text translations
  static String get addToCartText {
    return translate('Add to Cart', 'أضف إلى السلة');
  }

  static String get addedToCartText {
    return translate('added to cart', 'تمت الإضافة إلى السلة');
  }

  static String get welcomeText {
    return translate('Welcome', 'مرحباً');
  }

  static String get settingsText {
    return translate('Settings', 'الإعدادات');
  }

  static String get changeProfileText {
    return translate('Change Profile', 'تغيير الملف الشخصي');
  }

  static String get darkModeText {
    return translate('Dark Mode', 'الوضع الداكن');
  }

  static String get languageText {
    return translate('Language', 'اللغة');
  }

  static String get tryAgainText {
    return translate('Try Again', 'حاول مرة أخرى');
  }

  static String get createOrderText {
    return translate('Create Order', 'إنشاء طلب');
  }

  static String get newOrderText {
    return translate('New Order', 'طلب جديد');
  }

  static String get cancelText {
    return translate('Cancel', 'إلغاء');
  }

  static String get cancelOrderText {
    return translate('Cancel Order', 'إلغاء الطلب');
  }

  static String get cancelOrderConfirmationText {
    return translate('Are you sure you want to cancel this order?', 'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟');
  }

  static String get signInText {
    return translate('Sign In', 'تسجيل الدخول');
  }

  static String get locationSavedText {
    return translate('Location saved successfully', 'تم حفظ الموقع بنجاح');
  }

  static String get failedToLoadCategoriesText {
    return translate('failed to load categories', 'فشل تحميل الفئات');
  }

  static String get paymentCanceledText {
    return translate('Payment canceled!', 'تم إلغاء الدفع!');
  }

  static String get paymentCompletedText {
    return translate('Payment completed successfully ✅', 'تم الدفع بنجاح ✅');
  }

  static String get paymentSuccessfulText {
    return translate('✅ Payment successful! Order completed.', '✅ تم الدفع بنجاح! اكتمل الطلب.');
  }

  static String get errorText {
    return translate('Error', 'خطأ');
  }

  static String get retryText {
    return translate('Retry', 'إعادة المحاولة');
  }

  static String get passwordUpdatedText {
    return translate('Password updated successfully!', 'تم تحديث كلمة المرور بنجاح!');
  }

  static String get passwordResetEmailSentText {
    return translate('Password reset email sent. Check your inbox.', 'تم إرسال بريد إعادة تعيين كلمة المرور. تحقق من بريدك الوارد.');
  }

  static String get unexpectedErrorText {
    return translate('An unexpected error occurred', 'حدث خطأ غير متوقع');
  }

  static String get currentPasswordIncorrectText {
    return translate('Current password is incorrect', 'كلمة المرور الحالية غير صحيحة');
  }

  static String get changePasswordText {
    return translate('Change password', 'تغيير كلمة المرور');
  }

  static String get signupSuccessText {
    return translate('Signup Success', 'نجح التسجيل');
  }

  static String get signinSuccessText {
    return translate('Signin Success', 'نجح تسجيل الدخول');
  }

  // Order related texts
  static String get ordersText {
    return translate('Orders', 'الطلبات');
  }

  static String get emptyCartText {
    return translate('Your cart is empty', 'سلة التسوق فارغة');
  }

  static String get totalText {
    return translate('Total:', 'المجموع:');
  }

  static String get proceedToCheckoutText {
    return translate('Proceed to Checkout', 'المتابعة إلى الدفع');
  }

  // Onboarding texts
  static String get allYourFavoritesText {
    return translate('All your favorites', 'كل ما تفضله');
  }

  static String get freeDeliveryOffersText {
    return translate('Free delivery offers', 'عروض توصيل مجانية');
  }

  static String get chooseYourFoodText {
    return translate('Choose your food', 'اختر طعامك');
  }

  static String get getStartedText {
    return translate('Get Started', 'ابدأ الآن');
  }

  // Signin View Texts
  static String get welcomeBackText {
    return translate('Welcome Back!', 'مرحباً بعودتك!');
  }

  static String get usernameOrEmailText {
    return translate('Username or Email', 'اسم المستخدم أو البريد الإلكتروني');
  }

  static String get passwordText {
    return translate('Password', 'كلمة المرور');
  }

  static String get forgotPasswordText {
    return translate('forgot password?', 'نسيت كلمة المرور؟');
  }

  static String get loginText {
    return translate('Login', 'تسجيل الدخول');
  }

  // Signup View Texts
  static String get createAccountText {
    return translate('Create an account', 'إنشاء حساب');
  }

  static String get usernameText {
    return translate('Username', 'اسم المستخدم');
  }

  static String get emailText {
    return translate('Email', 'البريد الإلكتروني');
  }

  static String get confirmPasswordText {
    return translate('Confirm Password', 'تأكيد كلمة المرور');
  }

  static String get createAccountButtonText {
    return translate('Create Account', 'إنشاء حساب');
  }

  static String get alreadyHaveAccountText {
    return translate('I Already Have an Account ', 'لدي حساب بالفعل ');
  }

  // Payment Page Texts
  static String get paymentText {
    return translate('Payment', 'الدفع');
  }

  static String get securePaymentText {
    return translate('Secure Payment', 'دفع آمن');
  }

  static String get completeOrderSafelyText {
    return translate('Complete your order safely', 'أكمل طلبك بأمان');
  }

  static String get orderIdText {
    return translate('Order ID:', 'رقم الطلب:');
  }

  static String get totalAmountText {
    return translate('Total Amount:', 'المبلغ الإجمالي:');
  }

  static String get payWithPayPalText {
    return translate('Pay with PayPal', 'الدفع عبر PayPal');
  }

  static String get paymentSecureText {
    return translate('Your payment is secure and encrypted.', 'دفعك آمن ومشفّر.');
  }

  // Order History Texts
  static String get myOrdersText {
    return translate('My Orders', 'طلباتي');
  }

  static String get refreshOrdersText {
    return translate('Refresh Orders', 'تحديث الطلبات');
  }

  static String get currentText {
    return translate('Current', 'الحالية');
  }

  static String get historyText {
    return translate('History', 'السابقة');
  }

  static String get oopsText {
    return translate('Oops! Something went wrong', 'عذراً! حدث خطأ ما');
  }

  static String get noOrdersYetText {
    return translate('No orders yet', 'لا توجد طلبات بعد');
  }

  static String get startCreatingOrderText {
    return translate('Start by creating your first order', 'ابدأ بإنشاء طلبك الأول');
  }

  static String get noCurrentOrdersText {
    return translate('No current orders', 'لا توجد طلبات حالية');
  }

  static String get noOrderHistoryText {
    return translate('No order history', 'لا يوجد سجل طلبات');
  }

  static String get itemsText {
    return translate('Items', 'العناصر');
  }

  static String get moreItemsText {
    return translate('more items', 'عناصر إضافية');
  }

  // Validation Messages
  static String get pleaseEnterUsernameText {
    return translate('Please enter your username', 'يرجى إدخال اسم المستخدم');
  }

  static String get pleaseEnterEmailText {
    return translate('Please enter your email', 'يرجى إدخال البريد الإلكتروني');
  }

  static String get invalidEmailText {
    return translate('Invalid email address', 'عنوان بريد إلكتروني غير صالح');
  }

  static String get pleaseConfirmPasswordText {
    return translate('Please confirm your password', 'يرجى تأكيد كلمة المرور');
  }

  static String get passwordsDoNotMatchText {
    return translate('Passwords do not match', 'كلمات المرور غير متطابقة');
  }
}
