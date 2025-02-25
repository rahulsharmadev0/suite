extension NullableExtension<T> on T? {
  /// Define an extension on nullable types, allowing for conditional execution based on whether the value is not null.
  ///
  /// Example:
  /// ```
  ///  void main() {
  ///    int? v1 = 42, v2;
  ///
  ///    var result = v1.ifNotNull(def: null, callback: (_) => '$_');
  ///    var result2 = v2.ifNotNull(def: null, callback: (_) => '$_');
  ///    var result3 = v2.ifNotNull(def: 10.6, callback: (_) => '$_');
  ///
  ///    print(result); // Output: 42
  ///    print(result2); // Output: null
  ///    print(result3); // Output: 10.6
  ///  }
  ///
  /// ```
  ///
  @deprecated
  R ifNotNull<R>({required R def, R Function(T value)? callback}) {
    return this != null && callback != null ? callback(this as T) : def;
  }
}
