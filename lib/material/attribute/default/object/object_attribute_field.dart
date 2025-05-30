import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attribute_field.dart';
import 'object_attribute_dialog.dart';

class ObjectAttributeField extends ConsumerStatefulWidget {
  const ObjectAttributeField({
    super.key,
    required this.attributeId,
    required this.object,
    this.onChanged,
    this.textStyle,
  });

  final String attributeId;
  final Json? object;
  final ValueChanged<Json?>? onChanged;
  final TextStyle? textStyle;

  @override
  ConsumerState<ObjectAttributeField> createState() =>
      _ObjectAttributeFieldState();
}

class _ObjectAttributeFieldState extends ConsumerState<ObjectAttributeField> {
  late var object = widget.object;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final textStyle = (widget.textStyle ?? textTheme.titleLarge!).copyWith(
      fontFamily: 'Lexend',
    );

    final attribute = ref.watch(attributeProvider(widget.attributeId)).value;
    final edit = ref.watch(editModeProvider);

    if (attribute == null) {
      return LoadingText(null, style: textStyle, width: 40);
    }

    final objectType = attribute.type as ObjectAttributeType;
    final firstAttribute = objectType.attributes.firstOrNull;

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        tileColor: ColorScheme.of(context).secondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            firstAttribute != null
                ? IgnorePointer(
                  child: ProviderScope(
                    overrides: [editModeProvider.overrideWith((ref) => false)],
                    child: AttributeField(
                      attributeId: widget.attributeId.add(firstAttribute.id),
                      value: object?[firstAttribute.id],
                    ),
                  ),
                )
                : Text(attribute.name ?? 'Object', style: textStyle),
        onTap:
            edit
                ? () {
                  showObjectAttributeDialog(
                    context: context,
                    attributeId: widget.attributeId,
                    initialObject: object,
                    onSave: (object) {
                      widget.onChanged?.call(object);
                    },
                  );
                }
                : null,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
