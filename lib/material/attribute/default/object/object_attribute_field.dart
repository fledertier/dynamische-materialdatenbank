import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/object/object_attribute_dialog.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ObjectAttributeField extends ConsumerStatefulWidget {
  const ObjectAttributeField({
    super.key,
    required this.attributePath,
    required this.object,
    this.isRoot = false,
    this.onChanged,
    this.onSave,
    this.textStyle,
  });

  final AttributePath attributePath;
  final Json? object;
  final bool isRoot;
  final ValueChanged<Json?>? onChanged;
  final ValueChanged<Json?>? onSave;
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

    final attribute = ref.watch(attributeProvider(widget.attributePath)).value;
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
                      attributePath: widget.attributePath + firstAttribute.id,
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
                    attributePath: widget.attributePath,
                    initialObject: object,
                    isRoot: widget.isRoot,
                    onSave: (object) {
                      setState(() {
                        this.object = object;
                      });
                      widget.onSave?.call(object);
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
