import 'package:graphite/core/graph_matrix.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/core/traverse_queue.dart';
import 'package:graphite/core/typings.dart';

const MaxIterations = 1000;

class Graph extends GraphMatrix {
  Graph({required List<NodeInput> list}) : super(list: list);

  void handleSplitNode(NodeOutput item, State state, TraverseQueue levelQueue) {
    bool isInserted = processOrSkipNodeOnMatrix(item, state);
    if (isInserted) {
      insertSplitOutcomes(item, state, levelQueue);
    }
  }

  void handleSplitJoinNode(
      NodeOutput item, State state, TraverseQueue levelQueue) {
    var queue = state.queue, mtx = state.mtx;
    if (joinHasUnresolvedIncomes(item)) {
      queue.push(item);
      return;
    }
    resolveCurrentJoinIncomes(mtx, item);
    bool isInserted = processOrSkipNodeOnMatrix(item, state);
    if (isInserted) {
      insertJoinIncomes(item, state, levelQueue, false);
      insertSplitOutcomes(item, state, levelQueue);
    }
  }

  void handleJoinNode(NodeOutput item, State state, TraverseQueue levelQueue) {
    var queue = state.queue, mtx = state.mtx;
    if (joinHasUnresolvedIncomes(item)) {
      queue.push(item);
      return;
    }
    resolveCurrentJoinIncomes(mtx, item);
    bool isInserted = processOrSkipNodeOnMatrix(item, state);
    if (isInserted) {
      insertJoinIncomes(item, state, levelQueue, true);
    }
  }

  void handleSimpleNode(
      NodeOutput item, State state, TraverseQueue levelQueue) {
    var queue = state.queue;
    bool isInserted = processOrSkipNodeOnMatrix(item, state);
    if (isInserted) {
      queue.add(
          incomeId: item.id,
          bufferQueue: levelQueue,
          items: getOutcomesArray(item.id));
    }
  }

  void traverseItem(NodeOutput item, State state, TraverseQueue levelQueue) {
    var mtx = state.mtx;
    switch (nodeType(item.id)) {
      case NodeType.rootSimple:
        state.y = mtx.getFreeRowForColumn(0);
        continue simple;
      simple:
      case NodeType.simple:
        handleSimpleNode(item, state, levelQueue);
        break;
      case NodeType.rootSplit:
        state.y = mtx.getFreeRowForColumn(0);
        continue split;
      split:
      case NodeType.split:
        handleSplitNode(item, state, levelQueue);
        break;
      case NodeType.join:
        handleJoinNode(item, state, levelQueue);
        break;
      case NodeType.splitJoin:
        handleSplitJoinNode(item, state, levelQueue);
        break;
      default:
        throw "Unknown node type ${nodeType(item.id)}";
    }
  }

  int traverseLevel(int iterations, State state) {
    var queue = state.queue;
    var levelQueue = queue.drain();
    while (levelQueue.length() != 0) {
      iterations++;
      NodeOutput item = levelQueue.shift();
      traverseItem(item, state, levelQueue);
      if (iterations > MaxIterations) {
        throw "max iterations reached";
      }
    }
    return iterations;
  }

  Matrix traverseList(State state) {
    var safe = 0, mtx = state.mtx, queue = state.queue;
    while (queue.length() != 0) {
      safe = traverseLevel(safe, state);
      state.x++;
    }
    return mtx;
  }

  Matrix traverse() {
    var roots = this.roots();
    State state = State(mtx: Matrix(), queue: TraverseQueue(), x: 0, y: 0);
    if (roots.length == 0) {
      throw "no graph roots found";
    }
    var mtx = state.mtx, queue = state.queue;
    queue.add(incomeId: null, bufferQueue: null, items: roots);
    mtx = traverseList(state);
    return mtx;
  }
}

Matrix listToMatrix(List<NodeInput> list) {
  Graph g = Graph(list: list);
  return g.traverse();
}
