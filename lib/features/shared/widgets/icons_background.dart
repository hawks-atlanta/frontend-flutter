import 'package:flutter/material.dart';


class GeometricalBackground extends StatelessWidget {
  final Widget child;
  const GeometricalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final borderSize = size.width / 4; // Este es el tamaño para colocar 4 elementos


    final shapeWidgets = [
      _DarkDiamondSlideshowIcon(borderSize),
      _CropIcon(borderSize),
      _FolderIcon(borderSize),
      _FileIcon(borderSize),
    ];


    return SizedBox.expand(
      child: Stack(
        children: [

          Positioned(child: Container(color: backgroundColor)),

          // Background with shapes
          Container(
            height: size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                ShapeRow(shapeWidgets: shapeWidgets),
                ShapeRow(shapeWidgets: shapeWidgets),
                ShapeRow(shapeWidgets: shapeWidgets),
                ShapeRow(shapeWidgets: shapeWidgets),
                ShapeRow(shapeWidgets: shapeWidgets),
              ],
            )
          ),
          // Child widget
          child,
        ],
      ),
    );
  }
}

/// El objetivo de este widget es crear una final de figuras geometricas
/// Es Stateful porque quiero mantener el estado del mismo
/// El initState rompe la referencia para que lo pueda usar en varios lugares
class ShapeRow extends StatefulWidget {
  const ShapeRow({
    super.key,
    required this.shapeWidgets,
  });

  final List<Widget> shapeWidgets;

  @override
  State<ShapeRow> createState() => _ShapeRowState();
}

class _ShapeRowState extends State<ShapeRow> {

  late List<Widget> shapeMixedUp;

  @override
  void initState() {
    super.initState();
    shapeMixedUp = [...widget.shapeWidgets];
    shapeMixedUp.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: shapeMixedUp);
  }
}

/* Widgets de figuras :D
Style:
background: color: Colors.black
size: size: size * 0.6 (si se ajusta el tamaño del icono, ajustar este valor)
*/

class _FolderIcon extends StatelessWidget {
  final double size;

  const _FolderIcon(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.folder_outlined,
          size: size * 0.6, // Ajusta el tamaño del icono según tus preferencias
          color: const Color.fromARGB(255, 43, 43, 43),
        ),
      ),
    );
  }
}

class _FileIcon extends StatelessWidget {
  final double size;

  const _FileIcon(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          Icons.insert_drive_file_outlined, // Icono de archivo
          size: size * 0.6, // Ajusta el tamaño del icono según tus preferencias
          color: const Color.fromARGB(255, 43, 43, 43),
        ),
      ),
    );
  }
}

class _CropIcon extends StatelessWidget {
  final double size;

  const _CropIcon(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.crop_original_outlined,
          size: size * 0.6, // Ajusta el tamaño del icono según tus preferencias
          color: const Color.fromARGB(255, 43, 43, 43),
        ),
      ),
    );
  }
}

class _DarkDiamondSlideshowIcon extends StatelessWidget {
  final double size;

  const _DarkDiamondSlideshowIcon(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.black, // Cambia el color de fondo aquí
        shape: BoxShape.rectangle,
      ),
      child: Center(
        child: Icon(
          Icons.slideshow_outlined,
          size: size * 0.6,
          color: const Color.fromARGB(255, 43, 43, 43),
        ),
      ),
    );
  }
}

