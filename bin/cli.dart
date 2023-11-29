import 'package:cli/durum.dart';
import 'package:cli/human_player.dart';
import 'package:cli/player.dart';

void main(List<String> arguments) {
  final p1 = HumanPlayer(name: 'p1');
  //  p1.loadPolicy('policy_p1');
  final p2 = Player(name: 'p2');
  p2.loadPolicy('policy_p2');
  final state = Durum(p1: p1, p2: p2);
  print('Eğitiliyor...');
  state.play2();
  // p1.savePolicy();
  // p2.savePolicy();
}
