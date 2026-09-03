import 'package:flutter_test/flutter_test.dart';
import 'package:gozgon_life/core/l10n/strings.dart';

void main() {
  test('har bir kalitda 3 ta til (uz, ru, en) bor va bo\'sh emas', () {
    final problems = <String>[];
    kStrings.forEach((key, values) {
      if (values.length < 3) {
        problems.add('$key — faqat ${values.length} ta til');
      } else {
        for (var i = 0; i < 3; i++) {
          if (values[i].trim().isEmpty) {
            problems.add('$key — ${['uz', 'ru', 'en'][i]} bo\'sh');
          }
        }
      }
    });
    expect(problems, isEmpty, reason: problems.join('\n'));
  });
}
