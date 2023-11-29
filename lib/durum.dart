import 'package:cli/human_player.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:cli/player.dart';

class Durum {
  List<List<int>> tahta = [];
  HumanPlayer p1;
  Player p2;
  bool bitti = false;
  String? oyunTablosu;
  int oyuncuNumarasi = 1;

  Durum({required this.p1, required this.p2}) {
    tahta = List.generate(3, (i) => List<int>.filled(3, 0));
  }
  String? tabloAl() {
    oyunTablosu = tahta.transpose.toString();
    return oyunTablosu;
  }

  int? kazanan() {
    //bu rowları kontrol eder
    for (var i = 0; i < 3; i++) {
      if (tahta[i][0] + tahta[i][1] + tahta[i][2] == 3) {
        bitti = true;
        return 1;
      }
      if (tahta[i][0] + tahta[i][1] + tahta[i][2] == -3) {
        bitti = true;
        return -1;
      }
      // bu columnları kontrol eder.
      for (var i = 0; i < 3; i++) {
        if (tahta[0][i] + tahta[1][i] + tahta[2][i] == 3) {
          bitti = true;
          return 1;
        }
        if (tahta[0][i] + tahta[1][i] + tahta[2][i] == -3) {
          bitti = true;
          return -1;
        }
      }
    }
    //çapraz kazananı kontrol eder.
    if (tahta[0][0] + tahta[1][1] + tahta[2][2] == 3) {
      bitti = true;
      return 1;
    }
    if (tahta[0][0] + tahta[1][1] + tahta[2][2] == -3) {
      bitti = true;
      return -1;
    }
    if (tahta[0][2] + tahta[1][1] + tahta[2][0] == 3) {
      bitti = true;
      return 1;
    }
    if (tahta[0][2] + tahta[1][1] + tahta[2][0] == -3) {
      bitti = true;
      return -1;
    }
    //beraberlik kontrolu
    if (bosKonumlar().isEmpty) {
      bitti = true;
      return 0;
    }
    bitti = false;
    return null;
  }

  List<({int first, int second})> bosKonumlar() {
    List<({int first, int second})> konumlar = [];
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (tahta[i][j] == 0) {
          konumlar.add((first: i, second: j));
        }
      }
    }
    return konumlar;
  }

  void durumuGuncelle(int first, int second) {
    tahta[first][second] = oyuncuNumarasi;
    oyuncuNumarasi = oyuncuNumarasi == -1 ? 1 : -1;
  }

  void odulVer() {
    int? result = kazanan();
    if (result == 1) {
      p1.feedReward(1);
      p2.feedReward(-1);
    } else if (result == -1) {
      p1.feedReward(-2);
      p2.feedReward(2);
    } else {
      p1.feedReward(0.2); // ! DEGISTIRILDI
      p2.feedReward(0.5); // ! DEGISTIRILDI
    }
  }

  void reset() {
    tahta = List.generate(3, (i) => List<int>.filled(3, 0));
    bitti = false;
    oyunTablosu = null;
    oyuncuNumarasi = 1;
  }

  void play({int rounds = 100}) {
    for (var i = 0; i < rounds; i++) {
      if (i % 1000 == 0) {
        print('Round $i');
      }
      while (!bitti) {
        final konumlar = bosKonumlar();
        final p1Aksiyon = p1.aksiyonSec(konumlar, tahta, oyuncuNumarasi);
        durumuGuncelle(p1Aksiyon.first, p1Aksiyon.second);
        oyunTablosu = tabloAl();
        //! print(oyunTablosu);
        p1.durumEkle(oyunTablosu!);

        final win = kazanan();
        if (win != null) {
          print("p1 kazandı");
          odulVer();
          p1.reset();
          p2.reset();
          reset();
          break;
        } else {
          final konumlar = bosKonumlar();
          final p2Aksiyon = p2.aksiyonSec(konumlar, tahta, oyuncuNumarasi);
          durumuGuncelle(p2Aksiyon.first, p2Aksiyon.second);
          oyunTablosu = tabloAl();
          //! print(oyunTablosu);
          p2.durumEkle(oyunTablosu!);

          final win = kazanan();
          if (win != null) {
            if (win == -1) {
              print('p2 kazandı');
            } else {
              print('beraberlik');
            }
            odulVer();
            p1.reset();
            p2.reset();
            reset();
            break;
          }
        }
      }
    }
  }

  void play2() {
    while (!bitti) {
      final konumlar = bosKonumlar();
      // final yeniTahta = tahta;
      // final oyuncuNum = oyuncuNumarasi;
      final p1Aksiyon = p1.aksiyonSec(konumlar, tahta, oyuncuNumarasi);
      durumuGuncelle(p1Aksiyon.first, p1Aksiyon.second);
      tahtaGoster();
      final win = kazanan();
      if (win != null) {
        if (win == 1) {
          print('${p1.name}kazandı');
        } else {
          print('berabere...');
          reset();
          break;
        }
      } else {
        final konumlar = bosKonumlar();
        final p2Aksiyon = p2.aksiyonSec(konumlar, tahta, oyuncuNumarasi);
        durumuGuncelle(p2Aksiyon.first, p2Aksiyon.second);
        tahtaGoster();
        final win = kazanan();
        if (win != null) {
          if (win == -1) {
            print('${p2.name}kazandı');
          } else {
            print('berabere...');
            reset();
            break;
          }
        }
      }
    }
  }

  void tahtaGoster() {
    print('worked');
    for (var i = 0; i < 3; i++) {
      print("-------------");
      for (int i = 0; i < 3; i++) {
        String out = '| ';
        for (int j = 0; j < 3; j++) {
          String isaret = '';
          if (tahta[i][j] == 1) {
            isaret = 'x';
          } else if (tahta[i][j] == -1) {
            isaret = 'o';
          } else if (tahta[i][j] == 0) {
            isaret = ' ';
          }
          out += '$isaret | ';
        }
        print(out);
      }
      print("-------------");
    }
  }
}
