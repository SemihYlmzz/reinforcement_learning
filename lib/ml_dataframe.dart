import 'dart:math';

class DataFrame {
  DataFrame({required this.actions, required this.numberOfStates}) {
    for (final action in actions) {
      qTable.addAll({
        action: List<double>.filled(numberOfStates, 0.0),
      });
    }
  }
  List<String> actions;
  int numberOfStates;

  String getMaxValueId({required int stateNumber}) {
    List<({double value, int index, String actionName})> maxValueList = [];

    for (var i = 0; i < actions.length; i++) {
      final currentValue = qTable[actions[i]]![stateNumber];
      final isFirst = i == 0;

      if (isFirst) {
        maxValueList.add(
          (
            value: currentValue,
            index: i,
            actionName: actions[i],
          ),
        );
      } else {
        if (maxValueList.first.value < currentValue) {
          maxValueList = [
            (index: i, value: currentValue, actionName: actions[i])
          ];
        } else if (maxValueList.first.value == currentValue) {
          maxValueList.add(
            (
              value: currentValue,
              index: i,
              actionName: actions[i],
            ),
          );
        }
      }
    }

    final random = Random();
    return maxValueList[random.nextInt(maxValueList.length)].actionName;
  }

  double getMaxValue({required int stateNumber}) {
    List<({double value, int index, String actionName})> maxValueList = [];

    for (var i = 0; i < actions.length; i++) {
      final currentValue = qTable[actions[i]]![stateNumber];
      final isFirst = i == 0;

      if (isFirst) {
        maxValueList.add(
          (
            value: currentValue,
            index: i,
            actionName: actions[i],
          ),
        );
      } else {
        if (maxValueList.first.value < currentValue) {
          maxValueList = [
            (index: i, value: currentValue, actionName: actions[i])
          ];
        } else if (maxValueList.first.value == currentValue) {
          maxValueList.add(
            (
              value: currentValue,
              index: i,
              actionName: actions[i],
            ),
          );
        }
      }
    }

    final random = Random();
    return maxValueList[random.nextInt(maxValueList.length)].value;
  }

  Map<String, List<double>> qTable = {};
  void addValue({
    required int stateNumber,
    required String action,
    required double value,
  }) {
    qTable[action]![stateNumber] = qTable[action]![stateNumber] + value;
  }

  void printTable() {
    // Find the maximum length of values for each column
    Map<String, int> columnWidths = {};
    for (final action in actions) {
      int maxWidth = action.length;
      for (double value in qTable[action]!) {
        int valueWidth = value.toString().length;
        if (valueWidth > maxWidth) {
          maxWidth = valueWidth;
        }
      }
      columnWidths[action] = maxWidth;
    }

    // Print header
    String header = ' |';
    for (final action in actions) {
      header += ' ${action.padRight(columnWidths[action]!)} |';
    }
    print(header);

    // Print separator line
    String separator = ' |';
    for (final action in actions) {
      separator += '${'-' * (columnWidths[action]! + 2)}|';
    }
    print(separator);

    // Print rows
    for (int stateNumber = 0; stateNumber < numberOfStates; stateNumber++) {
      String row = ' |';
      for (final action in actions) {
        row +=
            ' ${qTable[action]![stateNumber].toString().padRight(columnWidths[action]!)} |';
      }
      print(row);
    }
  }
}
// {
// sol: 
//[
//-6.561000000000004e-8,
// -0.0033747900955817525, 
// -0.0006100353000000002, 
// -0.02445870157301246, 
// -0.040618063286200004, 
// 0.0
//], 
//sag: [
//0.011031141461803194, 
//0.043691366822960806,
//0.17482585748800789,
//0.4264503961823074,
//0.7941088679053511,
//0.0
//]}
