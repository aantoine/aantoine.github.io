
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';

class TableCardAdd extends StatelessWidget {
  const TableCardAdd({
    super.key,
    required this.palette,
    required this.columnWidth,
  });

  final Palette palette;
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: palette.primaryContainer,
      child: Container(
        width: columnWidth,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.add,
                    color: palette.onSurface,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Add table",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: palette.onPrimaryContainer,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 18),
            Text(
              "Crea una nueva mesa de poker planning, serás el anfitrión de la mesa",
              style: TextStyle(
                color: palette.onSurface,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}