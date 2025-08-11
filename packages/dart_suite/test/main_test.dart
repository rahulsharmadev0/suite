import 'src/guard_test.dart' as guard_test;
import 'src/string_test.dart' as string_test;
import 'src/timeago_test.dart' as timeago_test;
import 'src/retry_test.dart' as retry_test;
import 'src/debounce_test.dart' as debounce_test;
import 'src/throttle_test.dart' as throttle_test;

void main() {
  guard_test.main();
  string_test.main();
  timeago_test.main();
  retry_test.main();
  debounce_test.main();
  throttle_test.main();
}
