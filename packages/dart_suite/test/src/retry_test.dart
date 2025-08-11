// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:test/test.dart';
import 'package:dart_suite/dart_suite.dart';

void main() {
  group('Retry', () {
    test('retry (success)', () async {
      var count = 0;

      final f = retry(() {
        count++;
        return true;
      });
      expect(f, completion(isTrue));
      expect(count, equals(1));
    });

    test('retry (unhandled exception)', () async {
      var count = 0;

      final f = retry(
        () {
          count++;
          throw Exception('Retry will fail');
        },
        retryIf: (e) => false,
        maxAttempts: 5,
      );
      await expectLater(f, throwsA(isException));
      expect(count, equals(1));
    });

    test('retry (retryIf, exhaust retries)', () async {
      var count = 0;
      final f = retry(
        () {
          count++;
          throw FormatException('Retry will fail');
        },
        retryIf: (e) => e is FormatException,
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      await expectLater(f, throwsA(isFormatException));
      expect(count, equals(5));
    });

    test('retry (success after 2)', () async {
      var count = 0;

      final f = retry(
        () {
          count++;
          if (count == 1) {
            throw FormatException('Retry will be okay');
          }
          return true;
        },
        retryIf: (e) => e is FormatException,
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      await expectLater(f, completion(isTrue));
      expect(count, equals(2));
    });

    test('retry (no retryIf)', () async {
      var count = 0;
      final f = retry(
        () {
          count++;
          if (count == 1) {
            throw FormatException('Retry will be okay');
          }
          return true;
        },
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      await expectLater(f, completion(isTrue));
      expect(count, equals(2));
    });

    test('retry (unhandled on 2nd try)', () async {
      var count = 0;
      final f = retry(() {
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        throw Exception('unhandled thing');
      },
          retryIf: (e) => e is FormatException,
          maxAttempts: 5,
          maxDelay: Duration());
      await expectLater(f, throwsA(isException));
      expect(count, equals(2));
    });
  });
}
