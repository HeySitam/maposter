import 'dart:async';

/// Ensures sequential execution with a minimum gap between calls.
/// Used for Nominatim API (1 req/sec rate limit).
class RateLimiter {
  RateLimiter({required this.minGap});

  final Duration minGap;

  Future<void>? _last;

  Future<T> run<T>(Future<T> Function() task) {
    final previous = _last;
    final completer = Completer<T>();

    _last = completer.future.then((_) {}, onError: (_) {});

    Future(() async {
      if (previous != null) {
        await previous.catchError((_) {});
        await Future.delayed(minGap);
      }
      try {
        completer.complete(await task());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });

    return completer.future;
  }
}
