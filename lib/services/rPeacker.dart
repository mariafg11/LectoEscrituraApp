import 'dart:math';

class rPeacker {
  Map options = {
    'vestido': 'π',
    'zapato': 'π',
    'anillo': 'π',
    'cama': 'ππΏ',
    'perro': 'πΆ',
    'elefante': 'π',
    'manzana': 'π',
    'pera': 'π',
    'piΓ±a': 'π',
    'galleta': 'πͺ',
    'zanahoria': 'π₯',
    'helado': 'π¦',
    'estrella': 'β­',
    'mano': 'π€',
    'ojo': 'ποΈ',
    'diente': 'π¦·',
    'pie': 'π¦Ά',
    'boca': 'π',
    'gato': 'π',
    'araΓ±a': 'π·οΈ',
    'sandΓ­a': 'π',
  };

  rPeacker() {
    this.options = options;
  }

  Map randomPeaker(int num) {
    var rand = new Random();
    int i = rand.nextInt(options.length);
    var newMap = new Map<String, String>();
    for (var x = 0; x < num; x++) {
      if (i >= options.length) {
        i = 0;
      }
      newMap[options.keys.elementAt(i)] = options.values.elementAt(i);
      i++;
    }
    return newMap;
  }
}
