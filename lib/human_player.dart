import 'dart:io';

class HumanPlayer {
  String name;

  HumanPlayer({
    required this.name,
  });

  ({int first, int second}) aksiyonSec(
    List<({int first, int second})> konumlar,
    List<List<int>> tahta,
    int oyuncuNumarasi,
  ) {
    while (true) {
      print('satır değerini giriniz: ');
      final satir = int.parse(stdin.readLineSync()!);
      print('Sutun değerini giriniz: ');
      final sutun = int.parse(stdin.readLineSync()!);
      final aksiyon = (first: satir, second: sutun);
      print(tahta);
      return aksiyon;
    }
  }

  void durumEkle(String oyunTablosu) {}
  void feedReward(double reward) {}
  void reset() {}
}
