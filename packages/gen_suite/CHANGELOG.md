# Changelog

## [0.0.1] - 2025-09-02

### Added
- Initial release of gen_suite: Code generation for singleton wrappers on abstract classes with `@Singleton()` annotation.
- Supports all constructor types: no params, positional/optional/named params, mixed types, named constructors.
- Type-safe generation using `code_builder` and `source_gen`.
- Error handling, build integration with `build_runner`, full test coverage.

### Features
- Smart constructor selection, parameter preservation, lazy initialization, thread-safety, clean code.

### Supported Use Cases
- All standard constructor scenarios (no private/factory constructors).

### Limitations
- No support for private/factory constructors or generic classes.

### Dependencies
- `dart_suite`, `code_builder`, `analyzer`, `build`, `source_gen`.
