import 'package:flutter/material.dart';

class DropMenu extends StatefulWidget {
  const DropMenu({
    required List<String> options,
    required Function(String) onSelected,
    super.key,
  })  : _onSelected = onSelected,
        _options = options;

  final List<String> _options;
  final Function(String) _onSelected;

  @override
  State<DropMenu> createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 1.05).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 70,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.05, end: 1).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 20,
      ),
    ]).animate(_animationController);

    // Generar animaciones de desvanecimiento basadas en un único controlador
    _fadeAnimations = List<Animation<double>>.generate(
      widget._options.length,
      (int index) {
        final double start = 0.5 + (index * 0.1);
        final double end = start + 0.2;
        return Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              start.clamp(0.0, 1.0),
              end.clamp(0.0, 1.0),
              curve: Curves.easeIn,
            ),
          ),
        );
      },
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              widget._options.length,
              (int index) {
                return FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: ListTile(
                    title: Text(widget._options[index]),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget._onSelected(widget._options[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
