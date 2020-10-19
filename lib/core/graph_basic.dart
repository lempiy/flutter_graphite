import 'package:meta/meta.dart';
import 'package:graphite/core/typings.dart';

bool isMultiple(Map<String, List<String>> m, String id) {
  return m.containsKey(id) && m[id].length > 1;
}

void addUniqueRelation(Map<String, List<String>> rm, String key, String value) {
  var ok = rm.containsKey(key);
  if (!ok) {
    rm[key] = [value];
  }
  if (!rm[key].contains(value)) {
    rm[key].add(value);
  }
}

class GraphBasic {
  GraphBasic({@required List<NodeInput> list}) {
    this.list = list;
    this.nodesMap = this.list.fold(Map(), (m, node) {
      if (m.containsKey(node.id)) {
        throw 'Duplicate node ${node.id}';
      }
      m[node.id] = node;
      return m;
    });
    this.incomesByNodeIdMap = Map();
    this.outcomesByNodeIdMap = Map();
    this.loopsByNodeIdMap = Map();

    this.detectIncomesAndOutcomes();
  }

  void detectIncomesAndOutcomes() {
    Set<String> totalSet = Set();
    this.list.forEach((node) {
      if (totalSet.contains(node.id)) {
        return;
      }
      Set<String> branchSet = Set();
      this.traverseVertically(node, branchSet, totalSet);
    });
  }

  Set<String> traverseVertically(
      NodeInput node, Set<String> branchSet, Set<String> totalSet) {
    if (branchSet.contains(node.id)) {
      throw 'duplicate incomes for node id ${node.id}';
    }
    branchSet.add(node.id);
    totalSet.add(node.id);
    node.next.forEach((outcomeId) {
      if (this.isLoopEdge(node.id, outcomeId)) {
        return;
      }
      if (branchSet.contains((outcomeId))) {
        addUniqueRelation(this.loopsByNodeIdMap, node.id, outcomeId);
        return;
      }
      addUniqueRelation(incomesByNodeIdMap, outcomeId, node.id);
      addUniqueRelation(outcomesByNodeIdMap, node.id, outcomeId);
      final nextNode = this.nodesMap[outcomeId];
      if (nextNode == null) {
        throw 'node $outcomeId not found';
      }
      totalSet =
          this.traverseVertically(nextNode, Set.from(branchSet), totalSet);
    });
    return totalSet;
  }

  bool isLoopEdge(String nodeId, String outcomeId) {
    if (!this.loopsByNodeIdMap.containsKey(nodeId)) {
      return false;
    }
    return this.loopsByNodeIdMap[nodeId].contains(outcomeId);
  }

  List<NodeInput> roots() {
    return this.list.where((NodeInput node) {
      return this.isRoot(node.id);
    }).toList();
  }

  bool isRoot(String id) {
    return !this.incomesByNodeIdMap.containsKey(id) ||
        this.incomesByNodeIdMap[id].length == 0;
  }

  bool isSplit(String id) {
    return isMultiple(this.outcomesByNodeIdMap, id);
  }

  bool isJoin(String id) {
    return isMultiple(this.incomesByNodeIdMap, id);
  }

  List<String> loops(String id) {
    return this.loopsByNodeIdMap[id];
  }

  List<String> outcomes(String id) {
    return this.outcomesByNodeIdMap[id];
  }

  List<String> incomes(String id) {
    return this.incomesByNodeIdMap[id];
  }

  NodeInput node(String id) {
    return this.nodesMap[id];
  }

  NodeType nodeType(String id) {
    if (isRoot(id) && isSplit(id)) return NodeType.rootSplit;
    if (isRoot(id)) return NodeType.rootSimple;
    if (isSplit(id) && isJoin(id)) return NodeType.splitJoin;
    if (isSplit(id)) return NodeType.split;
    if (isJoin(id)) return NodeType.join;
    return NodeType.simple;
  }

  List<NodeInput> getOutcomesArray(String itemId) {
    List<String> outcomes = this.outcomes(itemId);
    if (outcomes == null || outcomes.length == 0) return [];
    return outcomes.map((String id) {
      return this.node(id);
    }).toList(growable: true);
  }

  List<NodeInput> list;
  Map<String, NodeInput> nodesMap;
  Map<String, List<String>> incomesByNodeIdMap;
  Map<String, List<String>> outcomesByNodeIdMap;
  Map<String, List<String>> loopsByNodeIdMap;
}
