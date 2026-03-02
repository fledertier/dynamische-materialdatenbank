enum CardSize { small, large }

extension CardSizeComparison on CardSize {
  bool operator >(CardSize other) {
    return index > other.index;
  }

  bool operator <(CardSize other) {
    return index < other.index;
  }
}
