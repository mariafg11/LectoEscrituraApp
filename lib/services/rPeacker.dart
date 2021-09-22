import 'dart:math';

class rPeacker {
  Map options = {
    'vestido': '👗',
    'zapato': '👟',
    'anillo': '💍',
    'cama': '🛌🏿',
    'perro': '🐶',
    'elefante': '🐘',
    'sol': '🌞',
    'manzana': '🍎',
    'pera': '🍐',
    'piña': '🍍',
    'galleta': '🍪',
    'zanahoria': '🥕',
    'helado': '🍦',
    'estrella': '⭐',
    'pez': '🐠',
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
