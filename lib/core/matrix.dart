import 'package:meta/meta.dart';
import 'package:graphite/core/typings.dart';

class FindNodeResult {
  FindNodeResult({
    @required this.coords,
    @required this.item,
  });
  List<int> coords;
  NodeOutput item;
}

enum MatrixOrientation {
  Horizontal,
  Vertical,
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
    return row.any((NodeOutput point) {
      if (point != null && !this.isAllChildrenOnMatrix(point)) {
        return true;
      }
      return false;
    });
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
    var entry = this.s.asMap().entries.firstWhere((data) {
      var index = data.key;
      var row = data.value;
      return row.length == 0 || x >= row.length || row[x] == null;
    }, orElse: () => null);
    var y = entry == null ? this.height() : entry.key;
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
    List<NodeOutput> row = List.filled(this.width(), null, growable: true);
    this.s.insert(y, row);
  }

  void insertColumnBefore(int x) {
    this.s.forEach((row) {
      row.insert(x, null);
    });
  }

  List<int> find(bool Function(NodeOutput) f) {
    List<int> result;
    this.s.asMap().entries.any((rowEntry) {
      var y = rowEntry.key;
      var row = rowEntry.value;
      return row.asMap().entries.any((columnEntry) {
        var x = columnEntry.key;
        var cell = columnEntry.value;
        if (cell == null) return false;
        if (f(cell)) {
          result = [x, y];
          return true;
        }
        return false;
      });
    });
    return result;
  }

  FindNodeResult findNode(bool Function(NodeOutput) f) {
    FindNodeResult result;
    this.s.asMap().entries.any((rowEntry) {
      var y = rowEntry.key;
      var row = rowEntry.value;
      return row.asMap().entries.any((columnEntry) {
        var x = columnEntry.key;
        var cell = columnEntry.value;
        if (cell == null) return false;
        if (f(cell)) {
          result = FindNodeResult(coords: [x, y], item: cell);
          return true;
        }
        return false;
      });
    });
    return result;
  }

  NodeOutput getByCoords(int x, int y) {
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
    this.s[y][x] = item;
  }

  bool isAllChildrenOnMatrix(NodeOutput item) {
    return item.next.length == item.childrenOnMatrix;
  }

  Map<String, MatrixNode> normalize() {
    Map<String, MatrixNode> acc = Map();
    this.s.asMap().entries.forEach((rowEntry) {
      var y = rowEntry.key;
      var row = rowEntry.value;
      row.asMap().entries.forEach((columnEntry) {
        var x = columnEntry.key;
        var item = columnEntry.value;
        if (item != null) {
          acc[item.id] =
              MatrixNode.fromNodeOutput(x: x, y: y, nodeOutput: item);
        }
      });
    });
    return acc;
  }

  Matrix rotate() {
    var newMtx = Matrix();
    s.asMap().forEach((y, row) {
      row.asMap().forEach((x, cell) {
        newMtx.insert(y, x, cell);
      });
    });
    newMtx.orientation = orientation == MatrixOrientation.Horizontal
        ? MatrixOrientation.Vertical
        : MatrixOrientation.Horizontal;
    return newMtx;
  }

  String toString() {
    var result = "", max = 0;
    s.forEach((List<NodeOutput> row) {
      row.forEach((NodeOutput cell) {
        if (cell == null) return;
        if (cell.id.length > max) {
          max = cell.id.length;
        }
      });
    });
    s.forEach((List<NodeOutput> row) {
      row.forEach((NodeOutput cell) {
        if (cell == null) {
          result += fillWithSpaces(" ", max);
          result += "│";
          return;
        }
        result += fillWithSpaces(cell.id, max);
        result += "│";
      });
      result += "\n";
    });
    return result;
  }

  MatrixOrientation orientation;
  List<List<NodeOutput>> s;
}
