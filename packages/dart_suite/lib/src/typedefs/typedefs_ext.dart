part of 'typedefs.dart';

// ------------------------------
// 🔧 Extensions
// ------------------------------

/// Extensions for Point2D
extension Point2DExt on Point2D {
  operator -(Point2D other) => (x: x - other.x, y: y - other.y);
  operator +(Point2D other) => (x: x + other.x, y: y + other.y);
  operator *(double factor) => (x: x * factor, y: y * factor);
  operator /(double divisor) => (x: x / divisor, y: y / divisor);
}

/// Extensions for Point3D
extension Point3DExt on Point3D {
  operator -(Point3D other) => (x: x - other.x, y: y - other.y, z: z - other.z);
  operator +(Point3D other) => (x: x + other.x, y: y + other.y, z: z + other.z);
  operator *(double factor) => (x: x * factor, y: y * factor, z: z * factor);
  operator /(double divisor) => (x: x / divisor, y: y / divisor, z: z / divisor);
}

/// Extensions for RGB
extension RGBExt on RGB {
  /// Convert to hex string (e.g., #FF0000)
  String toHexString() {
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }
}

/// Extensions for RGBA
extension RGBAExt on RGBA {
  /// Convert to hex string with alpha (e.g., #FF0000FF)
  String toHexString() {
    final alphaInt = (a * 255).round();
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}${alphaInt.toRadixString(16).padLeft(2, '0')}';
  }
}


/// Extensions for Pagination
extension PaginationExt on Pagination {
  /// Check if there are more pages
  bool get hasNext => totalCount != null && (page * pageSize) < totalCount!;

  /// Total pages (if totalCount is available)
  int? get totalPages => totalCount != null ? (totalCount! / pageSize).ceil() : null;
}

/// Extensions for Pair
extension PairExt<A, B> on Pair<A, B> {
  /// Swap first and second
  Pair<B, A> get swapped => (first: second, second: first);
}

// ------------------------------
// ☕️ Java-like Functional Typedefs Extensions (Behaviour like Java)
// ------------------------------

/// Extensions for Predicate<T>
extension PredicateOps<T> on Predicate<T> {
  /// Logical AND
  Predicate<T> and(Predicate<T> other) => (t) => this(t) && other(t);

  /// Logical OR
  Predicate<T> or(Predicate<T> other) => (t) => this(t) || other(t);

  /// Logical NOT
  Predicate<T> negate() => (t) => !this(t);
}

/// Extensions for Consumer<T>
extension ConsumerOps<T> on Consumer<T> {
  /// Chain two consumers
  Consumer<T> andThen(Consumer<T> after) => (t) {
        this(t);
        after(t);
      };
}

/// Extensions for Supplier<T>
extension SupplierOps<T> on Supplier<T> {
  /// Transform supplier into another type
  Supplier<R> map<R>(R Function(T) mapper) => () => mapper(this());
}

/// Extensions for Comparator<T>
extension ComparatorOps<T> on Comparator<T> {
  /// Reversed comparator
  Comparator<T> reversed() => (a, b) => this(b, a);

  /// ThenComparing (secondary sort)
  Comparator<T> thenComparing(Comparator<T> other) => (a, b) {
        final result = this(a, b);
        return result != 0 ? result : other(a, b);
      };
}
