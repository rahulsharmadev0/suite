import 'package:dart_suite/dart_suite.dart';
import 'package:meta/meta.dart';

/// A mixin that provides a `isValid` method to validate the object.
///
///example:
/// ```
/// class PersonName with ValidatorMixin {
///   final String firstName;
///   final String lastName;
///   final String middleName;
///   const PersonName({
///    required this.firstName,
///    required this.lastName,
///    required this.middleName,
///   });
///
///   @override
///   void validator() {
///     final pattern = regPatterns.name;
///     firstName.regNotMatch(pattern, throwError: true);
///     lastName.regNotMatch(pattern, throwError: true);
///     middleName.regNotMatch(pattern, throwError: true);
///   }
/// }
///
/// void main(List<String> args) {
///   final person = PersonName(firstName: 'John', lastName: 'Doe', middleName: 'Doe');
///   print(person.isValid()); // true
/// }
/// ```
mixin ValidatorMixin {
  /// Returns `true` if the object is valid, otherwise `false`.
  @nonVirtual
  bool isValid([bool reThrow = false, void Function(dynamic)? onError]) {
    return validator.guardSafe(reThrow: reThrow, onError: onError);
  }

  /// Validates the object.
  @protected
  void validator();
}
