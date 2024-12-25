import 'package:custom_dropdown_menu/src/core/constants/constants.dart';
import 'package:custom_dropdown_menu/src/presentation/widgets/drop_menu.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu {
  static Future<void> showCustomMenu(
    BuildContext context, {
    Duration? duration,
    double? spacing,
    required GlobalKey widgetKey,
    required List<String> options,
    required Function(String) onSelected,
  }) async {
    final RenderBox renderBox =
        widgetKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final Size screenSize = MediaQuery.of(context).size;

    // Definir tamaño fijo del menú
    const double menuWidth = 220.0;
    const double horizontalMargin = 16.0; // Margen lateral mínimo
    final double menuHeight = options.length * 50.0;

    // Calcular posición superior e inferior
    double topPosition = offset.dy + size.height / 4;
    double bottomSpace = screenSize.height - topPosition;

    // Ajustar la posición superior si no hay suficiente espacio abajo
    if (bottomSpace < menuHeight) {
      topPosition =
          offset.dy - menuHeight - size.height / 2; // Ajustar hacia arriba
    }

    // Clampear la posición superior para evitar desbordes
    topPosition = topPosition.clamp(0.0, screenSize.height - menuHeight);

    // Calcular posición horizontal (centrado respecto al widget)
    final double leftPosition = (offset.dx + size.width / 2 - menuWidth / 2)
        .clamp(
            horizontalMargin, screenSize.width - menuWidth - horizontalMargin);

    // Mostrar el menú
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: leftPosition,
              top: topPosition,
              child: DropMenu(
                options: options,
                onSelected: onSelected,
                duration: duration,
                spacing: spacing ?? Constants.paddingValue,
                width: menuWidth, // Pasar el ancho fijo al DropMenu
              ),
            ),
          ],
        );
      },
    );
  }
}
