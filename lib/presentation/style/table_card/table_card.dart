import 'dart:math';

import 'package:card/domain/tables/entities/table.dart' as entities;
import 'package:card/presentation/style/palette.dart';
import 'package:flutter/material.dart';

class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.palette,
    required this.columnWidth,
    required this.table,
  });

  final Palette palette;
  final double columnWidth;
  final entities.Table table;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: palette.surfaceContainer,
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
                      color: palette.secondaryContainer,
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Icons.style,
                    color: palette.onSecondaryContainer,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    table.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: palette.onSurface,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 18),
            ...table.users.map((user) {
              return Text(
                user.name,
                style: TextStyle(
                  color: palette.onSurface,
                  fontSize: 14,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}