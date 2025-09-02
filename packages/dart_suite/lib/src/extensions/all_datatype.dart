extension NullableExtension<T> on T? {
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}
