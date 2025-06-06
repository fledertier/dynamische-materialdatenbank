import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/url/url_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/utils/debouncer.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UrlCard extends ConsumerStatefulWidget {
  const UrlCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.textStyle,
    this.columns = 2,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final TextStyle? textStyle;
  final int columns;

  @override
  ConsumerState<UrlCard> createState() => _UrlCardState();
}

class _UrlCardState extends ConsumerState<UrlCard> {
  final debounce = Debouncer(delay: const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    final argument = AttributeArgument(
      materialId: widget.materialId,
      attributePath: AttributePath(widget.attributeId),
    );
    final url = ref.watch(valueProvider(argument)) as Uri?;

    return AttributeCard(
      columns: widget.columns,
      label: AttributeLabel(attributeId: widget.attributeId),
      title: UrlAttributeField(
        attributePath: AttributePath(widget.attributeId),
        url: url,
        onChanged: (url) {
          debounce(() {
            ref
                .read(materialProvider(widget.materialId).notifier)
                .updateMaterial({widget.attributeId: url?.toJson()});
          });
        },
        textStyle: widget.textStyle,
      ),
    );
  }
}
