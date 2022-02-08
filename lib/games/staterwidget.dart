import 'dart:async';
import 'package:chess_/games/randomgame.dart';
import 'package:flutter/widgets.dart';
import 'package:timer_count_down/timer_controller.dart';

///
/// Simple countdown timer.
///
class staterWidget extends StatefulWidget {
  /// Length of the timer
  //final int seconds;

  /// how many seconds add after start or resume
  //final int addtime;

  /// Build method for the timer
  final Widget Function(BuildContext, String) build;

  /// Called when finished
  //final Function? onFinished;

  /// Build interval
  final Duration interval;



  /// Controller
  final CountdownController? controller;

  ///
  /// Simple countdown timer
  ///
  staterWidget({
    Key? key,
    //required this.seconds,
    required this.build,
    this.interval = const Duration(milliseconds: 10),
    //this.addtime = 0,
    //this.onFinished,
    this.controller,
  }) : super(key: key);

  @override
  _staterWidgetState createState() => _staterWidgetState();
}

///
/// State of timer
///
class _staterWidgetState extends State<staterWidget> {
  // Multiplier of secconds
  final int _secondsFactor = 1000000;

  // Timer
  Timer? _timer;

  // Current seconds
  String _currentMicroSeconds = '';

  @override
  void initState() {
    //_currentMicroSeconds = widget.seconds * _secondsFactor;

    widget.controller?.setOnStart(_startTimer);
    //widget.controller?.setOnPause(_onTimerPaused);
    //widget.controller?.setOnResume(_onTimerResumed);
    //widget.controller?.setOnRestart(_onTimerRestart);
    widget.controller?.isCompleted = false;

    if (widget.controller == null || widget.controller!.autoStart == true) {
      _startTimer();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(
      context,
      _currentMicroSeconds,
    );
  }






  ///
  /// Start timer
  ///
  void _startTimer() {

    if (_timer?.isActive == true) {
      _timer!.cancel();

      widget.controller?.isCompleted = true;
    }


      _timer = Timer.periodic(
        widget.interval,
            (Timer timer) {

            setState(() {
              _currentMicroSeconds =
                  moveStatus ;
            });

        },
      );

  }
}
