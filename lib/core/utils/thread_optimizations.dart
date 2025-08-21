import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class ThreadOptimizations {
  // تحسين العمليات على الـ main thread
  static void deferToNextFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  // تحسين العمليات الثقيلة
  static void deferHeavyOperation(VoidCallback operation) {
    Timer.run(() {
      operation();
    });
  }

  // تحسين العمليات المتكررة
  static Timer? _debounceTimer;
  static void debounceOperation(VoidCallback operation, {Duration? delay}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      delay ?? const Duration(milliseconds: 300),
      operation,
    );
  }

  // تحسين العمليات المتسلسلة
  static void throttleOperation(VoidCallback operation, {Duration? delay}) {
    if (_debounceTimer?.isActive == true) return;
    operation();
    _debounceTimer = Timer(delay ?? const Duration(milliseconds: 100), () {});
  }

  // تحسين setState
  static void safeSetState(State state, VoidCallback fn) {
    if (state.mounted) {
      deferToNextFrame(() {
        if (state.mounted) {
          state.setState(fn);
        }
      });
    }
  }

  // تحسين العمليات المتزامنة
  static Future<T> runInBackground<T>(Future<T> Function() computation) async {
    return await compute(_executeTask, computation);
  }

  static Future<T> _executeTask<T>(Future<T> Function() task) async {
    return await task();
  }

  // تحسين العمليات المتسلسلة
  static void scheduleMicrotask(VoidCallback callback) {
    scheduleMicrotask(callback);
  }

  // تحسين العمليات المتأخرة
  static void scheduleDelayed(VoidCallback callback, Duration delay) {
    Timer(delay, callback);
  }

  // تحسين العمليات الدورية
  static Timer schedulePeriodic(VoidCallback callback, Duration period) {
    return Timer.periodic(period, (_) => callback());
  }

  // تحسين العمليات المتعددة
  static Future<List<T>> runMultipleTasks<T>(
    List<Future<T> Function()> tasks,
  ) async {
    final futures = tasks.map((task) => runInBackground(task)).toList();
    return await Future.wait(futures);
  }

  // تحسين العمليات المتسلسلة مع خطأ
  static Future<T?> runWithErrorHandling<T>(
    Future<T> Function() task,
    Function(String) onError,
  ) async {
    try {
      return await runInBackground(task);
    } catch (e) {
      onError(e.toString());
      return null;
    }
  }

  // تحسين العمليات مع timeout
  static Future<T?> runWithTimeout<T>(
    Future<T> Function() task,
    Duration timeout,
  ) async {
    try {
      return await runInBackground(task).timeout(timeout);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Task timeout: $e');
      }
      return null;
    }
  }

  // تحسين العمليات مع retry
  static Future<T?> runWithRetry<T>(
    Future<T> Function() task,
    int maxRetries,
    Duration delay,
  ) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        return await runInBackground(task);
      } catch (e) {
        if (i == maxRetries - 1) {
          if (kDebugMode) {
            debugPrint('Task failed after $maxRetries retries: $e');
          }
          return null;
        }
        await Future.delayed(delay);
      }
    }
    return null;
  }
}
