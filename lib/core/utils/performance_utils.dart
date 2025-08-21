import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class PerformanceUtils {
  static const ScrollPhysics optimizedScrollPhysics = BouncingScrollPhysics();

  static const double optimizedImageSize = 100.0;

  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Widget buildOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
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
    );
  }

  static Widget buildOptimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    EdgeInsetsGeometry? padding,
    Widget Function(BuildContext, int)? separatorBuilder,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      padding: padding,
      physics: optimizedScrollPhysics,
      itemCount: itemCount,
      separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox.shrink(),
      itemBuilder: itemBuilder,
    );
  }

  static void deferHeavyOperation(Function operation) {
    Timer.run(() {
      operation();
    });
  }

  static Future<T> runInBackground<T>(Future<T> Function() computation) async {
    return await Future.microtask(computation);
  }

  static Widget buildCachedWidget({required Widget child, String? key}) {
    return RepaintBoundary(child: child);
  }

  static void optimizeMemory() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
    });
  }
}
