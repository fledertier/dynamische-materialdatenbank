import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../debouncer.dart';
import '../../../../widgets/hover_builder.dart';
import '../country/country.dart';
import '../country/country_attribute_field.dart';
import '../text/text_attribute_field.dart';

class ListCard extends ConsumerStatefulWidget {
  const ListCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.textStyle,
    this.columns,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final TextStyle? textStyle;
  final int? columns;

  @override
  ConsumerState<ListCard> createState() => _ListCardState();
}

class _ListCardState extends ConsumerState<ListCard> {
  final debounce = Debouncer(delay: const Duration(milliseconds: 1000));

  int columns(AttributeType type) {
    return widget.columns ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    final list =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: widget.materialId,
                  attributeId: widget.attributeId,
                ),
              ),
            )
            as List? ??
        [];

    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(widget.attributeId));

    if (attribute == null) {
      return SizedBox();
    }

    final type = attribute.type as ListAttributeType;
    final itemAttribute = type.attribute;

    if (itemAttribute == null) {
      return SizedBox();
    }

    final itemAttributeId = attribute.id.add(itemAttribute.id);
    final itemAttributeType = itemAttribute.type;

    Widget buildItem(int index) {
      final value = list.elementAtOrNull(index);

      switch (itemAttributeType.id) {
        case AttributeType.text:
          return TextAttributeField(
            attributeId: itemAttributeId,
            text: value as TranslatableText? ?? TranslatableText(),
            onChanged: (value) {
              updateItem(index, value.toJson());
            },
          );
        case AttributeType.number:
          final number = value as UnitNumber? ?? UnitNumber(value: 0);
          return NumberAttributeField(
            key: ValueKey(number.displayUnit),
            attributeId: itemAttributeId,
            number: number,
            onChanged: (value) {
              updateItem(index, value.toJson());
            },
          );
        case AttributeType.country:
          final country = value as Country?;
          return CountryAttributeField(
            country: country ?? Country.fromCode("de"),
            enabled: edit,
            onChanged: (value) {
              updateItem(index, value?.toJson());
            },
          );
        default:
          debugPrint(
            'ListCard: Unsupported item type ${itemAttributeType.id} for attribute ${widget.attributeId}',
          );
          return Text(value.toString());
      }
    }

    return AttributeCard(
      columns: columns(itemAttributeType),
      label: AttributeLabel(attribute: widget.attributeId),
      title: ConstrainedBox(
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
                      itemAttributeType.name,
                ),
                onPressed: () {
                  addItem(list, itemAttributeType);
                },
              );
            }
            return HoverBuilder(
              child: buildItem(index),
              builder: (context, hovered, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: child!),
                    Opacity(
                      opacity: edit && hovered ? 1.0 : 0.0,
                      child: IconButton(
                        onPressed: () {},
                        visualDensity: VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        icon: Icon(Icons.remove),
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
      ),
    );
  }

  void addItem(List<dynamic> list, AttributeType itemType) {
    final value = switch (itemType.id) {
      AttributeType.text => TranslatableText().toJson(),
      AttributeType.number => UnitNumber(value: 0).toJson(),
      AttributeType.boolean => false,
      AttributeType.url => "",
      AttributeType.country => null,
      _ => null,
    };
    updateItem(list.length, value);
  }

  void updateItem(int index, dynamic value) {
    final list =
        ref.read(
              jsonValueProvider(
                AttributeArgument(
                  materialId: widget.materialId,
                  attributeId: widget.attributeId,
                ),
              ),
            )
            as List? ??
        [];

    if (index < list.length) {
      list[index] = value;
    } else {
      list.add(value);
    }

    ref.read(materialProvider(widget.materialId).notifier).updateMaterial({
      widget.attributeId: list,
    });
  }
}
