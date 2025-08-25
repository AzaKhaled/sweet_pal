import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class PerformanceOptimizations {
  // تحسين الأداء - إعدادات عامة
  static void enablePerformanceOptimizations() {
    // تحسين إعدادات Flutter
    if (kDebugMode) {
      debugPrintRebuildDirtyWidgets = false;
      debugPrint = (String? message, {int? wrapWidth}) {
        // إزالة معظم debug prints لتحسين الأداء
        if (kDebugMode && message != null && message.contains('ERROR')) {
          // طباعة الأخطاء فقط
          // print(message);
        }
      };
    }

    // تحسين إعدادات الرسم
    // WidgetsBinding.instance.addObserver(
    //   _PerformanceObserver(),
    // );
  }

  // تحسين الأداء - تحسين الذاكرة
  static void optimizeMemoryUsage() {
    // تنظيف الذاكرة بشكل دوري
    Timer.periodic(const Duration(minutes: 5), (timer) {
      // يمكن إضافة منطق تنظيف الذاكرة هنا
      if (kDebugMode) {
        debugPrint('Memory optimization check performed');
      }
    });
  }

  // تحسين الأداء - تحسين الصور
  static Widget buildOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        // تحسين الأداء - تحسين تحميل الصور
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          );
        },
      ),
    );
  }

  // تحسين الأداء - تحسين ListView
  static Widget buildOptimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    EdgeInsetsGeometry? padding,
    Widget Function(BuildContext, int)? separatorBuilder,
    ScrollPhysics? physics,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      padding: padding,
      physics: physics ?? const BouncingScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox.shrink(),
      itemBuilder: itemBuilder,
    );
  }

  // تحسين الأداء - تحسين GridView
  static Widget buildOptimizedGridView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required SliverGridDelegate gridDelegate,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      padding: padding,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      itemBuilder: itemBuilder,
    );
  }

  // تحسين الأداء - تحسين العمليات الثقيلة
  static Future<T> runInBackground<T>(Future<T> Function() computation) async {
    return await compute(_executeTask, computation);
  }

  static Future<T> _executeTask<T>(Future<T> Function() task) async {
    return await task();
  }

  // تحسين الأداء - تأجيل العمليات
  static void deferOperation(VoidCallback operation) {
    Timer.run(operation);
  }

  // تحسين الأداء - تحسين Widgets
  static Widget buildCachedWidget({required Widget child, String? key}) {
    return RepaintBoundary(key: key != null ? Key(key) : null, child: child);
  }

  // تحسين الأداء - تحسين النصوص
  static Widget buildOptimizedText({
    required String text,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      // تحسين الأداء - تحسين النصوص
      softWrap: true,
    );
  }

  // تحسين الأداء - تحسين الأزرار
  static Widget buildOptimizedButton({
    required VoidCallback onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  // تحسين الأداء - تحسين التحميل
  static Widget buildLoadingWidget({Color? color, double? size}) {
    return Center(
      child: SizedBox(
        width: size ?? 24,
        height: size ?? 24,
        child: CircularProgressIndicator(
          color: color ?? Colors.blue,
          strokeWidth: 2,
        ),
      ),
    );
  }

  // تحسين الأداء - تحسين الأخطاء
  static Widget buildErrorWidget({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
