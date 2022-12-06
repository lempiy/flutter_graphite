import 'package:flutter_test/flutter_test.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/core/graph.dart';
import 'package:graphite/core/graph_basic.dart';

const presetBasic =
    '[{"id":"A","next":[{"outcome":"B","type":"one"}]},{"id":"B","next":[{"outcome":"C","type":"one"},{"outcome":"D","type":"one"},{"outcome":"E","type":"one"}]},{"id":"C","next":[{"outcome":"F","type":"one"}]},{"id":"D","next":[{"outcome":"J","type":"one"}]},{"id":"E","next":[{"outcome":"J","type":"one"}]},{"id":"J","next":[{"outcome":"I","type":"one"}]},{"id":"I","next":[{"outcome":"H","type":"one"}]},{"id":"F","next":[{"outcome":"K","type":"one"}]},{"id":"K","next":[{"outcome":"L","type":"one"}]},{"id":"H","next":[{"outcome":"L","type":"one"}]},{"id":"L","next":[{"outcome":"P","type":"one"}]},{"id":"P","next":[{"outcome":"M","type":"one"},{"outcome":"N","type":"one"}]},{"id":"M","next":[]},{"id":"N","next":[]}]';
const expectBasic = '''
A  │B  │C  │F  │K  │   │L  │P  │M  │
   │B-D│D  │J  │I  │H  │H-L│P-N│N  │
   │B-E│E  │E-J│   │   │   │   │   │
''';
const expectRotated = '''
A  │   │   │
B  │B-D│B-E│
C  │D  │E  │
F  │J  │E-J│
K  │I  │   │
   │H  │   │
L  │H-L│   │
P  │P-N│   │
M  │N  │   │
''';
const presetComplex =
    '[{"id":"A","next":[{"outcome":"B","type":"one"}]},{"id":"U","next":[{"outcome":"G","type":"one"}]},{"id":"B","next":[{"outcome":"C","type":"one"},{"outcome":"D","type":"one"},{"outcome":"E","type":"one"},{"outcome":"F","type":"one"},{"outcome":"M","type":"one"}]},{"id":"C","next":[{"outcome":"G","type":"one"}]},{"id":"D","next":[{"outcome":"H","type":"one"}]},{"id":"E","next":[{"outcome":"H","type":"one"}]},{"id":"F","next":[{"outcome":"W","type":"one"},{"outcome":"N","type":"one"},{"outcome":"O","type":"one"}]},{"id":"W","next":[]},{"id":"N","next":[{"outcome":"I","type":"one"}]},{"id":"O","next":[{"outcome":"P","type":"one"}]},{"id":"P","next":[{"outcome":"I","type":"one"}]},{"id":"M","next":[{"outcome":"L","type":"one"}]},{"id":"G","next":[{"outcome":"I","type":"one"}]},{"id":"H","next":[{"outcome":"J","type":"one"}]},{"id":"I","next":[]},{"id":"J","next":[{"outcome":"K","type":"one"}]},{"id":"K","next":[{"outcome":"L","type":"one"}]},{"id":"L","next":[]}]';

const expectComplex = '''
A  │B  │C  │   │   │   │   │G  │I  │
   │B-D│D  │H  │J  │K  │L  │   │   │
   │B-E│E  │E-H│   │   │   │   │   │
   │B-F│F  │W  │   │   │   │   │   │
   │   │F-N│N  │   │   │   │   │N-I│
   │   │F-O│O  │P  │   │   │   │P-I│
   │B-M│M  │   │   │   │M-L│   │   │
U  │   │   │   │   │   │   │U-G│   │
''';

const expectComplexCentered = '''
   │B-C│C  │   │   │   │   │G  │G-I│
   │B-D│D  │H  │J  │K  │L  │   │   │
A  │B  │E  │E-H│   │   │   │   │   │
   │   │F-W│W  │   │   │   │   │   │
   │B-F│F  │N  │   │   │   │   │I  │
   │   │F-O│O  │P  │   │   │   │P-I│
   │B-M│M  │   │   │   │M-L│   │   │
U  │   │   │   │   │   │   │U-G│   │
''';

void main() {
  test('basic matrix with splits and joins', () {
    List<NodeInput> list = nodeInputFromJson(presetBasic);
    final mtx = listToMatrix(list, false);
    expect(mtx.toString().trim(), expectBasic.trim());
  });
  test('basic matrix rotation', () {
    List<NodeInput> list = nodeInputFromJson(presetBasic);
    final mtx = listToMatrix(list, false);
    final rotated = mtx.rotate();
    expect(mtx.toString().trim(), expectBasic.trim());
    expect(rotated.toString().trim(), expectRotated.trim());
  });
  test('complex matrix with splits and joins', () {
    List<NodeInput> list = nodeInputFromJson(presetComplex);
    final mtx = listToMatrix(list, true);
    expect(mtx.toString().trim(), expectComplexCentered.trim());
    final mtx2 = listToMatrix(list, false);
    expect(mtx2.toString().trim(), expectComplex.trim());
  });
  test('creating graph without matching nodes throws an exception', () {
    List<NodeInput> list = [
      NodeInput(id: '0', next: [EdgeInput(outcome: '1')]),
      NodeInput(id: '1', next: [EdgeInput(outcome: '2')])
    ];
    expect(() => GraphBasic(list: list, centred: false),
        throwsA('node 2 not found'));
  });
}
