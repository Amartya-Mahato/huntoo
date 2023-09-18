import '../../global/enums.dart';

class HistoryElement {
  final String name;
  final HCategory catagory;
  final HAction action;
  final Object element;
  const HistoryElement(
      {required this.name,
      required this.element,
      required this.action,
      required this.catagory});
}
