import 'dart:math';

class Dice {
  static List<String> animations = [
    'Set1',
    'Set2',
    'Set3',
    'Set4',
    'Set5',
    'Set6',
  ];

  static getRandomNumber() {
    var random = Random();
    return random.nextInt(5) + 1;
  }

  static Map<int, String> getRandomAnimation() {
    var random = Random();
    int num = random.nextInt(5);
    Map<int, String> result = {num: animations[num]};

    return result;
  }

  static Future wait3seconds() {
    return new Future.delayed(const Duration(seconds: 3), () {});
  }
}
