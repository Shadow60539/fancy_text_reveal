import 'package:fancy_text_reveal/fancy_text_reveal.dart';
import 'package:flutter/material.dart';

/// ```Example Usecase
/// @override
Widget build(BuildContext context) {
  return FancyTextReveal(child: Text('You are Awesome!'));
}

/// ```

///[FancyTextReveal] to add fancy text reveal animation.
class FancyTextReveal extends StatefulWidget {
  ///[child] that has to be shown after the reveal animation.
  final Widget child;

  ///[properties] for customizing the properties of the [FancyTextReveal]
  final Properties properties;

  const FancyTextReveal(
      {Key? key,
      required this.child,
      this.properties = const Properties(
        decoration: BoxDecoration(color: Colors.white),
      )})
      : super(key: key);

  @override
  _FancyTextRevealState createState() => _FancyTextRevealState();
}

class _FancyTextRevealState extends State<FancyTextReveal>
    with SingleTickerProviderStateMixin {
  ///The main AnimationController that drives the animation.
  AnimationController? _animationController;

  ///Animation thats responsible for animating between 0 and width of [child].
  ///
  ///The size of the [child] is measured in the very beginning and trigger
  ///[_animationController] to start the animation.
  Animation<double>? _animation;

  ///To update the size of the [child] and use it as end parameter for [_animation].
  ///
  ///Initially size is set to Size(0.0,0.0)
  ValueNotifier<Size> _notifier = ValueNotifier(Size(0.0, 0.0));

  ///Alignment of the [CrossFadeState]
  ///
  ///After one [AnimationStatus.completed] it is set to [Alignment.centerRight]
  Alignment _alignment = Alignment.centerLeft;

  ///Toggle to stop the animation after finished.
  ///
  ///After the [_animationController] completes the forward and reverse animation.
  bool shouldStop = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.properties.milliseconds))
      ..addStatusListener(_listener);

    super.initState();
  }

  void _listener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _alignment = Alignment.centerRight;
      _animationController!.reverse();
      setState(() {
        shouldStop = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget get _child => MeasureSize(
      onChange: (newSize) => _notifier.value = newSize, child: widget.child);

  Animation get _getAnimation => Tween(
          begin: 0.0,
          end: _notifier.value.width + widget.properties.horizontalSpacing)
      .animate(CurvedAnimation(
          parent: _animationController!, curve: Curves.fastOutSlowIn));

  void _startAnimation() {
    if (_notifier.value.height != 0.0) {
      _animation = _getAnimation as Animation<double>?;

      //Start the animation if not.
      if (_animationController!.status == AnimationStatus.dismissed) {
        if (!shouldStop) {
          _animationController!.forward();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_notifier, _animationController]),
      builder: (BuildContext context, Widget? _) {
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
              duration: _animationController!.duration!,
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

///Customization for [FancyTextReveal]
class Properties {
  ///For custom box decoration of the container.
  ///
  ///By default set to BoxDecoration(color: Colors.white)
  final Decoration? decoration;

  ///Duration of the animation.
  final int milliseconds;

  ///For adding vertical padding to the container.
  final double verticalSpacing;

  ///For adding horizontal padding to the container.
  final double horizontalSpacing;

  const Properties({
    this.decoration,
    this.milliseconds = 800,
    this.verticalSpacing = 0.0,
    this.horizontalSpacing = 0.0,
  });
}
