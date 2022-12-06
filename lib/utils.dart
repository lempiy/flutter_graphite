import 'dart:math';

import 'package:graphite/core/matrix.dart';

double getHighestHeightInARow(Matrix matrix, double defaultCellHeight, int y) {
  return matrix.s[y].fold(
      0,
      (acc, node) => max(
          acc,
          (node == null || node.size == null)
              ? defaultCellHeight
              : node.size!.height));
}

double getWidestWidthInAColumn(Matrix matrix, double defaultCellWidth, int x) {
  double acc = 0;
  for (var y = 0; y < matrix.height(); y++) {
    final node = matrix.getByCoords(x, y);
    acc = max(
        acc,
        (node == null || node.size == null)
            ? defaultCellWidth
            : node.size!.width);
  }
  return acc;
}

double getWidthOfCanvas(
    Matrix matrix, double defaultCellWidth, double cellPadding) {
  double width = 0.0;
  for (int x = 0; x < matrix.width(); x++) {
    width += (getWidestWidthInAColumn(matrix, defaultCellWidth, x) +
        cellPadding * 2);
  }
  return width;
}

double getHeightOfCanvas(
    Matrix matrix, double defaultCellHeight, double cellPadding) {
  double height = 0.0;
  for (int y = 0; y < matrix.height(); y++) {
    height += (getHighestHeightInARow(matrix, defaultCellHeight, y) +
        cellPadding * 2);
  }
  return height;
}
