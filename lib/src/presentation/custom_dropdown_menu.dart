import 'package:custom_dropdown_menu/src/presentation/widgets/drop_menu.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu {
  static Future<void> showCustomMenu(
    BuildContext context, {
    required GlobalKey widgetKey,
    required List<String> options,
    required Function(String) onSelected,
  }) async {
    final RenderBox renderBox =
        widgetKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final Size screenSize = MediaQuery.of(context).size;

    final double menuHeight = options.length * 50.0;

    double topPosition = offset.dy + size.height;
    double bottomSpace = screenSize.height - topPosition;

    if (bottomSpace < menuHeight) {
      topPosition = offset.dy - menuHeight;
    }

    topPosition = topPosition.clamp(0.0, screenSize.height - menuHeight);

    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                )),
            // Menú personalizado
            Positioned(
              left: offset.dx.clamp(
                0.0,
                screenSize.width - 250,
              ),
              top: topPosition - 20,
              child: DropMenu(
                options: options,
                onSelected: onSelected,
              ),
            ),
          ],
        );
      },
    );
  }
}

/* 

// CustomPainter para dibujar la flecha
class ArrowPainter extends CustomPainter {
  final Offset arrowPosition;

  ArrowPainter({required this.arrowPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Dibuja la flecha
    final Path path = Path();
    path.moveTo(arrowPosition.dx + 15, arrowPosition.dy);
    path.lineTo(arrowPosition.dx + 10, arrowPosition.dy - 10);
    path.lineTo(arrowPosition.dx + 20, arrowPosition.dy - 10);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}



 */
