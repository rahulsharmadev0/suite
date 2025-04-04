List<T> range<T>(int start,
    [int? stop, int step = 1, T Function(int)? generator]) {
  generator ??= (i) => i as T;
  if (stop == null) {
    stop = start;
    start = 0;
  }
  return [for (int i = start; i < stop; i += step) generator(i)];
}
