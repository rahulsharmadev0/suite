// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'singleton_classes.dart';

// **************************************************************************
// SingletonGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case1 extends _Case1 {
  Case1._() : super.new();

  static Case1? _instance;

  static Case1 get I {
    return _instance ??= Case1._();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case2 extends _Case2 {
  Case2._() : super.new();

  static Case2? _instance;

  static Case2 get I {
    return _instance ??= Case2._();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case3 extends _Case3 {
  Case3._internal(
    this._model,
    this._year,
  ) : super.new(_model, _year);

  factory Case3.init(
    String model,
    int year,
  ) {
    return _instance ??= Case3._internal(model, year);
  }

  static Case3? _instance;

  final String _model;

  final int _year;

  static Case3 get I {
    if (_instance == null) {
      throw Exception('Case3 is not initialized. Call Case3.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case4 extends _Case4 {
  Case4._internal([
    String? this._model,
    int? this._year,
  ]) : super.new(_model, _year);

  factory Case4.init([
    String? model,
    int? year,
  ]) {
    return _instance ??= Case4._internal(model, year);
  }

  static Case4? _instance;

  final String? _model;

  final int? _year;

  static Case4 get I {
    if (_instance == null) {
      throw Exception('Case4 is not initialized. Call Case4.init(...) first.');
    }
    return _instance!;
  }

  String? get model => _model;

  int? get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case5 extends _Case5 {
  Case5._internal([
    String this._model = "Default",
    int this._year = 2024,
  ]) : super.new(_model, _year);

  factory Case5.init([
    String model = "Default",
    int year = 2024,
  ]) {
    return _instance ??= Case5._internal(model, year);
  }

  static Case5? _instance;

  final String _model;

  final int _year;

  static Case5 get I {
    if (_instance == null) {
      throw Exception('Case5 is not initialized. Call Case5.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case6 extends _Case6 {
  Case6._internal({
    String? model,
    int? year,
  })  : _model = model,
        _year = year,
        super.new(model: model, year: year);

  factory Case6.init({
    String? model,
    int? year,
  }) {
    return _instance ??= Case6._internal(model: model, year: year);
  }

  static Case6? _instance;

  final String? _model;

  final int? _year;

  static Case6 get I {
    if (_instance == null) {
      throw Exception('Case6 is not initialized. Call Case6.init(...) first.');
    }
    return _instance!;
  }

  String? get model => _model;

  int? get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case7 extends _Case7 {
  Case7._internal({
    String model = "Default",
    int year = 2024,
  })  : _model = model,
        _year = year,
        super.new(model: model, year: year);

  factory Case7.init({
    String model = "Default",
    int year = 2024,
  }) {
    return _instance ??= Case7._internal(model: model, year: year);
  }

  static Case7? _instance;

  final String _model;

  final int _year;

  static Case7 get I {
    if (_instance == null) {
      throw Exception('Case7 is not initialized. Call Case7.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case8 extends _Case8 {
  Case8._internal({
    required String model,
    required int year,
  })  : _model = model,
        _year = year,
        super.new(model: model, year: year);

  factory Case8.init({
    required String model,
    required int year,
  }) {
    return _instance ??= Case8._internal(model: model, year: year);
  }

  static Case8? _instance;

  final String _model;

  final int _year;

  static Case8 get I {
    if (_instance == null) {
      throw Exception('Case8 is not initialized. Call Case8.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case9 extends _Case9 {
  Case9._internal(
    this._model,
    this._year, {
    int? age,
    String? color,
  })  : _age = age,
        _color = color,
        super.new(_model, _year, age: age, color: color);

  factory Case9.init(
    String model,
    int year, {
    int? age,
    String? color,
  }) {
    return _instance ??= Case9._internal(model, year, age: age, color: color);
  }

  static Case9? _instance;

  final String _model;

  final int _year;

  final int? _age;

  final String? _color;

  static Case9 get I {
    if (_instance == null) {
      throw Exception('Case9 is not initialized. Call Case9.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;

  int? get age => _age;

  String? get color => _color;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case10 extends _Case10 {
  Case10._internal(
    this._model,
    this._year, {
    required int age,
    String color = "Red",
  })  : _age = age,
        _color = color,
        super.new(_model, _year, age: age, color: color);

  factory Case10.init(
    String model,
    int year, {
    required int age,
    String color = "Red",
  }) {
    return _instance ??= Case10._internal(model, year, age: age, color: color);
  }

  static Case10? _instance;

  final String _model;

  final int _year;

  final int _age;

  final String _color;

  static Case10 get I {
    if (_instance == null) {
      throw Exception(
          'Case10 is not initialized. Call Case10.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;

  int get age => _age;

  String get color => _color;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case11 extends _Case11 {
  Case11._() : super.name();

  static Case11? _instance;

  static Case11 get I {
    return _instance ??= Case11._();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case12 extends _Case12 {
  Case12._internal(
    this._model,
    this._year,
  ) : super.name(_model, _year);

  factory Case12.init(
    String model,
    int year,
  ) {
    return _instance ??= Case12._internal(model, year);
  }

  static Case12? _instance;

  final String _model;

  final int _year;

  static Case12 get I {
    if (_instance == null) {
      throw Exception(
          'Case12 is not initialized. Call Case12.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case13 extends _Case13 {
  Case13._internal([
    String? this._model,
    int? this._year,
  ]) : super.name(_model, _year);

  factory Case13.init([
    String? model,
    int? year,
  ]) {
    return _instance ??= Case13._internal(model, year);
  }

  static Case13? _instance;

  final String? _model;

  final int? _year;

  static Case13 get I {
    if (_instance == null) {
      throw Exception(
          'Case13 is not initialized. Call Case13.init(...) first.');
    }
    return _instance!;
  }

  String? get model => _model;

  int? get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case14 extends _Case14 {
  Case14._internal([
    String this._model = "Default",
    int this._year = 2024,
  ]) : super.name(_model, _year);

  factory Case14.init([
    String model = "Default",
    int year = 2024,
  ]) {
    return _instance ??= Case14._internal(model, year);
  }

  static Case14? _instance;

  final String _model;

  final int _year;

  static Case14 get I {
    if (_instance == null) {
      throw Exception(
          'Case14 is not initialized. Call Case14.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case15 extends _Case15 {
  Case15._internal({
    int? age,
    String? color,
  })  : _age = age,
        _color = color,
        super.name(age: age, color: color);

  factory Case15.init({
    int? age,
    String? color,
  }) {
    return _instance ??= Case15._internal(age: age, color: color);
  }

  static Case15? _instance;

  final int? _age;

  final String? _color;

  static Case15 get I {
    if (_instance == null) {
      throw Exception(
          'Case15 is not initialized. Call Case15.init(...) first.');
    }
    return _instance!;
  }

  int? get age => _age;

  String? get color => _color;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case16 extends _Case16 {
  Case16._internal({
    int age = 10,
    String color = "Blue",
  })  : _age = age,
        _color = color,
        super.name(age: age, color: color);

  factory Case16.init({
    int age = 10,
    String color = "Blue",
  }) {
    return _instance ??= Case16._internal(age: age, color: color);
  }

  static Case16? _instance;

  final int _age;

  final String _color;

  static Case16 get I {
    if (_instance == null) {
      throw Exception(
          'Case16 is not initialized. Call Case16.init(...) first.');
    }
    return _instance!;
  }

  int get age => _age;

  String get color => _color;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case17 extends _Case17 {
  Case17._internal({
    required int age,
    required String model,
  })  : _age = age,
        _model = model,
        super.name(age: age, model: model);

  factory Case17.init({
    required int age,
    required String model,
  }) {
    return _instance ??= Case17._internal(age: age, model: model);
  }

  static Case17? _instance;

  final int _age;

  final String _model;

  static Case17 get I {
    if (_instance == null) {
      throw Exception(
          'Case17 is not initialized. Call Case17.init(...) first.');
    }
    return _instance!;
  }

  int get age => _age;

  String get model => _model;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case18 extends _Case18 {
  Case18._internal(
    this._model,
    this._year, {
    int? age,
    String? color = "Red",
  })  : _age = age,
        _color = color,
        super.name(_model, _year, age: age, color: color);

  factory Case18.init(
    String model,
    int year, {
    int? age,
    String? color = "Red",
  }) {
    return _instance ??= Case18._internal(model, year, age: age, color: color);
  }

  static Case18? _instance;

  final String _model;

  final int _year;

  final int? _age;

  final String? _color;

  static Case18 get I {
    if (_instance == null) {
      throw Exception(
          'Case18 is not initialized. Call Case18.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;

  int get year => _year;

  int? get age => _age;

  String? get color => _color;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case19 extends _Case19 {
  Case19._() : super.new();

  static Case19? _instance;

  static Case19 get I {
    return _instance ??= Case19._();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: SingletonGenerator
// Source: test/singleton_classes.dart

class Case22 extends _Case22 {
  Case22._internal(this._model) : super.one(_model);

  factory Case22.init(String model) {
    return _instance ??= Case22._internal(model);
  }

  static Case22? _instance;

  final String _model;

  static Case22 get I {
    if (_instance == null) {
      throw Exception(
          'Case22 is not initialized. Call Case22.init(...) first.');
    }
    return _instance!;
  }

  String get model => _model;
}
