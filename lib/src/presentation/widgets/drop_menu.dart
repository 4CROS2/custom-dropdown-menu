import 'package:custom_dropdown_menu/src/core/constants/constants.dart';
import 'package:extensions/extensions.dart';
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
  late final List<AnimationController> _fadeControllers;

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
          CurveTween(
            curve: Curves.easeOut,
          ),
        ),
        weight: 70, // Expansión inicial
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1).chain(
          CurveTween(
            curve: Curves.easeIn,
          ),
        ),
        weight: 20, // Contracción a estado final
      ),
    ]).animate(_animationController);

    _fadeControllers = List<AnimationController>.generate(
      widget._options.length,
      (int index) {
        final AnimationController controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        );
        return controller;
      },
    );

    _animationController.addListener(() {
      if (_animationController.value >= 0.5) {
        _triggerFadeAnimations();
      }
    });

    _animationController.forward();
  }

  void _triggerFadeAnimations() {
    for (int i = 0; i < _fadeControllers.length; i++) {
      Future<void>.delayed(
        Duration(milliseconds: i * 100), // Escalona los delays
        () {
          if (mounted &&
              _fadeControllers[i].status == AnimationStatus.dismissed) {
            _fadeControllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final AnimationController controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: _scaleAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: Material(
        elevation: 1,
        borderRadius: Constants.mainBorderRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 140,
            maxWidth: 250,
          ),
          child: Padding(
            padding: EdgeInsets.all(Constants.paddingValue),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List<Widget>.generate(
                widget._options.length,
                (int index) {
                  return FadeTransition(
                    opacity: _fadeControllers[index].drive(
                      CurveTween(
                        curve: Curves.easeIn,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 0 : 12,
                      ),
                      child: Material(
                        color: isDarkMode ? Colors.black12 : Colors.white,
                        clipBehavior: Clip.hardEdge,
                        borderRadius: Constants.mainBorderRadius / 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            widget._onSelected(widget._options[index]);
                          },
                          child: Padding(
                            padding: Constants.authInputContent,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget._options[index].capitalize(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
