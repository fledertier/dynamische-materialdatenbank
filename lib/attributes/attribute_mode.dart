
import 'attribute.dart';

abstract class AttributeMode {
  static const AttributeMode create = CreateAttributeMode();

  static AttributeMode edit(Attribute attribute) {
    return EditAttributeMode(attribute);
  }

  const AttributeMode();
}

class CreateAttributeMode extends AttributeMode {
  const CreateAttributeMode();
}

class EditAttributeMode extends AttributeMode {
  final Attribute attribute;

  const EditAttributeMode(this.attribute);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditAttributeMode) return false;
    return attribute == other.attribute;
  }

  @override
  int get hashCode => attribute.hashCode;
}