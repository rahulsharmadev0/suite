import 'package:dart_suite/src/optional/optional.dart';
import 'package:glados/glados.dart';
import 'utils/utils.dart';

void main() {
  group('Optional', () {
    group('[Property-based testing]', () {

      group('map', () {
        Glados(any.optionInt).test('should keep the same type (Present or Absent)',
            (option) {
          final r = option.map((id) => id + 1);
          expect(option.isPresent(), r.isPresent());
          expect(option.isAbsent(), r.isAbsent());
        });

        Glados2(any.optionInt, any.int)
            .test('should updated the value inside Present, or stay Absent',
                (option, value) {
          final r = option.map((n) => n + value);
          option.match(
            () {
              expect(option, r);
            },
            (val1) {
              r.matchTestSome((val2) {
                expect(val2, val1 + value);
              });
            },
          );
        });
      });

      group('traverseList', () {
        Glados(any.list(any.int)).test(
            'should keep the same structure and content of the original list',
            (input) {
          final result = Optional.traverseList(input, Optional<int>.of);
          result.matchTestSome((t) {
            expect(t, input);
          });
        });
      });
    });

    test('map', () {
      final option = Optional.of(10);
      final map = option.map((a) => a + 1);
      map.matchTestSome((present) => expect(present, 11));
    });

    test('map2', () {
      final option = Optional.of(10);
      final map =
          option.map2<String, int>(Optional.of('abc'), (a, b) => a + b.length);
      map.matchTestSome((present) => expect(present, 13));
    });

    test('map3', () {
      final option = Optional.of(10);
      final map = option.map3<String, double, double>(
          Optional.of('abc'), Optional.of(2.0), (a, b, c) => (a + b.length) / c);
      map.matchTestSome((present) => expect(present, 6.5));
    });

    group('ap', () {
      test('Present', () {
        final option = Optional.of(10);
        final pure = option.ap(Optional.of((int i) => i + 1));
        pure.matchTestSome((present) => expect(present, 11));
      });

      test('Present (curried)', () {
        final ap = Optional.of((int a) => (int b) => a + b)
            .ap(
              Optional.of((f) => f(3)),
            )
            .ap(
              Optional.of((f) => f(5)),
            );
        ap.matchTestSome((present) => expect(present, 8));
      });

      test('Absent', () {
        final option = Optional<int>.absent();
        final pure = option.ap(Optional.of((int i) => i + 1));
        expect(pure, isA<Absent>());
      });
    });

    group('flatMap', () {
      test('Present', () {
        final option = Optional.of(10);
        final flatMap = option.flatMap<int>((a) => Optional.of(a + 1));
        flatMap.matchTestSome((present) => expect(present, 11));
      });

      test('Absent', () {
        final option = Optional<int>.absent();
        final flatMap = option.flatMap<int>((a) => Optional.of(a + 1));
        expect(flatMap, isA<Absent>());
      });
    });

    group('flatMapNullable', () {
      test('not null', () {
        final option = Optional.of(10);
        final flatMap = option.flatMapNullable((a) => a + 1);
        flatMap.matchTestSome((present) => expect(present, 11));
      });

      test('null', () {
        final option = Optional.of(10);
        final flatMap = option.flatMapNullable<int>((a) => null);
        expect(flatMap, isA<Absent>());
      });
    });

    group('flatMapThrowable', () {
      test('happy path', () {
        final option = Optional.of(10);
        final flatMap = option.flatMapThrowable((a) => a + 1);
        flatMap.matchTestSome((present) => expect(present, 11));
      });

      test('throws', () {
        final option = Optional.of(10);
        final flatMap = option.flatMapThrowable<int>((a) => throw "fail");
        expect(flatMap, isA<Absent>());
      });
    });

    group('extend', () {
      test('Present', () {
        final option = Optional.of(10);
        final value = option.extend((t) => t.isPresent() ? 'valid' : 'invalid');
        value.matchTestSome((present) => expect(present, 'valid'));
      });

      test('Absent', () {
        final option = Optional<int>.absent();
        final value = option.extend((t) => t.isPresent() ? 'valid' : 'invalid');
        expect(value, isA<Absent>());
      });
    });

    group('duplicate', () {
      test('Present', () {
        final option = Optional.of(10);
        final value = option.duplicate();
        value.matchTestSome((present) => expect(present, isA<Present>()));
      });

      test('Absent', () {
        final option = Optional<int>.absent();
        final value = option.duplicate();
        expect(value, isA<Absent>());
      });
    });

    group('filter', () {
      test('Present (true)', () {
        final option = Optional.of(10);
        final value = option.filter((a) => a > 5);
        value.matchTestSome((present) => expect(present, 10));
      });

      test('Present (false)', () {
        final option = Optional.of(10);
        final value = option.filter((a) => a < 5);
        expect(value, isA<Absent>());
      });

      test('Absent', () {
        final option = Optional<int>.absent();
        final value = option.filter((a) => a > 5);
        expect(value, isA<Absent>());
      });
    });

    group('filterMap', () {
      test('Present', () {
        final option = Optional.of(10);
        final value = option.filterMap<String>((a) => Optional.of('$a'));
        value.matchTestSome((present) => expect(present, '10'));
      });

      test('Absent', () {
        final option = Optional<int>.absent();
        final value = option.filterMap<String>((a) => Optional.of('$a'));
        expect(value, isA<Absent>());
      });
    });

    group('partition', () {
      test('Present (true)', () {
        final option = Optional.of(10);
        final value = option.partition((a) => a > 5);
        expect(value.$1, isA<Absent>());
        value.$2.matchTestSome((present) => expect(present, 10));
      });

      test('Present (false)', () {
        final option = Optional.of(10);
        final value = option.partition((a) => a < 5);
        value.$1.matchTestSome((present) => expect(present, 10));
        expect(value.$2, isA<Absent>());
      });

      test('Absent', () {
        final option = Optional<int>.absent();
        final value = option.partition((a) => a > 5);
        expect(value.$1, isA<Absent>());
        expect(value.$2, isA<Absent>());
      });
    });


    group('fromJson', () {
      test('int', () {
        final option = Optional<int>.fromJson(10, (a) => a as int);
        option.matchTestSome((present) => expect(present, 10));
      });

      test('DateTime', () {
        final now = DateTime.now();
        final option = Optional<DateTime>.fromJson(
            now.toIso8601String(), (a) => DateTime.parse(a as String));
        option.matchTestSome((present) => expect(present, now));
      });

      test('DateTime failure', () {
        final option = Optional<DateTime>.fromJson(
            "fail", (a) => DateTime.parse(a as String));
        expect(option, isA<Absent>());
      });

      test('null', () {
        final option = Optional<int>.fromJson(null, (a) => a as int);
        expect(option, isA<Absent>());
      });
    });

    group('fromPredicate', () {
      test('Present', () {
        final option = Optional<int>.fromPredicate(10, (a) => a > 5);
        option.matchTestSome((present) => expect(present, 10));
      });

      test('Absent', () {
        final option = Optional<int>.fromPredicate(10, (a) => a < 5);
        expect(option, isA<Absent>());
      });
    });

    group('fromPredicateMap', () {
      test('Present', () {
        final option =
            Optional.fromPredicateMap<int, String>(10, (a) => a > 5, (a) => '$a');
        option.matchTestSome((present) => expect(present, '10'));
      });

      test('Absent', () {
        final option =
            Optional.fromPredicateMap<int, String>(10, (a) => a < 5, (a) => '$a');
        expect(option, isA<Absent>());
      });
    });

    group('flatten', () {
      test('Right', () {
        final option = Optional.flatten(Optional.of(Optional.of(10)));
        option.matchTestSome((present) => expect(present, 10));
      });

      test('Left', () {
        final option = Optional.flatten(Optional.of(Optional<int>.absent()));
        expect(option, isA<Absent>());
      });
    });

    test('Absent', () {
      final option = Optional<int>.absent();
      expect(option, isA<Absent>());
    });

    test('of', () {
      final option = Optional.of(10);
      option.matchTestSome((present) => expect(present, 10));
    });

    test('isPresent', () {
      final option = Optional.of(10);
      expect(option.isPresent(), true);
      expect(option.isAbsent(), false);
    });

    test('isAbsent', () {
      final option = Optional<int>.absent();
      expect(option.isAbsent(), true);
      expect(option.isPresent(), false);
    });


    test('fromNullable', () {
      final m1 = Optional<int>.fromNullable(10);
      final m2 = Optional<int>.fromNullable(null);
      expect(m1, isA<Present>());
      expect(m2, isA<Absent>());
    });

    test('tryCatch', () {
      final m1 = Optional.tryCatch(() => 10);
      final m2 = Optional.tryCatch(() => throw UnimplementedError());
      expect(m1, isA<Present>());
      expect(m2, isA<Absent>());
    });


    test('toNullable', () {
      final m1 = Optional.of(10);
      final m2 = Optional<int>.absent();
      expect(m1.toNullable(), 10);
      expect(m1.toNullable(), isA<int?>());
      expect(m2.toNullable(), null);
    });

    test('pure', () {
      final m1 = Optional.of(10);
      final m2 = Optional<int>.absent();
      m1.pure('abc').matchTestSome((present) => expect(present, 'abc'));
      m2.pure('abc').matchTestSome((present) => expect(present, 'abc'));
    });

    test('andThen', () {
      final m1 = Optional.of(10);
      final m2 = Optional<int>.absent();
      m1
          .andThen(() => Optional.of('abc'))
          .matchTestSome((present) => expect(present, 'abc'));
      expect(m2.andThen(() => Optional.of('abc')), isA<Absent>());
    });

    test('match', () {
      final m1 = Optional.of(10);
      final m2 = Optional<int>.absent();
      expect(m1.match(() => 'absent', (present) => 'present'), 'present');
      expect(m2.match(() => 'absent', (present) => 'present'), 'absent');
    });

    test('match', () {
      final m1 = Optional.of(10);
      final m2 = Optional<int>.absent();
      expect(m1.fold(() => 'absent', (present) => 'present'), 'present');
      expect(m2.fold(() => 'absent', (present) => 'present'), 'absent');
    });

    test('absent()', () {
      final m = Optional<int>.absent();
      expect(m, isA<Absent>());
    });

    test('of()', () {
      final m = Optional.of(10);
      expect(m, isA<Present<int>>());
    });

    group('toString', () {
      test('Present', () {
        final m = Optional.of(10);
        expect(m.toString(), 'Present(10)');
      });

      test('Absent', () {
        final m = Optional<int>.absent();
        expect(m.toString(), 'Absent');
      });
    });

    group('sequenceList', () {
      test('Present', () {
        final list = [present(1), present(2), present(3), present(4)];
        final result = Optional.sequenceList(list);
        result.matchTestSome((t) {
          expect(t, [1, 2, 3, 4]);
        });
      });

      test('Absent', () {
        final list = [present(1), absent<int>(), present(3), present(4)];
        final result = Optional.sequenceList(list);
        expect(result, isA<Absent>());
      });
    });

    group('traverseList', () {
      test('Present', () {
        final list = [1, 2, 3, 4, 5, 6];
        final result =
            Optional.traverseList<int, String>(list, (a) => present("$a"));
        result.matchTestSome((t) {
          expect(t, ["1", "2", "3", "4", "5", "6"]);
        });
      });

      test('Absent', () {
        final list = [1, 2, 3, 4, 5, 6];
        final result = Optional.traverseList<int, String>(
          list,
          (a) => a % 2 == 0 ? present("$a") : absent(),
        );
        expect(result, isA<Absent>());
      });
    });

    group('traverseListWithIndex', () {
      test('Present', () {
        final list = [1, 2, 3, 4, 5, 6];
        final result = Optional.traverseListWithIndex<int, String>(
            list, (a, i) => present("$a$i"));
        result.matchTestSome((t) {
          expect(t, ["10", "21", "32", "43", "54", "65"]);
        });
      });

      test('Absent', () {
        final list = [1, 2, 3, 4, 5, 6];
        final result = Optional.traverseListWithIndex<int, String>(
          list,
          (a, i) => i % 2 == 0 ? present("$a$i") : absent(),
        );
        expect(result, isA<Absent>());
      });
    });


    test('Present value', () {
      const m = Present(10);
      expect(m.value, 10);
    });

    test('Present == Present', () {
      final m1 = Optional.of(10);
      final m2 = Optional.of(9);
      final m3 = Optional<int>.absent();
      final m4 = Optional.of(10);
      final map1 = <String, Optional>{'m1': m1, 'm2': m4};
      final map2 = <String, Optional>{'m1': m1, 'm2': m2};
      final map3 = <String, Optional>{'m1': m1, 'm2': m4};
      expect(m1, m1);
      expect(m2, m2);
      expect(m1, m4);
      expect(m1 == m2, false);
      expect(m4 == m2, false);
      expect(m1 == m3, false);
      expect(m2 == m3, false);
      expect(map1, map1);
      expect(map1, map3);
      expect(map1 == map2, false);
    });

    test('Absent == Absent', () {
      final m1 = Optional.of(10);
      final m2 = Optional.of(9);
      final m3 = Optional<int>.absent();
      final m4 = Optional<int>.absent();
      final m5 = Optional<String>.absent();
      final map1 = <String, Optional>{'m1': m3, 'm2': m3};
      final map2 = <String, Optional>{'m1': m3, 'm2': m4};
      final map3 = <String, Optional>{'m1': m3, 'm2': m5};
      final map4 = <String, Optional>{'m1': m3, 'm2': m1};
      expect(m3, m3);
      expect(m3, m4);
      expect(m5, m5);
      expect(m3, m5);
      expect(m1 == m3, false);
      expect(m2 == m3, false);
      expect(map1, map1);
      expect(map1, map2);
      expect(map1, map3);
      expect(map1 == map4, false);
    });
  });

  group('Do Notation', () {
    test('should traverse over a list', () async {
      const testOption = const Optional<List<String?>>.of(
        ['/', '/test', null],
      );

      Optional<List<Uri>> doNotation = Optional.Do(
        ($) {
          List<String?> optionList = $(testOption);
          return $(optionList.traverseOption(
            (stringValue) => optionOf(stringValue).flatMap(
              (uri) => optionOf(
                Uri.tryParse(uri),
              ),
            ),
          ));
        },
      );

      expect(doNotation, equals(const Optional<Uri>.absent()));
    });

    test('should return the correct value', () {
      final doOption = Optional.Do((_) => _(Optional.of(10)));
      doOption.matchTestSome((t) {
        expect(t, 10);
      });
    });

    test('should extract the correct values', () {
      final doOption = Optional.Do((_) {
        final a = _(Optional.of(10));
        final b = _(Optional.of(5));
        return a + b;
      });
      doOption.matchTestSome((t) {
        expect(t, 15);
      });
    });

    test('should return Absent if any Optional is Absent', () {
      final doOption = Optional.Do((_) {
        final a = _(Optional.of(10));
        final b = _(Optional.of(5));
        final c = _(Optional<int>.absent());
        return a + b + c;
      });

      expect(doOption, isA<Absent>());
    });

    test('should rethrow if throw is used inside Do', () {
      final doOption = () => Optional.Do((_) {
            _(Optional.of(10));
            throw UnimplementedError();
          });

      expect(doOption, throwsA(const TypeMatcher<UnimplementedError>()));
    });

    test('should rethrow if Absent is thrown inside Do', () {
      final doOption = () => Optional.Do((_) {
            _(Optional.of(10));
            throw Absent();
          });

      expect(doOption, throwsA(const TypeMatcher<Absent>()));
    });

    test('should throw if the error is not Absent', () {
      final doOption = () => Optional.Do((_) {
            _(Optional.of(10));
            throw UnimplementedError();
          });

      expect(doOption, throwsA(const TypeMatcher<UnimplementedError>()));
    });

    test('should no execute past the first Absent', () {
      var mutable = 10;
      final doOptionNone = Optional.Do((_) {
        final a = _(Optional.of(10));
        final b = _(Optional<int>.absent());
        mutable += 10;
        return a + b;
      });

      expect(mutable, 10);
      expect(doOptionNone, isA<Absent>());

      final doOptionSome = Optional.Do((_) {
        final a = _(Optional.of(10));
        mutable += 10;
        return a;
      });

      expect(mutable, 20);
      doOptionSome.matchTestSome((t) {
        expect(t, 10);
      });
    });
  });
}
