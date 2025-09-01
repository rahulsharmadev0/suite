
# ✨ gen\_suite — Code generation utilities for Dart

**gen\_suite** is a compact, production-ready toolkit for Dart code generation.
It begins with a **singleton generator** and is built to grow with more tools as the `dart_suite` ecosystem expands.

---

## 🚀 Why this package?

* Say goodbye to boilerplate with safe, readable generated code.
* Write small abstract classes → get public APIs automatically.
* Extensible by design: more annotations and generators can be added later.

---

## ⚡ Core features

* **Singleton generator** for private abstract classes:

  * Works with constructors (default, positional, optional, named, with defaults).
  * Preserves parameter shape & defaults.
  * Lazy, static-backed instance creation.
  * Clear error messages for unsupported cases (e.g. generics, private-only).
* Clean generation with `code_builder` + `source_gen`.

---

## 🏃 Quick start

1. Add to `pubspec.yaml`:

   ```yaml
   dependencies:
     dart_suite: ^1.0.0
   dev_dependencies:
     gen_suite: ^1.0.0
     build_runner: ^2.6.0
   ```

2. Create a private abstract class:

   ```dart
   import 'package:dart_suite/dart_suite.dart';

   part 'my_service.g.dart';

   @Singleton()
   abstract class _MyService {
     _MyService(this.apiKey, {this.timeout = 30});
     final String apiKey;
     final int timeout;

     void doWork();
   }
   ```

3. Run generator:

   ```bash
   dart run build_runner build
   ```

4. Use the generated public wrapper (`MyService`) in your app.

---

## 🌱 Extensibility

Not limited to singletons!
Future generators may include factories, adapters, and mappers.

Guidelines for adding new annotations:

* Keep them small and focused.
* Show clear errors for unsupported shapes.
* Always add tests + examples.

---

## ⚙️ Configuration

* Customize with `build.yaml`.
* Use build\_runner flags to control generation scope & formatting.

---

## ✅ Testing & examples

* Run tests: `dart test`
* Generator tests: `dart run build_runner test`
* Check `example/` folder for sample programs.

---

## 🤝 Contribution

1. Open an issue with your idea.
2. Add tests + examples for new generators.
3. Keep APIs stable and document changes in `CHANGELOG.md`.

---

## 📬 Support

* Issues: [GitHub Issues](https://github.com/rahulsharmadev0/suite/issues)
* Discussions: [GitHub Discussions](https://github.com/rahulsharmadev0/suite/discussions)
* Email: [rahulsharmadev0@gmail.com](mailto:rahulsharmadev0@gmail.com)

---

## 📜 License

MIT licensed — see `LICENSE`.

---

## 🙏 Acknowledgements

Thanks to `dart_suite`, `build_runner`, `source_gen`, and contributors for making this toolkit possible.

