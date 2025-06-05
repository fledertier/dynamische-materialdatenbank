import 'package:dynamische_materialdatenbank/widgets/tags_field/tags_controller.dart';

class TagController<T> extends TagsController<T> {
  TagController({T? tag}) : super(maxNumberOfTags: 1) {
    this.tag = tag;
  }

  T? get tag => tags.singleOrNull;

  set tag(T? tag) => tags = tag != null ? [tag] : [];

  @override
  void insert(int index, T tag) {
    this.tag = tag;
  }

  @override
  void removeAt(int index) {
    tag = null;
  }

  @override
  void removeRange(int start, int end) {
    tag = null;
  }

  @override
  void replaceRange(int start, int end, List<T> newTags) {
    tag = newTags.firstOrNull;
  }

  @override
  void updateWhere(bool Function(T tag) test, T newTag) {
    tag = newTag;
  }

  @override
  void clear() {
    tag = null;
  }
}
