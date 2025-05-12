import 'package:flutter/widgets.dart';

class TagsController<T> extends ValueNotifier<List<T>> {
  TagsController({List<T>? tags, this.maxNumberOfTags}) : super(tags ?? []);

  final int? maxNumberOfTags;

  List<T> get tags => value;

  set tags(List<T> tags) => value = tags;

  bool maxNumberOfTagsReached([int replaceAmount = 0]) {
    return maxNumberOfTags != null &&
        tags.length - replaceAmount >= maxNumberOfTags!;
  }

  void insert(int index, T tag) {
    tags = List.from(tags)..insert(index, tag);
  }

  void removeAt(int index) {
    tags = List.from(tags)..removeAt(index);
  }

  void removeRange(int start, int end) {
    tags = List.from(tags)..removeRange(start, end);
  }

  void replaceRange(int start, int end, List<T> newTags) {
    tags = List.from(tags)..replaceRange(start, end, newTags);
  }

  void updateWhere(bool Function(T tag) test, T newTag) {
    tags = [
      for (final tag in tags) test(tag) ? newTag : tag,
    ];
  }

  void clear() {
    tags = [];
  }
}
