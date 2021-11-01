import 'dart:async';

class CountdownTimer {
  Timer? _timer;
  int count = 0;

  CountdownTimer(int count, {Function()? onFinished}) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count == 0) {
        cancel();
        onFinished?.call();
        return;
      }
      count--;
    });
  }

  CountdownTimer.periodic(
      Duration duration, void callback(Timer timer, int count)) {
    _timer = Timer.periodic(duration, (timer) {
      count++;
      callback(timer, count);
    });
  }

  cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
