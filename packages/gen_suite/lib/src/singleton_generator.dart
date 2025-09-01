/// Generates singleton classes for types annotated with @Singleton.
/// Handles positional, optional positional, named (required/optional), and default values.
library;

import 'dart:async';

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'package:dart_suite/dart_suite.dart' show Singleton;

/// Generator that creates singleton wrapper classes for classes annotated with @Singleton.
///
/// This generator supports:
/// - Classes with no constructor arguments (simple singleton pattern)
/// - Classes with constructor arguments (lazy initialization singleton pattern)
/// - All parameter types: required/optional positional, required/optional named
/// - Constructor selection via annotation parameter
final class SingletonGenerator extends GeneratorForAnnotation<Singleton> {
  const SingletonGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // All type checks and validations
    final classElement = _validateAndCastElement(element);

    // Check for generic classes and warn
    if (classElement.typeParameters2.isNotEmpty) {
      throw InvalidGenerationSourceError(
        'Generic classes are not supported for singleton generation. '
        'Singleton pattern with generics creates type safety issues because '
        'a single static instance cannot work with multiple generic types.',
        element: classElement,
      );
    }

    // Extract configuration (this will throw if constructor is invalid)
    final config = _SingletonConfig.fromElement(classElement, annotation);

    // Generate singleton class
    final singletonClass = _SingletonClassBuilder(config).build();

    // Emit code
    return _generateOutput(singletonClass, buildStep);
  }

  /// Validates that the element is a class and returns it cast to ClassElement2.
  ClassElement2 _validateAndCastElement(Element2 element) {
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        '@Singleton can only be applied to classes.',
        element: element,
      );
    }

    if (!element.isAbstract) {
      throw InvalidGenerationSourceError(
        '@Singleton can only be applied to abstract classes.',
        element: element,
      );
    }

    // My necessary requirements for the class to be a singleton
    // 1. It must have a valid class name
    // 2. It must be private (start with an underscore)
    if (element.name3?.startsWith('_') != true) {
      throw InvalidGenerationSourceError(
        'The class must have a valid name and be private (start with an underscore).',
        element: element,
      );
    }

    return element;
  }

  /// Generates the final output string with header comments.
  String _generateOutput(Class singletonClass, BuildStep buildStep) {
    return '// GENERATED CODE - DO NOT MODIFY BY HAND\n'
        '// Generator: SingletonGenerator\n'
        '// Source: ${buildStep.inputId.path}\n\n'
        '${singletonClass.accept(DartEmitter())}';
  }
}

/// Configuration extracted from the annotated class element.
///
/// Simple explanation:
/// - `baseClassName` is the private class name you wrote (e.g. `_MyClass`).
/// - `publicClassName` is the generated public wrapper name (e.g. `MyClass`).
/// - `constructor` is the selected constructor element (may be null).
/// - `fields` are the constructor parameters converted to `_FieldInfo`.
/// - `classElement` is the base class element for accessing type parameters.
final class _SingletonConfig {
  const _SingletonConfig({
    required this.baseClassName,
    required this.publicClassName,
    required this.constructor,
    required this.fields,
    required this.classElement,
  });

  /// Creates configuration from a class element and annotation.
  factory _SingletonConfig.fromElement(
    ClassElement2 classElement,
    ConstantReader annotation,
  ) {
    final baseClassName = classElement.name3!;
    final publicClassName =
        baseClassName.substring(1); // since, class is privates
    final constructorName = _extractConstructorName(annotation);
    final constructor = _findConstructor(classElement, constructorName);

    final parameters =
        constructor?.formalParameters ?? <FormalParameterElement>[];
    final fields = parameters.map(_FieldInfo.fromParameter).toList();

    return _SingletonConfig(
      baseClassName: baseClassName,
      publicClassName: publicClassName,
      constructor: constructor,
      fields: fields,
      classElement: classElement,
    );
  }
  final String baseClassName;
  final String publicClassName;
  final ConstructorElement2? constructor;
  final List<_FieldInfo> fields;
  final ClassElement2 classElement;

  /// Extracts constructor name from annotation.
  static String? _extractConstructorName(ConstantReader annotation) {
    try {
      return annotation.read('constructorName').stringValue;
    } catch (_) {
      return null;
    }
  }

  /// Finds the specified constructor or the default constructor.
  static ConstructorElement2? _findConstructor(
    ClassElement2 classElement,
    String? constructorName,
  ) {
    final constructors = classElement.constructors2;

    if (constructorName == null || constructorName.isEmpty) {
      // Find unnamed (default) constructor - check for empty name or "new"
      final unnamedConstructors = constructors.where((c) {
        final name = c.name3 ?? '';
        return name.isEmpty || name == 'new';
      });

      if (unnamedConstructors.isEmpty) {
        // For abstract classes without any explicit constructors, treat as having implicit default
        if (constructors.isEmpty) {
          return null; // Implicit default constructor
        }

        // Check if all constructors are private or factory (unsupported cases)
        final hasOnlyPrivateConstructors = constructors.every((c) {
          final name = c.name3 ?? '';
          return name.startsWith('_');
        });

        final hasOnlyFactoryConstructors =
            constructors.every((c) => c.isFactory);

        if (hasOnlyPrivateConstructors) {
          throw InvalidGenerationSourceError(
            'Class ${classElement.name3} only has private constructors. '
            'Singleton generation requires a public constructor that can be extended.',
            element: classElement,
          );
        }

        if (hasOnlyFactoryConstructors) {
          throw InvalidGenerationSourceError(
            'Class ${classElement.name3} only has factory constructors. '
            'Singleton generation requires generative constructors that can be extended.',
            element: classElement,
          );
        }

        // No unnamed constructor found, but we may have other constructors
        throw InvalidGenerationSourceError(
          'No unnamed constructor found in class ${classElement.name3}. '
          'Available constructors: ${constructors.map((c) => c.name3 ?? '<unnamed>').join(', ')}. '
          'Either add an unnamed constructor or specify a constructor name '
          'in the @Singleton annotation.',
          element: classElement,
        );
      }

      return unnamedConstructors.first;
    } else {
      // Find named constructor
      final namedConstructors =
          constructors.where((c) => c.name3 == constructorName);

      if (namedConstructors.isEmpty) {
        throw InvalidGenerationSourceError(
          'Could not find the named constructor "$constructorName" '
          'on class ${classElement.name3}. '
          'Available constructors: ${constructors.map((c) => c.name3 ?? '<unnamed>').join(', ')}.',
          element: classElement,
        );
      }

      final constructor = namedConstructors.first;

      // Check if the named constructor is private
      if (constructorName.startsWith('_')) {
        throw InvalidGenerationSourceError(
          'Private constructor "$constructorName" cannot be used for singleton generation. '
          'Private constructors cannot be extended.',
          element: classElement,
        );
      }

      // Check if it's a factory constructor
      if (constructor.isFactory) {
        throw InvalidGenerationSourceError(
          'Factory constructor "$constructorName" cannot be used for singleton generation. '
          'Only generative constructors can be extended.',
          element: classElement,
        );
      }

      return constructor;
    }
  }

  /// Whether this singleton has constructor parameters.
  bool get hasParameters => fields.isNotEmpty;
}

/// Builds the singleton class using the code_builder package.
///
/// Plain-language summary:
/// This class takes the computed `_SingletonConfig` and emits a Dart
/// `class` declaration that extends the private base class. It will add
/// - a static `_instance` field,
/// - constructors (either simple or parameterized), and
/// - getters to access constructor parameters.
final class _SingletonClassBuilder {
  const _SingletonClassBuilder(this._config);
  final _SingletonConfig _config;

  /// Builds the complete singleton class.
  Class build() {
    final builder = ClassBuilder()
      ..name = _config.publicClassName
      ..extend = refer(_config.baseClassName);

    _addInstanceField(builder);
    _addParameterFields(builder);
    _addInstanceGetter(builder);

    if (_config.hasParameters) {
      _addParameterizedConstructors(builder);
      _addParameterGetters(builder);
    } else {
      _addSimpleConstructors(builder);
    }

    return builder.build();
  }

  /// Adds the static _instance field.
  ///
  /// Note: this field holds the single instance of the generated public
  /// class and is nullable until the singleton is initialized.
  void _addInstanceField(ClassBuilder builder) {
    builder.fields.add(
      Field(
        (b) => b
          ..name = '_instance'
          ..type = refer('${_config.publicClassName}?')
          ..static = true,
      ),
    );
  }

  /// Adds fields for constructor parameters.
  ///
  /// For each constructor parameter we create a private, final backing
  /// field (e.g. `_age`) that stores the value inside the singleton.
  void _addParameterFields(ClassBuilder builder) {
    for (final field in _config.fields) {
      builder.fields.add(
        Field(
          (b) => b
            ..name = field.fieldName
            ..type = refer(field.typeCode)
            ..modifier = FieldModifier.final$,
        ),
      );
    }
  }

  /// Adds the static instance getter 'I'.
  ///
  /// The `I` getter returns the singleton instance or throws a helpful
  /// exception if it wasn't initialized. This mirrors a common `Singleton`
  /// API where the instance is globally available via `MyClass.I`.
  void _addInstanceGetter(ClassBuilder builder) {
    final errorMessage = _config.hasParameters
        ? 'Call ${_config.publicClassName}.init(...) first.'
        : 'Call ${_config.publicClassName}() first.';

    // If has parameters, throw if not initialized and return _instance!
    final bodyCode = _config.hasParameters
        ? "if (_instance == null) { throw Exception('${_config.publicClassName} is not initialized. $errorMessage');} return _instance!;"
        : 'return _instance ??= ${_config.publicClassName}._();';

    builder.methods.add(
      Method(
        (b) => b
          ..name = 'I'
          ..type = MethodType.getter
          ..static = true
          ..returns = refer(_config.publicClassName)
          ..body = Code(bodyCode),
      ),
    );
  }

  /// Adds constructors for simple singleton (no parameters).
  ///
  /// Generates:
  /// - a private unnamed constructor that calls `super(...)`, and
  /// - a factory constructor that lazily initializes `_instance`.
  void _addSimpleConstructors(ClassBuilder builder) {
    final superCall = _buildSimpleSuperCall();

    // Private constructor
    builder.constructors.add(
      Constructor(
        (b) => b
          ..name = '_'
          ..initializers.add(Code(superCall)),
      ),
    );
  }

  /// Adds constructors for parameterized singleton.
  ///
  /// For classes with constructor parameters we generate:
  /// - an internal private constructor `_internal` that accepts the
  ///   parameters and assigns them to private fields, and
  /// - a public `factory init(...)` constructor that forwards args to the
  ///   internal constructor and sets `_instance`.
  void _addParameterizedConstructors(ClassBuilder builder) {
    // Internal constructor
    final internalParams =
        _ParameterBuilder.buildInternalParameters(_config.fields);

    builder.constructors.add(
      Constructor(
        (b) => b
          ..name = '_internal'
          ..requiredParameters.addAll(internalParams.required)
          ..optionalParameters.addAll(internalParams.optional)
          // Assign named constructor params to private fields in the
          // initializer list, and then call super using parameter names.
          ..initializers.addAll(_buildInternalInitializers(_config.fields)),
      ),
    );

    // Factory init constructor - keeping the raw string for now since complex expression
    final factoryParams =
        _ParameterBuilder.buildFactoryParameters(_config.fields);
    final internalArgs = _buildInternalArgs();

    builder.constructors.add(
      Constructor(
        (b) => b
          ..name = 'init'
          ..factory = true
          ..requiredParameters.addAll(factoryParams.required)
          ..optionalParameters.addAll(factoryParams.optional)
          ..body = Code(
            'return _instance ??= ${_config.publicClassName}._internal($internalArgs);',
          ),
      ),
    );
  }

  /// Adds getter methods for constructor parameters.
  ///
  /// Example: if the base constructor had `String model`, we generate
  /// `String get model => _model;` so callers can read the stored value.
  /// Adds getter methods for constructor parameters.
  ///
  /// Example: if the base constructor had `String model`, we generate
  /// `String get model => _model;` so callers can read the stored value.
  void _addParameterGetters(ClassBuilder builder) {
    for (final field in _config.fields) {
      // Use refer() to create a field reference expression
      final fieldReference = refer(field.fieldName);

      builder.methods.add(
        Method(
          (b) => b
            ..name = field.name
            ..type = MethodType.getter
            ..returns = refer(field.typeCode)
            ..body = fieldReference.code,
        ),
      );
    }
  }

  /// Builds super constructor call for simple singleton.
  String _buildSimpleSuperCall() {
    final constructorName = _config.constructor?.name3;
    final baseSuperCall = (constructorName == null || constructorName.isEmpty)
        ? 'super'
        : 'super.$constructorName';

    // If constructor has parameters, we can't call it from simple constructor
    if (_config.hasParameters) {
      throw InvalidGenerationSourceError(
        'Constructor with parameters should be handled by parameterized constructor generation, not simple.',
      );
    }

    return '$baseSuperCall()';
  }

  // ...existing code...

  /// Builds initializer entries for the internal constructor.
  ///
  /// Simple explanation:
  /// - For named parameters we accept a public argument (e.g. `age`) and in
  ///   the initializer list we assign it to the private field (`_age = age`).
  /// - After these assignments we call the superclass constructor using the
  ///   appropriate parameter names so we never reference instance members
  ///   directly in initializer expressions.
  List<Code> _buildInternalInitializers(List<_FieldInfo> fields) {
    final groups = _ParameterGroups.fromFields(fields);
    final initializers = <Code>[];

    for (final f in groups.named) {
      // Assign public named parameter to private backing field: '_age = age'
      initializers.add(Code('${f.fieldName} = ${f.name}'));
    }

    // Build a super call that uses the constructor parameter names (not the
    // private backing fields) so we don't reference instance members in the
    // initializer list.
    final superCall = _buildParameterizedSuperCallForInternal();
    initializers.add(Code(superCall));
    return initializers;
  }

  /// Builds a super constructor call using internal constructor parameter
  /// names (public names for named params, private field names for
  /// positional initializing formals).
  ///
  /// Note: we purposefully forward parameter names (not instance fields)
  /// so the initializer list is valid Dart and does not try to read
  /// instance members during initialization.
  String _buildParameterizedSuperCallForInternal() {
    final constructorName = _config.constructor?.name3;
    final callName = (constructorName == null || constructorName.isEmpty)
        ? 'super'
        : 'super.$constructorName';

    final groups = _ParameterGroups.fromFields(_config.fields);
    final parts = <String>[];

    for (final f in groups.requiredPositional) {
      // required positional internal params use initializing formals named
      // as the private field (this._model), so parameter name is fieldName
      parts.add(f.fieldName);
    }
    for (final f in groups.optionalPositional) {
      parts.add(f.fieldName);
    }

    for (final f in groups.named) {
      // use public parameter name to forward to super
      parts.add('${f.name}: ${f.name}');
    }

    return '$callName(${parts.join(', ')})';
  }

  /// Builds arguments for internal constructor call.
  ///
  /// This is used by the factory `init(...)` to forward its arguments into
  /// the internal constructor. It produces strings like
  /// `model, year, age: age` which are inserted into the generated source.
  String _buildInternalArgs() {
    return _ArgumentBuilder.buildFactoryArgs(_config.fields);
  }
}

/// Utility class for building constructor parameters.
///
/// This helper creates `code_builder` `Parameter` objects for both the
/// internal constructor (which stores values) and the factory constructor
/// (which is the public API). We keep internal params different for named
/// parameters to avoid private named parameter names.
final class _ParameterBuilder {
  const _ParameterBuilder._();

  /// Builds parameters for the internal constructor.
  ///
  /// Important detail: positional parameters use initializing formals
  /// (e.g. `this._model`) which directly set the private field. Named
  /// parameters are declared as public names (e.g. `age`) and later
  /// assigned to private fields in the initializer list to avoid using
  /// private names as named parameter identifiers.
  static _ParameterSet buildInternalParameters(List<_FieldInfo> fields) {
    final groups = _ParameterGroups.fromFields(fields);
    final _ParameterSet value = (required: [], optional: []);

    // Required positional parameters
    for (final field in groups.requiredPositional) {
      value.required.add(
        Parameter(
          (b) => b
            ..name = field.fieldName
            ..toThis = true,
        ),
      );
    }

    // Optional positional parameters
    for (final field in groups.optionalPositional) {
      value.optional.add(
        Parameter(
          (b) => b
            ..name = field.fieldName
            ..toThis = true
            ..type = refer(field.typeCode)
            ..defaultTo = field.defaultValueCode != null
                ? Code(field.defaultValueCode!)
                : null,
        ),
      );
    }

    // Named parameters
    // For named parameters we can't use private parameter names (they're not
    // allowed to start with an underscore). Use the public parameter name for
    // the constructor parameter and perform an assignment to the private
    // backing field in the initializer list of the constructor.
    for (final field in groups.named) {
      value.optional.add(
        Parameter(
          (b) => b
            ..name = field.name
            ..named = true
            ..required = field.isRequiredNamed
            ..type = refer(field.typeCode)
            ..defaultTo =
                (!field.isRequiredNamed && field.defaultValueCode != null)
                    ? Code(field.defaultValueCode!)
                    : null,
        ),
      );
    }

    return value;
  }

  /// Builds parameters for the factory constructor.
  ///
  /// The factory exposes the public API: parameter names match what callers
  /// expect (no leading underscores), and types/defaults are preserved.
  static _ParameterSet buildFactoryParameters(List<_FieldInfo> fields) {
    final groups = _ParameterGroups.fromFields(fields);
    final value = (required: <Parameter>[], optional: <Parameter>[]);

    // Required positional parameters
    for (final field in groups.requiredPositional) {
      value.required.add(
        Parameter(
          (b) => b
            ..name = field.name
            ..type = refer(field.typeCode),
        ),
      );
    }

    // Optional positional parameters
    for (final field in groups.optionalPositional) {
      value.optional.add(
        Parameter(
          (b) => b
            ..name = field.name
            ..type = refer(field.typeCode)
            ..defaultTo = field.defaultValueCode != null
                ? Code(field.defaultValueCode!)
                : null,
        ),
      );
    }

    // Named parameters
    for (final field in groups.named) {
      value.optional.add(
        Parameter(
          (b) => b
            ..name = field.name
            ..type = refer(field.typeCode)
            ..named = true
            ..required = field.isRequiredNamed
            ..defaultTo =
                (!field.isRequiredNamed && field.defaultValueCode != null)
                    ? Code(field.defaultValueCode!)
                    : null,
        ),
      );
    }

    return value;
  }
}

/// Utility class for building constructor arguments.
///
/// Creates the textual argument lists used in generated constructor calls.
final class _ArgumentBuilder {
  const _ArgumentBuilder._();

  /// Builds arguments for super constructor call.
  // (removed) super-arg builder; internal constructor uses a dedicated
  // builder that forwards parameter names instead.

  /// Builds arguments for factory constructor to internal constructor call.
  ///
  /// Produces `String` like `model, year, age: age` so the generated factory
  /// can call `_internal(model, year, age: age)`.
  static String buildFactoryArgs(List<_FieldInfo> fields) {
    final groups = _ParameterGroups.fromFields(fields);
    final parts = <String>[];

    // Factory forwards public parameter names to the internal constructor.
    for (final f in groups.requiredPositional) {
      parts.add(f.name);
    }
    for (final f in groups.optionalPositional) {
      parts.add(f.name);
    }
    for (final f in groups.named) {
      parts.add('${f.name}: ${f.name}');
    }

    return parts.join(', ');
  }
}

/// Groups fields by parameter type for easier processing.
final class _ParameterGroups {
  const _ParameterGroups({
    required this.requiredPositional,
    required this.optionalPositional,
    required this.named,
  });

  factory _ParameterGroups.fromFields(List<_FieldInfo> fields) {
    final requiredPositional = <_FieldInfo>[];
    final optionalPositional = <_FieldInfo>[];
    final named = <_FieldInfo>[];

    for (final field in fields) {
      if (field.isNamed) {
        named.add(field);
      } else if (field.isRequiredPositional) {
        requiredPositional.add(field);
      } else {
        optionalPositional.add(field);
      }
    }
    return _ParameterGroups(
      requiredPositional: requiredPositional,
      optionalPositional: optionalPositional,
      named: named,
    );
  }
  final List<_FieldInfo> requiredPositional;
  final List<_FieldInfo> optionalPositional;
  final List<_FieldInfo> named;
}

/// Container for constructor parameter sets.
typedef _ParameterSet = ({List<Parameter> required, List<Parameter> optional});

/// Information extracted from a constructor parameter.
///
/// Small note:
/// - `name` is the original parameter name from the source constructor.
/// - `fieldName` is the private backing field we generate (with leading
///   underscore). We ensure the private field name is valid even if the
///   original name already started with an underscore.
final class _FieldInfo {
  const _FieldInfo({
    required this.name,
    required this.fieldName,
    required this.typeCode,
    required this.isRequiredPositional,
    required this.isOptionalPositional,
    required this.isNamed,
    required this.isRequiredNamed,
    required this.defaultValueCode,
  });

  /// Creates field info from a formal parameter element.
  factory _FieldInfo.fromParameter(FormalParameterElement parameter) {
    final name = parameter.name3 ?? 'unnamed';
    final fieldName = _toPrivateFieldName(name);
    final typeCode = parameter.type.getDisplayString();

    // Extract default value if available
    String? defaultValueCode;
    if (parameter.defaultValueCode != null &&
        parameter.defaultValueCode!.isNotEmpty) {
      defaultValueCode = parameter.defaultValueCode!;
    }

    return _FieldInfo(
      name: name,
      fieldName: fieldName,
      typeCode: typeCode,
      isRequiredPositional: parameter.isRequiredPositional,
      isOptionalPositional: parameter.isOptionalPositional,
      isNamed: parameter.isNamed,
      isRequiredNamed: parameter.isRequiredNamed,
      defaultValueCode: defaultValueCode,
    );
  }
  final String name;
  final String fieldName;
  final String typeCode;
  final bool isRequiredPositional;
  final bool isOptionalPositional;
  final bool isNamed;
  final bool isRequiredNamed;
  final String? defaultValueCode;

  /// Converts parameter name to private field name.
  static String _toPrivateFieldName(String name) =>
      name.startsWith('_') ? '__$name' : '_$name';
}
