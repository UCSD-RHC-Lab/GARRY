import 'package:flutter/animation.dart';

///
/// A cubic animation curve for highlighting the just-completed session
/// on the [Scoreboard].
///
class EaseOutBackScaled extends Curve {
  final double scale;

  EaseOutBackScaled({this.scale = 1.0});

  @override
  double transformInternal(double t) {
    var val = -scale * t * t + (scale.abs() + 1) * t;
    return val; //f(x)
  }
}
