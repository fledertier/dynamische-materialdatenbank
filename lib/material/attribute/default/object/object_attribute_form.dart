import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/attribute_field.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ObjectAttributeForm extends ConsumerStatefulWidget {
  const ObjectAttributeForm({
    super.key,
    required this.attributeId,
    required this.controller,
    this.onSave,
  });

  final String attributeId;
  final ValueNotifier<Json?> controller;
  final void Function(Json? object)? onSave;

  @override
  ConsumerState<ObjectAttributeForm> createState() =>
      ObjectAttributeFormState();
}

class ObjectAttributeFormState extends ConsumerState<ObjectAttributeForm> {
  final _form = GlobalKey<FormState>();
  late final _controller = widget.controller;
  late final _initialController = ValueNotifier(widget.controller.value);

  Json? objectJson;

  @override
  void initState() {
    super.initState();
    getObjectType().then((type) {
      if (type == null) {
        return;
      }
      objectJson = toJson(_controller.value, type);
    });
  }

  @override
  Widget build(BuildContext context) {
    final attribute = ref.watch(attributeProvider(widget.attributeId)).value;

    if (attribute == null) {
      return const SizedBox();
    }

    final objectType = attribute.type as ObjectAttributeType;

    return Form(
      key: _form,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              for (final attribute in objectType.attributes)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    if (attribute.name != null)
                      Text(
                        attribute.name!,
                        style: TextTheme.of(context).labelMedium,
                      ),
                    AttributeField(
                      attributeId: widget.attributeId.add(attribute.id),
                      value: _controller.value?[attribute.id],
                      onChanged: (value) {
                        updateAttribute(attribute, value);
                      },
                      onSave: (value) {
                        updateAttribute(attribute, value);
                        final object = fromJson(objectJson, objectType);
                        widget.onSave?.call(object);
                      },
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  void updateAttribute(Attribute attribute, dynamic value) {
    final json = toJson(value, attribute.type);
    objectJson = {...?objectJson, attribute.id: json};
  }

  bool validate() {
    return _form.currentState!.validate();
  }

  Future<Json?> submit() async {
    final type = await getObjectType();
    if (type == null) {
      return null;
    }
    return fromJson(objectJson, type);
  }

  bool get hasChanges {
    return _controller != _initialController;
  }

  Future<ObjectAttributeType?> getObjectType() async {
    final attribute = await ref.read(
      attributeProvider(widget.attributeId).future,
    );
    return attribute?.type as ObjectAttributeType?;
  }

  @override
  void dispose() {
    _initialController.dispose();
    super.dispose();
  }
}
