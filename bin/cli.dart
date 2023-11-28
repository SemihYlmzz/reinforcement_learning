import 'dart:math';

import 'package:cli/ml_dataframe.dart';

final actions = ['sol', 'sag'];
final numberOfStates = 6;

final epsilon = 0.9;
final alpha = 0.1;
final gamma = 0.9;

final maxEpisodes = 15;
final freshTimeInMs = 300;

void main() async {
  final dataFrame = DataFrame(
    actions: actions,
    numberOfStates: numberOfStates,
  );
  for (var episode = 0; episode < maxEpisodes; episode++) {
    int currentState = 0;
    bool isTerminal = false;
    
    print('TRY NUMBER $episode');
    updateEnv(currentState);

    while (!isTerminal) {
      await Future.delayed(Duration(milliseconds: freshTimeInMs));
      final action = chooseAction(currentState, dataFrame);
      final envFeedback = getEnvFeedback(currentState, action);
      // ! q_table.iloc değil q_table.loc[S, A]
      final qPredict = dataFrame.getMaxValue(stateNumber: currentState);
      double qTarget;
      if (envFeedback.newState != 100) {
        qTarget = envFeedback.reward +
            gamma * dataFrame.getMaxValue(stateNumber: envFeedback.newState);
      } else {
        qTarget = envFeedback.reward;
        isTerminal = true;
      }
      dataFrame.addValue(
          stateNumber: currentState,
          action: action,
          value: alpha * (qTarget - qPredict));
      currentState = envFeedback.newState;
      updateEnv(currentState);
    }
  }
  dataFrame.printTable();
}

String chooseAction(int state, DataFrame dataFrame) {
  final random = Random();
  if (random.nextDouble() > epsilon) {
    return actions[random.nextInt(2)];
  } else {
    return dataFrame.getMaxValueId(stateNumber: state);
  }
}

({int newState, double reward}) getEnvFeedback(int state, String action) {
  int newState;
  double reward = 0;
  if (action == 'sag') {
    if (state == numberOfStates - 2) {
      newState = 100;
      reward = 1;
    } else {
      newState = state + 1;
      reward = 0.1;
    }
  } else {
    if (state == 0) {
      newState = state;
      reward = -0.2;
    } else {
      newState = state - 1;
      reward = -0.2;
    }
  }
  return (newState: newState, reward: reward);
}

void updateEnv(int state) {
  List<String> envList = ['x', 'x', 'x', 'x', 'x', 'T'];
  if (state == 100) {
    envList.insert(5, 'I');
  } else {
    envList.insert(state, 'I');
  }
  print(envList);
}

// I.....T  -> Başlangıç
// .I....T
// ..I...T
// ...I..T
// ....I.T
// .....IT  -> BAŞARI