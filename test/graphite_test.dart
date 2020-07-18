import 'package:flutter_test/flutter_test.dart';
import 'package:graphite/core/typings.dart';
import 'package:graphite/core/graph.dart';


const presetBasic = '[{"id":"A","next":["B"]},{"id":"B","next":["C","D","E"]},{"id":"C","next":["F"]},{"id":"D","next":["J"]},{"id":"E","next":["J"]},{"id":"J","next":["I"]},{"id":"I","next":["H"]},{"id":"F","next":["K"]},{"id":"K","next":["L"]},{"id":"H","next":["L"]},{"id":"L","next":["P"]},{"id":"P","next":["M","N"]},{"id":"M","next":[]},{"id":"N","next":[]}]';
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

void main() {
  test('basic matrix with splits and joins', () {
    List<NodeInput> list = nodeInputFromJson(presetBasic);
    final mtx = listToMatrix(list);
    expect(mtx.toString().trim(), expectBasic.trim());
  });
  test('basic matrix ratation', () {
    List<NodeInput> list = nodeInputFromJson(presetBasic);
    final mtx = listToMatrix(list);
    final rotated = mtx.rotate();
    expect(mtx.toString().trim(), expectBasic.trim());
    expect(rotated.toString().trim(), expectRotated.trim());
  });
}
