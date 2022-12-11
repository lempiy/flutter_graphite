import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/typings.dart';

double getHighestHeightInARow(Matrix matrix, double defaultCellHeight, int y) {
  return matrix.s[y].fold(
      0,
      (acc, cell) => max(
          acc,
          cell == null
              ? defaultCellHeight
              : cell.all.fold(
                  0,
                  (prev, node) => node.size == null
                      ? defaultCellHeight
                      : node.size!.height)));
}

double getWidestWidthInAColumn(Matrix matrix, double defaultCellWidth, int x) {
  double acc = 0;
  for (var y = 0; y < matrix.height(); y++) {
    final cell = matrix.getByCoords(x, y);
    acc = max(
        acc,
        cell == null
            ? defaultCellWidth
            : cell.all.fold(
                0,
                (prev, node) =>
                    node.size == null ? defaultCellWidth : node.size!.width));
  }
  return acc;
}

double getWidthOfCanvas(
    Matrix matrix, double defaultCellWidth, EdgeInsets cellPadding) {
  double width = 0.0;
  for (int x = 0; x < matrix.width(); x++) {
    width += (getWidestWidthInAColumn(matrix, defaultCellWidth, x) +
        cellPadding.left +
        cellPadding.right);
  }
  return width;
}

double getHeightOfCanvas(
    Matrix matrix, double defaultCellHeight, EdgeInsets cellPadding) {
  double height = 0.0;
  for (int y = 0; y < matrix.height(); y++) {
    height += (getHighestHeightInARow(matrix, defaultCellHeight, y) +
        cellPadding.top +
        cellPadding.bottom);
  }
  return height;
}

List<List<double>> getHorizontalLine(List<List<double>> points) {
  for (int i = 0, j = 1; j < points.length; i++, j++) {
    final p1 = points[i], p2 = points[j];
    if (p1[1] == p2[1]) return [p1, p2];
  }
  return [];
}

List<List<double>> getVerticalLine(List<List<double>> points) {
  for (int i = 0, j = 1; j < points.length; i++, j++) {
    final p1 = points[i], p2 = points[j];
    if (p1[0] == p2[0]) return [p1, p2];
  }
  return [];
}

List<AnchorMargin> getEdgeMargins(MatrixNode node, MatrixNode income) {
  if (node.isAnchor && income.isAnchor) {
    return [node.anchorMargin!, income.anchorMargin!];
  } else if (node.isAnchor) {
    return [node.anchorMargin!, node.anchorMargin!];
  } else if (income.isAnchor) {
    return [income.anchorMargin!, income.anchorMargin!];
  } else {
    return [AnchorMargin.none, AnchorMargin.none];
  }
}

List<double> applyMargin(AnchorMargin margin, List<double> point,
    double distance, MatrixOrientation orientation) {
  if (margin == AnchorMargin.none) return point;
  if (orientation == MatrixOrientation.Horizontal &&
      margin == AnchorMargin.start) return [point[0] - distance, point[1]];
  if (orientation == MatrixOrientation.Vertical && margin == AnchorMargin.start)
    return [point[0], point[1] - distance];
  if (orientation == MatrixOrientation.Horizontal && margin == AnchorMargin.end)
    return [point[0] + distance, point[1]];
  if (orientation == MatrixOrientation.Vertical && margin == AnchorMargin.end)
    return [point[0], point[1] + distance];
  return point;
}

enum Direction { top, bottom, left, right }

double getPaddingFromDirection(EdgeInsets padding, Direction direction) {
  switch (direction) {
    case Direction.top:
      return padding.top;
    case Direction.bottom:
      return padding.bottom;
    case Direction.left:
      return padding.left;
    case Direction.right:
      return padding.right;
  }
}

Direction getXVertexDirection(int x1, int x2) {
  return x1 < x2 ? Direction.right : Direction.left;
}

Direction getYVertexDirection(int y1, int y2) {
  return y1 < y2 ? Direction.bottom : Direction.top;
}

Direction getVectorDirection(int x1, int y1, int x2, int y2) {
  return y1 == y2 ? getXVertexDirection(x1, x2) : getYVertexDirection(y1, y2);
}

double getMargin(AnchorMargin margin, double distance) {
  if (margin == AnchorMargin.none) return 0;
  return margin == AnchorMargin.start ? -distance : distance;
}

const pointResolversMap = {
  Direction.top: [Direction.top, Direction.bottom],
  Direction.bottom: [Direction.bottom, Direction.top],
  Direction.right: [Direction.right, Direction.left],
  Direction.left: [Direction.left, Direction.right]
};
