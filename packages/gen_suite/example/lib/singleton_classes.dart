import 'package:dart_suite/dart_suite.dart';

part 'singleton_classes.g.dart';

// ====================================================
// 1. No constructor (implicit default)
// ====================================================
@Singleton()
abstract class _Case1 {}

// ====================================================
// 2. Default constructor (no args)
// ====================================================
@Singleton()
abstract class _Case2 {
  const _Case2();
}

// ====================================================
// 3. Default constructor with positional args
// ====================================================
@Singleton()
abstract class _Case3 {
  const _Case3(String model, int year);
}

// ====================================================
// 4. Default constructor with optional positional args
// ====================================================
@Singleton()
abstract class _Case4 {
  const _Case4([String? model, int? year]);
}

// ====================================================
// 5. Default constructor with optional positional args + defaults
// ====================================================
@Singleton()
abstract class _Case5 {
  const _Case5([String model = "Default", int year = 2024]);
}

// ====================================================
// 6. Default constructor with named optional args
// ====================================================
@Singleton()
abstract class _Case6 {
  const _Case6({String? model, int? year});
}

// ====================================================
// 7. Default constructor with named optional args + defaults
// ====================================================
@Singleton()
abstract class _Case7 {
  const _Case7({String model = "Default", int year = 2024});
}

// ====================================================
// 8. Default constructor with required named args
// ====================================================
@Singleton()
abstract class _Case8 {
  const _Case8({required String model, required int year});
}

// ====================================================
// 9. Mixed positional + optional named args
// ====================================================
@Singleton()
abstract class _Case9 {
  const _Case9(String model, int year, {int? age, String? color});
}

// ====================================================
// 10. Mixed positional + named args with defaults + required
// ====================================================
@Singleton()
abstract class _Case10 {
  const _Case10(String model, int year, {required int age, String color = "Red"});
}

// ====================================================
// 11. Named constructor (no args)
// ====================================================
@Singleton('name')
abstract class _Case11 {
  const _Case11.name();
}

// ====================================================
// 12. Named constructor with positional args
// ====================================================
@Singleton('name')
abstract class _Case12 {
  const _Case12.name(String model, int year);
}

// ====================================================
// 13. Named constructor with optional positional args
// ====================================================
@Singleton('name')
abstract class _Case13 {
  const _Case13.name([String? model, int? year]);
}

// ====================================================
// 14. Named constructor with optional positional + defaults
// ====================================================
@Singleton('name')
abstract class _Case14 {
  const _Case14.name([String model = "Default", int year = 2024]);
}

// ====================================================
// 15. Named constructor with named optional args
// ====================================================
@Singleton('name')
abstract class _Case15 {
  const _Case15.name({int? age, String? color});
}

// ====================================================
// 16. Named constructor with named optional args + defaults
// ====================================================
@Singleton('name')
abstract class _Case16 {
  const _Case16.name({int age = 10, String color = "Blue"});
}

// ====================================================
// 17. Named constructor with required named args
// ====================================================
@Singleton('name')
abstract class _Case17 {
  const _Case17.name({required int age, required String model});
}

// ====================================================
// 18. Named constructor with mixed args
// ====================================================
@Singleton('name')
abstract class _Case18 {
  const _Case18.name(String model, int year, {int? age, String? color = "Red"});
}

// ====================================================
// 19. Multiple constructors (default + named)
// ====================================================
@Singleton()
abstract class _Case19 {
  const _Case19();
  const _Case19.named(String model);
}

// ====================================================
// 20. Private constructor
// ====================================================
@Singleton()
abstract class _Case20 {
  const _Case20._(String model, int year);
}

// ====================================================
// 21. Factory constructor (redirecting)
// ====================================================
@Singleton()
abstract class _Case21 {
  factory _Case21(String model) = _Case21Impl;
}
class _Case21Impl implements _Case21 {
  const _Case21Impl(this.model);
  final String model;
}

// ====================================================
// 22. Const + multiple named constructors
// ====================================================
@Singleton('one')
abstract class _Case22 {
  const _Case22.one(String model);
  const _Case22.two(String model, int year, {int age = 18});
}

// ====================================================
// 23. Const with generic type
// ====================================================
@Singleton()
abstract class _Case23<T> {
  const _Case23({required T value});
}
