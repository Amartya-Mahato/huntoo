import 'package:flutter/material.dart';
import 'package:huntoo/providers/planner_history_provider/history_element.dart';

class PlannerHistoryProvider extends ChangeNotifier {
  List<HistoryElement> historyList = [];
  List<HistoryElement> redoList = [];

  bool add({required String name, required Object element}) {
    try {
      historyList.add(HistoryElement(name: name, element: element));
      redoList.clear();
      notifyListeners();
    } catch (e) {
      throw ('could not add as history element');
    }
    return true;
  }

  HistoryElement get(int index) {
    if (historyList.isEmpty) {
      throw ('$index index is out of bound');
    } else {
      return historyList[index];
    }
  }

  void get redo {
    if (redoList.isNotEmpty) {
      historyList.add(redoList.removeLast());
      notifyListeners();
    }
  }

  void get undo {
    if (historyList.isNotEmpty) {
      redoList.add(historyList.removeLast());
      notifyListeners();
    }
  }

  void get clear {
    if (historyList.isNotEmpty) {
      historyList.clear();
      redoList.clear();
      notifyListeners();
    }
  }

  void undoRange(int start, int end) {
    if (historyList.isNotEmpty) {
      for (int i = start; i < end; i++) {
        redoList.add(historyList[i]);
      }
      historyList.removeRange(start, end);
      notifyListeners();
    }
  }
}
