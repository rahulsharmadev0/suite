// Test the generated singletons to verify functionality and instance behavior
import 'package:test/test.dart';
import 'singleton_classes.dart';

void main() {
  group('Comprehensive Singleton Testing', () {
    test('Basic Singleton (Case1)', () {
      final case1a = Case1.I;
      final case1b = Case1.I;
      expect(identical(case1a, case1b), isTrue);
      
      expect(case1a.info, isNotNull);
      expect(case1a.greeting, isNotNull);
      expect(case1a.formatMessage("World"), isNotNull);
      
      case1a.incrementCount();
      expect(case1a.greeting, contains('1'));
      
      case1a.printGreeting(); // Note: printGreeting prints to console, no assertion needed
    });

    test('Singleton with Logging (Case2)', () {
      final case2a = Case2.I;
      final case2b = Case2.I;
      expect(identical(case2a, case2b), isTrue);
      
      case2a.logOperation("Initialize");
      expect(case2a.operationCount, 1);
      
      case2a.logOperation("Process data");
      case2a.logOperation("Cleanup");
      expect(case2a.operationCount, 3);
      expect(case2b.operationCount, 3);
      
      case2a.clearLog();
      expect(case2a.operationCount, 0);
      expect(case2b.operationCount, 0);
    });

    test('Parameterized Singleton (Case3)', () {
      final case3a = Case3.init('Toyota Camry', 1975);
      final case3b = Case3.init('Honda Civic', 2023);
      expect(identical(case3a, case3b), isTrue);
      expect(identical(case3a, Case3.I), isTrue);
      
      expect(Case3.I.model, 'Toyota Camry');
      expect(Case3.I.year, 1975);
      expect(Case3.I.description, isNotNull);
      expect(Case3.I.isVintage, isTrue);
      
      expect(() => Case3.I.validateYear(), returnsNormally);
    });

    test('Optional Parameters (Case4)', () {
      final case4a = Case4.init(null, null);
      final case4b = Case4.init('BMW', 2022);
      expect(identical(case4a, case4b), isTrue);
      
      expect(case4a.model, isNull);
      expect(case4a.year, isNull);
      expect(case4a.displayInfo, isNotNull);
      expect(case4a.hasCompleteInfo, isFalse);
      
      final case4_withParams = Case4.init('Mercedes', 2023);
      expect(identical(case4a, case4_withParams), isTrue);
    });

    test('Required Named Parameters (Case8)', () {
      final case8a = Case8.init(model: 'Tesla Model S', year: 2023);
      final case8b = Case8.init(model: 'BMW i3', year: 2024);
      expect(identical(case8a, case8b), isTrue);
      
      expect(case8a.model, 'Tesla Model S');
      expect(case8a.year, 2023);
      expect(case8a.brandUpper, 'TESLA');
      expect(case8a.isElectric, isTrue);
      
      case8a.updateBrandStats(); // Assuming this updates internal state, no direct assertion
    });

    test('Instance Methods Across Singletons', () {
      final case1 = Case1.I;
      expect(case1.formatMessage("Tester"), isNotNull);
      
      final case2 = Case2.I;
      final oldCount = case2.operationCount;
      case2.logOperation("Method test");
      expect(case2.operationCount, oldCount + 1);
      
      final case3 = Case3.I;
      expect(case3.description, isNotNull);
      expect(case3.isVintage, isA<bool>());
      
      final case8 = Case8.I;
      expect(case8.brandUpper, isNotNull);
      expect(case8.isElectric, isA<bool>());
    });

    test('Singleton Identity Across Multiple Access Patterns', () {
      final case1_1 = Case1.I;
      final case1_2 = Case1.I;
      final case1_3 = Case1.I;
      expect(identical(case1_1, case1_2) && identical(case1_2, case1_3), isTrue);
      
      final case2_1 = Case2.I;
      final case2_2 = Case2.I;
      expect(identical(case2_1, case2_2), isTrue);
      
      final case3_1 = Case3.I;
      final case3_2 = Case3.I;
      expect(identical(case3_1, case3_2), isTrue);
      
      final case8_1 = Case8.I;
      final case8_2 = Case8.I;
      expect(identical(case8_1, case8_2), isTrue);
      
      case1_1.incrementCount();
      expect(case1_2.greeting, contains('1'));
      
      case2_1.logOperation("Identity test");
      expect(case2_2.operationCount, greaterThan(0));
    });
  });
}
