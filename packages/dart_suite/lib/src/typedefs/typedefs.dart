// typedefs.dart
// ignore_for_file: camel_case_types
part 'typedefs_ext.dart';
// ------------------------------
// 📍 Geometry & Spatial
// ------------------------------

/// 2D coordinate (x, y)
typedef Point2D = ({double x, double y});

/// 3D coordinate (x, y, z)
typedef Point3D = ({double x, double y, double z});

/// Latitude & Longitude
typedef GeoCoordinate = ({double lat, double lng});

/// Latitude, Longitude, Altitude & Accuracy(Optional)
typedef GeoCoordinate3D = ({double lat, double lng, double alt, double? acc});

/// Dimensions in 3D (length, width, height)
typedef Dimension = ({double l, double w, double h});

// ------------------------------
// 🌐 Data Structures
// ------------------------------

/// JSON object with generic values
typedef JSON<T> = Map<String, T>;

/// Key-Value pair (record form)
typedef JSON_1<T> = ({String key, T value});

/// Pair (like Tuple2)
typedef Pair<A, B> = ({A first, B second});

/// Triple (like Tuple3)
typedef Triple<A, B, C> = ({A first, B second, C third});

// ------------------------------
// 🛠 Utility & Domain-Oriented
// ------------------------------

/// Common ID + Name pair (e.g. dropdowns, lookups)
typedef IdName = ({String id, String name});

/// RGB color representation
typedef RGB = ({int r, int g, int b});

/// RGBA color representation (with alpha channel)
typedef RGBA = ({int r, int g, int b, double a});

/// Pagination info (with optional total count)
typedef Pagination = ({int page, int pageSize, int? totalCount});


// ------------------------------
// ☕️ Java-like Functional Typedefs
// ------------------------------

/// Represents a predicate (boolean-valued function) of one argument.
typedef Predicate<T> = bool Function(T t);

/// Represents a predicate (boolean-valued function) of two arguments.
typedef BiPredicate<T, U> = bool Function(T t, U u);

// Represents a function that accepts one argument and produces a result.
// --- IGNORE ---
// typedef Function<T, R> = R Function(T t);

/// Represents a function that accepts two arguments and produces a result.
typedef BiFunction<T, U, R> = R Function(T t, U u);

/// Represents an operation that accepts a single input argument and returns no result.
typedef Consumer<T> = void Function(T t);

/// Represents an operation that accepts two input arguments and returns no result.
typedef BiConsumer<T, U> = void Function(T t, U u);

/// Represents a supplier of results.
typedef Supplier<T> = T Function();

/// Represents an operation on a single operand that produces a result of the same type as its operand.
typedef UnaryOperator<T> = T Function(T operand);

/// Represents an operation upon two operands of the same type, producing a result of the same type as the operands.
typedef BinaryOperator<T> = T Function(T left, T right);

/// Represents a task that can be executed without arguments and returns no result.
typedef Runnable = void Function();

/// Represents a task that can be executed and may throw an exception, returning a result.
typedef Callable<V> = V Function();

/// Represents a comparator, which imposes a total ordering on some collection of objects.
typedef Comparator<T> = int Function(T o1, T o2);

/// Represents a consumer that may throw an error.
typedef ThrowingConsumer<T> = void Function(T t);

/// Represents a supplier that may throw an error.
typedef ThrowingSupplier<T> = T Function();

/// Represents a function that accepts an argument and may throw an error.
typedef ThrowingFunction<T, R> = R Function(T t);