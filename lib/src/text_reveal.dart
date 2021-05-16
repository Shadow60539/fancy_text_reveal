import 'package:fancy_text_reveal/fancy_text_reveal.dart';
import 'package:flutter/material.dart';

class FancyTextReveal extends StatefulWidget {
  final Widget child;

  final Properties properties;

  const FancyTextReveal(
      {Key key,
      @required this.child,
      this.properties = const Properties(
        decoration: BoxDecoration(color: Colors.white),
      )})
      : super(key: key);

  @override
  _FancyTextRevealState createState() => _FancyTextRevealState();
}

class _FancyTextRevealState extends State<FancyTextReveal>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  ValueNotifier<Size> _notifier = ValueNotifier(Size(0.0, 0.0));
  Alignment _alignment = Alignment.centerLeft;

  bool shouldStop = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.properties.milliseconds))
      ..addStatusListener(_listener);

    super.initState();
  }

  void _listener(status) {
    if (status == AnimationStatus.completed) {
      _alignment = Alignment.centerRight;
      _animationController.reverse();
      setState(() {
        shouldStop = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget get _child => MeasureSize(
      onChange: (newSize) => _notifier.value = newSize, child: widget.child);

  Animation get _getAnimation => Tween(
          begin: 0.0,
          end: _notifier.value.width + widget.properties.horizontalSpacing)
      .animate(CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn));

  void _startAnimation() {
    if (_notifier.value.height != 0.0) {
      _animation = _getAnimation;

      //If start the animation if not.
      if (_animationController.status == AnimationStatus.dismissed) {
        if (!shouldStop) {
          _animationController.forward();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_notifier, _animationController]),
      builder: (BuildContext context, Widget _) {
        _startAnimation();
        final _height = _notifier.value.height;
        final value = _animation?.value;
        return Stack(
          alignment: _alignment,
          children: [
            AnimatedCrossFade(
              firstChild: _child,
              secondChild: Opacity(opacity: 0.0, child: _child),
              crossFadeState: _alignment == Alignment.centerRight
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: _animationController.duration,
            ),
            Container(
              alignment: Alignment.center,
              height: _height + widget.properties.verticalSpacing,
              width: _notifier.value.height != 0.0 ? value : 0.0,
              decoration: widget.properties.decoration,
            )
          ],
        );
      },
    );
  }
}

class Properties {
  final Decoration decoration;
  final int milliseconds;
  final double verticalSpacing;
  final double horizontalSpacing;

  const Properties({
    this.decoration,
    this.milliseconds = 400,
    this.verticalSpacing = 0.0,
    this.horizontalSpacing = 0.0,
  });
}
