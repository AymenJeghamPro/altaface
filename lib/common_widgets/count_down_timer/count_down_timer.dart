import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds + 1 % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2900),
    );
    if (controller.isAnimating) {
      controller.stop();
    } else {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          color: Colors.black54.withOpacity(0.5),
          child: Text(
            timerString,
            style: const TextStyle(fontSize: 112.0, color: Colors.white),
          ),
        );
      },
    );
  }
}
