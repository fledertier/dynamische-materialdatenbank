class TextOrTag<T> {
  TextOrTag.text(String text) : _text = text, _tag = null;

  TextOrTag.tag(T tag) : _text = null, _tag = tag;

  final String? _text;
  final T? _tag;

  String get text => _text!;

  T get tag => _tag!;

  bool get isText => _text != null;

  bool get isTag => _tag != null;
}
