import 'package:graphite/core/typings.dart';

class FindNodeResult {
  FindNodeResult({
    required this.coords,
    required this.item,
  });
  List<int> coords;
  NodeOutput item;
}

String fillWithSpaces(String str, int l) {
  while (str.length < l) {
    str += " ";
  }
  return str;
}

class Matrix {
  Matrix()
      : this.s = [],
        this.orientation = MatrixOrientation.Horizontal;

  int width() {
    return this.s.fold(0, (w, row) => row.length > w ? row.length : w);
  }

  int height() {
    return this.s.length;
  }

  bool hasHorizontalCollision(int x, int y) {
    if (this.s.length == 0 || y >= this.s.length) {
      return false;
    }
    var row = this.s[y];
    return row.any((MatrixCell? point) {
      if (point != null && !this.isAllChildrenOnMatrix(point)) {
        return true;
      }
      return false;
    });
  }

  bool hasLoopAnchorCollision(int x, int y, int toX, String id) {
    if (this.s.length == 0 || y >= this.s.length) {
      return false;
    }
    if (x == 0) return false;
    final row = this.s[y];
    for (int dx = x - 1; dx >= toX + 1; dx--) {
      final cell = row[dx];
      if (cell == null) continue;
      return true;
    }
    // check last
    final cell = s[y][toX];
    if (cell == null) return false;
    if (!cell.isFull &&
        cell.margin != null &&
        cell.margin == AnchorMargin.start) return false;
    return true;
  }

  bool cellBusyForItem(NodeOutput item, int x, int y) {
    if (this.s.length == 0 || y >= this.s.length) {
      return false;
    }
    final cell = s[y][x];
    if (cell == null) return false;
    if (!cell.isFull &&
        item.isAnchor &&
        cell.margin != null &&
        cell.margin != item.anchorMargin) return false;
    return true;
  }

  bool hasVerticalCollision(int x, int y) {
    if (x >= this.width()) {
      return false;
    }
    return this.s.asMap().entries.any((data) {
      var index = data.key;
      var row = data.value;
      return index >= y && x < row.length && row[x] != null;
    });
  }

  int getFreeRowForColumn(int x) {
    if (this.height() == 0) {
      return 0;
    }
    final entries = this.s.asMap().entries.toList();
    final idx = entries.indexWhere((data) {
      var row = data.value;
      return row.length == 0 || x >= row.length || row[x] == null;
    });
    var y = idx == -1 ? this.height() : entries[idx].key;
    return y;
  }

  void extendHeight(int toValue) {
    while (this.height() < toValue) {
      this.s.add(List.filled(this.width(), null, growable: true));
    }
  }

  void extendWidth(int toValue) {
    for (var i = 0; i < this.height(); i++) {
      while (this.s[i].length < toValue) {
        this.s[i].add(null);
      }
    }
  }

  void insertRowBefore(int y) {
    List<MatrixCell?> row = List.filled(this.width(), null, growable: true);
    this.s.insert(y, row);
  }

  void insertColumnBefore(int x) {
    this.s.forEach((row) {
      row.insert(x, null);
    });
  }

  List<int>? find(bool Function(NodeOutput) f) {
    List<int>? result;
    this.s.asMap().entries.any((rowEntry) {
      var y = rowEntry.key;
      var row = rowEntry.value;
      return row.asMap().entries.any((columnEntry) {
        var x = columnEntry.key;
        var cell = columnEntry.value;
        if (cell == null) return false;
        if (cell.all.any((c) => f(c))) {
          result = [x, y];
          return true;
        }
        return false;
      });
    });
    return result;
  }

  FindNodeResult? findNode(bool Function(NodeOutput) f) {
    FindNodeResult? result;
    this.s.asMap().entries.any((rowEntry) {
      var y = rowEntry.key;
      var row = rowEntry.value;
      return row.asMap().entries.any((columnEntry) {
        var x = columnEntry.key;
        var cell = columnEntry.value;
        if (cell == null) return false;
        final i = cell.all.indexWhere((c) => f(c));
        if (i != -1) {
          result = FindNodeResult(coords: [x, y], item: cell.all[i]);
          return true;
        }
        return false;
      });
    });
    return result;
  }

  MatrixCell? getByCoords(int x, int y) {
    if (x >= this.width() || y >= this.height()) {
      return null;
    }
    return this.s[y][x];
  }

  void insert(int x, int y, NodeOutput item) {
    if (this.height() <= y) {
      this.extendHeight(y + 1);
    }
    if (this.width() <= x) {
      this.extendWidth(x + 1);
    }
    final current = s[y][x];
    if (current == null) {
      this.s[y][x] = !item.isAnchor
          ? MatrixCell(full: item)
          : (item.anchorMargin! == AnchorMargin.end
              ? MatrixCell(end: item)
              : MatrixCell(start: item));
      return;
    }
    if (!current.isFull &&
        current.margin != null &&
        current.margin != item.anchorMargin) {
      current.add(item);
    }
  }

  void put(int x, int y, MatrixCell? item) {
    if (this.height() <= y) {
      this.extendHeight(y + 1);
    }
    if (this.width() <= x) {
      this.extendWidth(x + 1);
    }
    this.s[y][x] = item;
  }

  bool isAllChildrenOnMatrix(MatrixCell cell) {
    return cell.all.every((item) => item.next.length == item.childrenOnMatrix);
  }

  Map<String, MatrixNode> normalize() {
    Map<String, MatrixNode> acc = Map();
    this.s.asMap().entries.forEach((rowEntry) {
      var y = rowEntry.key;
      var row = rowEntry.value;
      row.asMap().entries.forEach((columnEntry) {
        var x = columnEntry.key;
        var cell = columnEntry.value;
        if (cell != null) {
          cell.all.forEach((item) {
            acc[item.id] =
                MatrixNode.fromNodeOutput(x: x, y: y, nodeOutput: item);
          });
        }
      });
    });
    return acc;
  }

  Matrix rotate() {
    var newMtx = Matrix();
    s.asMap().forEach((y, row) {
      row.asMap().forEach((x, cell) {
        newMtx.put(y, x, cell);
      });
    });
    newMtx.orientation = orientation == MatrixOrientation.Horizontal
        ? MatrixOrientation.Vertical
        : MatrixOrientation.Horizontal;
    return newMtx;
  }

  String toString() {
    var result = "", max = 0;
    s.forEach((List<MatrixCell?> row) {
      row.forEach((MatrixCell? cell) {
        if (cell == null) return;
        if (cell.displayId.length > max) {
          max = cell.displayId.length;
        }
      });
    });
    s.forEach((List<MatrixCell?> row) {
      row.forEach((MatrixCell? cell) {
        if (cell == null) {
          result += fillWithSpaces(" ", max);
          result += "│";
          return;
        }
        result += fillWithSpaces(cell.displayId, max);
        result += "│";
      });
      result += "\n";
    });
    return result;
  }

  MatrixOrientation orientation;
  List<List<MatrixCell?>> s;
}

class MatrixCell {
  NodeOutput? start;
  NodeOutput? end;
  NodeOutput? full;
  MatrixCell({this.full, this.start, this.end})
      : assert((full != null && start == null && end == null) ||
            (full == null && start != null && end == null) ||
            (full == null && start == null && end != null) ||
            (full == null && start != null && end != null));

  bool get isFull => full != null;

  String get displayId => isFull
      ? full!.id
      : (start != null && end != null
          ? "${start!.id}+${end!.id}"
          : (start ?? end)!.id);

  AnchorMargin? get margin => isFull
      ? null
      : (start != null && end != null ? null : (start ?? end)!.anchorMargin);

  List<NodeOutput> get all => isFull
      ? [full!]
      : (start != null && end != null ? [start!, end!] : [(start ?? end)!]);

  void add(NodeOutput item) {
    if (item.anchorMargin == AnchorMargin.end) {
      if (end != null) {
        throw "end is occupied";
      }
      end = item;
    }
    if (item.anchorMargin == AnchorMargin.start) {
      if (start != null) {
        throw "start is occupied";
      }
      start = item;
    }
  }

  NodeOutput? getById(String id) {
    if (full != null && full!.id == id) {
      return full!;
    }
    if (start != null && start!.id == id) {
      return start!;
    }
    if (end != null && end!.id == id) {
      return end!;
    }
    return null;
  }
}
