class SubjectiveImpression {
  SubjectiveImpression({required this.name, required this.count});

  final String name;
  final int count;

  @override
  bool operator ==(Object other) {
    return other is SubjectiveImpression &&
        other.name == name &&
        other.count == count;
  }

  @override
  int get hashCode {
    return Object.hash(name, count);
  }
}
