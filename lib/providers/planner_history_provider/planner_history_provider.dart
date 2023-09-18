import 'package:flutter/material.dart';
import 'package:huntoo/providers/planner_history_provider/history_element.dart';

import '../../global/enums.dart';

class PlannerHistoryProvider extends ChangeNotifier {
  List<HistoryElement> historyList = [];
  List<HistoryElement> redoList = [];

  int get historyLength => historyList.length;
  int get redoLength => redoList.length;

  bool add(
      {required String name,
      required HAction action,
      required Object element,
      required HCategory category}) {
    try {
      historyList.add(HistoryElement(
          name: name, element: element, action: action, catagory: category));
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

  void get removeLast {
    if (historyList.isNotEmpty) {
      historyList.removeLast();
      notifyListeners();
    }
  }

  void get removeFirst {
    if (historyList.isNotEmpty) {
      historyList.removeAt(0);
      notifyListeners();
    }
  }

  HistoryElement? get getLast {
    if (historyList.isNotEmpty) {
      return historyList.last;
    } else {
      return null;
    }
  }

  HistoryElement? get getFirst {
    if (historyList.isNotEmpty) {
      return historyList.first;
    } else {
      return null;
    }
  }

  HistoryElement? get redoGetLast {
    if (redoList.isNotEmpty) {
      return redoList.last;
    } else {
      return null;
    }
  }

  HistoryElement? get redoGetFirst {
    if (redoList.isNotEmpty) {
      return redoList.first;
    } else {
      return null;
    }
  }

  void removeRange({required int start, required int end}) {
    if (historyList.isNotEmpty && start >= 0 && end <= historyList.length) {
      historyList.removeRange(start, end);
      notifyListeners();
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

  void undoRange(int start) {
    if (historyList.isNotEmpty) {
      for (int i = start; i < historyList.length; i++) {
        redoList.add(historyList[i]);
      }
      historyList.removeRange(start, historyList.length);
      notifyListeners();
    }
  }
}
