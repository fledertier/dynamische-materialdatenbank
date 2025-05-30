import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../attributes/attribute_provider.dart';
import '../../../../attributes/attribute_type.dart';
import '../../../../widgets/hover_builder.dart';
import '../../../edit_mode_button.dart';
import '../attribute_field.dart';
import '../number/unit_number.dart';
import '../text/translatable_text.dart';

class ListField extends ConsumerStatefulWidget {
  const ListField({
    super.key,
    required this.attributeId,
    required this.list,
    this.onChanged,
  });

  final String attributeId;
  final List list;
  final void Function(List list, ListUpdateType update)? onChanged;

  @override
  ConsumerState<ListField> createState() => _ListFieldState();
}

class _ListFieldState extends ConsumerState<ListField> {
  late List list = List.from(widget.list);

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(widget.attributeId)).value;

    if (attribute == null) {
      return SizedBox();
    }

    final listType = attribute.type as ListAttributeType;
    final itemAttribute = listType.attribute;
    final itemAttributeId = widget.attributeId.add(itemAttribute.id);

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
              attributeId: itemAttributeId,
              value: list.elementAtOrNull(index),
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
    final value = switch (itemType.id) {
      AttributeType.text => TranslatableText(),
      AttributeType.number => UnitNumber(value: 0),
      AttributeType.boolean => false,
      AttributeType.url => Uri(),
      AttributeType.country => null,
      _ => null,
    };
    list.add(value);
    widget.onChanged?.call(list, ListUpdateType.add);
  }

  void updateItem(int index, dynamic value) {
    list[index] = value;
    widget.onChanged?.call(list, ListUpdateType.update);
  }

  void removeItem(int index) {
    list.removeAt(index);
    widget.onChanged?.call(list, ListUpdateType.remove);
  }
}

enum ListUpdateType { add, update, remove }
