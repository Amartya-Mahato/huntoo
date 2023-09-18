
import 'dart:math';

String getRandomStr(int length){
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890@#%&_!-/';
    Random r = Random();
    return String.fromCharCodes(Iterable.generate(
    length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}