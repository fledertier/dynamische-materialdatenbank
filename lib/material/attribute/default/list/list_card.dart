import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../debouncer.dart';
import '../../../../widgets/hover_builder.dart';
import '../country/country.dart';
import '../country/country_attribute_field.dart';

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
    if (widget.columns != null) {
      return widget.columns!;
    }
    if (type.id == AttributeType.number) {
      return 1;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

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

    final type = attribute?.type as ListAttributeType?;

    if (type == null) {
      return Placeholder();
    }

    final itemType = type.type;

    Widget buildItem(int index) {
      final value = list.elementAtOrNull(index);

      switch (itemType.id) {
        // AttributeType.text => TextAttributeField(
        //   attributeId: ,
        //   text: ,
        //   onChanged: (value) {},
        // ),
        case AttributeType.number:
          final number = value as UnitNumber;
          return NumberAttributeField(
            key: ValueKey(number.displayUnit),
            number: number,
            type: itemType as NumberAttributeType,
            onChanged: (value) {
              updateItem(index, value.toJson());
            },
          );
        case AttributeType.country:
          final country = value as Country;
          return CountryAttributeField(
            country: country,
            enabled: edit,
            onChanged: (value) {},
          );
        default:
          debugPrint(
            'ListCard: Unsupported item type ${itemType.id} for attribute ${widget.attributeId}',
          );
          return Text(value.toString());
      }
    }

    return AttributeCard(
      columns: columns(itemType),
      label: AttributeLabel(attribute: widget.attributeId),
      title: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 250),
        child: ListView.separated(
          shrinkWrap: list.length < 10,
          itemCount: list.length + (edit ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == list.length) {
              return TextButton.icon(
                icon: Icon(Icons.add),
                label: Text(itemType.name),
                onPressed: () {
                  updateItem(list.length, null);
                },
              );
            }
            return HoverBuilder(
              child: buildItem(index),
              builder: (context, hovered, child) {
                if (!edit || !hovered) {
                  return child!;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    child!,
                    IconButton(
                      onPressed: () {},
                      visualDensity: VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      icon: Icon(Icons.remove),
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

  void updateItem(int index, dynamic value) {
    final list =
        ref.read(
              valueProvider(
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
