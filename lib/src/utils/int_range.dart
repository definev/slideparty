/// Builds [Iterable] of [int] based on a chosen details
Iterable<int> iterate(
  int from,
  int to,
  int step,
  bool till,
) sync* {
  assert(step >= 0, "Step value must be positive.");
  if (from == to) {
    yield from;
  } else if (from < to) {
    for (int i = from; i <= to - (till ? 1 : 0); i += step) {
      yield i;
    }
  } else {
    for (int i = from; i >= to + (till ? 1 : 0); i -= step) {
      yield i;
    }
  }
}

extension IntRange on int {
  /// Returns [Iterable] of [int] including limit number
  Iterable<int> to(int limit, [int step = 1]) =>
      iterate(this, limit, step, false);

  /// Returns [Iterable] of [int] excluding limit number
  Iterable<int> till(int limit) => [for (int i = this; i < limit; i++) i];

  /// Syntetic ~salt~ sugar for `to()` with step set to one
  Iterable<int> operator [](int limit) => iterate(this, limit, 1, false);
}
