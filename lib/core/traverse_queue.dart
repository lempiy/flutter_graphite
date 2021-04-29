import 'package:graphite/core/typings.dart';

class TraverseQueue {
  TraverseQueue() : this.s = [];

  add({
    String? incomeId,
    TraverseQueue? bufferQueue,
    required List<NodeInput> items,
  }) {
    items.forEach((itm) {
      var item = this.find((NodeOutput el) {
        return el.id == itm.id;
      });
      if (item == null && bufferQueue != null) {
        item = bufferQueue.find((NodeOutput el) {
          return el.id == itm.id;
        });
      }
      if (item != null && incomeId != null) {
        item.passedIncomes.add(incomeId);
        return;
      }
      List<String> incomes = incomeId == null ? [] : [incomeId];
      List<String> renderIncomes = incomeId == null ? [] : [incomeId];
      this.s.add(NodeOutput(
            id: itm.id,
            next: itm.next,
            passedIncomes: incomes,
            renderIncomes: renderIncomes,
            childrenOnMatrix: 0,
            isAnchor: false,
          ));
    });
  }

  NodeOutput? find(bool Function(NodeOutput) f) {
    int idx = this.s.indexWhere(f);
    return idx != -1 ? this.s[idx] : null;
  }

  push(NodeOutput item) {
    this.s.add(item);
  }

  int length() {
    return this.s.length;
  }

  bool some(bool Function(NodeOutput) f) {
    return this.s.any(f);
  }

  NodeOutput shift() {
    if (this.s.length == 0) throw 'Queue is empty';
    return this.s.removeAt(0);
  }

  TraverseQueue drain() {
    var queue = TraverseQueue();
    queue.s.addAll(this.s);
    this.s = [];
    return queue;
  }

  List<NodeOutput> s;
}
