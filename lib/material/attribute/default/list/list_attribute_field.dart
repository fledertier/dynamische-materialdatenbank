import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/hover_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListAttributeField extends ConsumerStatefulWidget {
  const ListAttributeField({
    super.key,
    required this.attributePath,
    required this.list,
    this.isRoot = false,
    this.onChanged,
  });

  final AttributePath attributePath;
  final List list;
  final bool isRoot;
  final void Function(List value)? onChanged;

  @override
  ConsumerState<ListAttributeField> createState() => _ListFieldState();
}

class _ListFieldState extends ConsumerState<ListAttributeField> {
  late List list = List.from(widget.list);

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(widget.attributePath)).value;

    if (attribute == null) {
      return SizedBox();
    }

    final listType = attribute.type as ListAttributeType;
    final itemAttribute = listType.attribute;
    final itemAttributePath = widget.attributePath + itemAttribute.id;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 250),
      child: ListView.separated(
        shrinkWrap: list.length < 10,
        itemCount: list.length + edit.toInt(),
        itemBuilder: (context, index) {
          if (index == list.length) {
            return TextButton.icon(
              icon: Icon(Icons.add),
              label: Text(
                itemAttribute.nameDe ??
                    itemAttribute.nameEn ??
                    itemAttribute.type.name.toTitleCase(),
              ),
              onPressed: () {
                addItem(itemAttribute.type);
              },
            );
          }
          return HoverBuilder(
            child: AttributeField(
              attributePath: itemAttributePath,
              value: list.elementAtOrNull(index),
              isRoot: widget.isRoot,
              onChanged: (value) {
                updateItem(index, value);
              },
            ),
            builder: (context, hovered, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: child!),
                  Opacity(
                    opacity: edit && hovered ? 1.0 : 0.0,
                    child: IconButton(
                      visualDensity: VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        removeItem(index);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 4);
        },
      ),
    );
  }

  void addItem(AttributeType itemType) {
    final value = defaultValueForAttributeType(itemType.id);
    setState(() {
      list.add(value);
    });
    widget.onChanged?.call(list);
  }

  void updateItem(int index, dynamic value) {
    list[index] = value;
    widget.onChanged?.call(list);
  }

  void removeItem(int index) {
    setState(() {
      list.removeAt(index);
    });
    widget.onChanged?.call(list);
  }
}
