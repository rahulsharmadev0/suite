
import 'package:dart_suite/src/optional/optional.dart';
import 'package:test/test.dart';

extension OptionMatch<T> on Optional<T> {
  /// Run test on [Present], call `fail` if [Absent].
  void matchTestSome(void Function(T t) testing) => match(() {
        fail("should be some, found none");
      }, testing);
}


