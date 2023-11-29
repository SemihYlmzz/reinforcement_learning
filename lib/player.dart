import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:matrix2d/matrix2d.dart';

class Player {
  String name;
  double expRate;

  double lr = 0.2;
  double azaltmaKatsayisi = 0.9;
  Map<String, double> statesValue = {};
  List<String> states = [];
  Player({required this.name, this.expRate = 0.3});

  List<List<int>> deepCopy(List<List<int>> original) {
    List<List<int>> copy = [];
    for (List<int> innerList in original) {
      copy.add(List<int>.from(innerList));
    }
    return copy;
  }

  String? tabloAl(List<List<int>> tahta) {
    final oyunTablosu = (tahta.transpose).toString();

    return oyunTablosu;
  }

  ({int first, int second}) aksiyonSec(
    List<({int first, int second})> konumlar,
    List<List<int>> tahta,
    int oyuncuNumarasi,
  ) {
    double value;
    final random = Random();
    late ({int first, int second}) aksiyon;
    if (random.nextDouble() <= expRate) {
      aksiyon = konumlar[random.nextInt(konumlar.length)];
    } else {
      double maxDeger = -999;
      for (final konum in konumlar) {
        List<List<int>> sonrakiTahta = deepCopy(tahta);

        sonrakiTahta[konum.first][konum.second] = oyuncuNumarasi;
        final sonrakiOyunTablosu = tabloAl(sonrakiTahta);
        if (statesValue[sonrakiOyunTablosu] == null) {
          value = 0.0;
        } else {
          value = statesValue[sonrakiOyunTablosu]!; // Şupheli ve önemli
        }
        if (value >= maxDeger) {
          maxDeger = value;
          aksiyon = konum;
        }
      }
    }
    return aksiyon; //şupheli.
  }

  void durumEkle(String oyunTablosu) {
    states.add(oyunTablosu);
  }

  void feedReward(double reward) {
    for (final state in states.reversed) {
      if (statesValue[state] == null) {
        statesValue[state] = 0;
      }
      statesValue[state] = statesValue[state]! +
          lr * (azaltmaKatsayisi * reward - statesValue[state]!); //tehlike
      reward = statesValue[state]!; //tehlike
    }
  }

  void reset() {
    states = [];
  }

  void savePolicy() {
    var file = File('policy_$name');
    var sink = file.openWrite();
    sink.write(jsonEncode(statesValue));
    sink.close();
  }

  void loadPolicy(String file) {
    var fileContent = File(file).readAsStringSync();
    Map<String, dynamic> decodedMap = jsonDecode(fileContent);
    statesValue.addAll(Map<String, double>.from(decodedMap.map((key, value) {
      return MapEntry(key, value.toDouble());
    })));
  }
}
