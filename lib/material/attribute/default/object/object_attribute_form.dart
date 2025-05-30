import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/attribute_field.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ObjectAttributeForm extends ConsumerStatefulWidget {
  const ObjectAttributeForm({
    super.key,
    required this.attributeId,
    required this.controller,
    required this.onSave,
  });

  final String attributeId;
  final ValueNotifier<Json?> controller;
  final void Function(Json? object) onSave;

  @override
  ConsumerState<ObjectAttributeForm> createState() =>
      ObjectAttributeFormState();
}

class ObjectAttributeFormState extends ConsumerState<ObjectAttributeForm> {
  final _form = GlobalKey<FormState>();
  late final _controller = widget.controller;
  late final _initialController = ValueNotifier(widget.controller.value);

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
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> save() async {
    final attribute = await submit();
    if (attribute != null) {
      widget.onSave(attribute);
    }
  }

  bool get hasChanges {
    return _controller != _initialController;
  }

  Future<Json?> submit() async {
    if (!_form.currentState!.validate()) {
      return null;
    }
    return null; // todo
  }

  @override
  void dispose() {
    _initialController.dispose();
    super.dispose();
  }
}
