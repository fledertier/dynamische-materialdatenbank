import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributeLabel extends ConsumerWidget {
  const AttributeLabel({super.key, required this.attributeId});

  final String attributeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(attributeId)).value;
    final textTheme = TextTheme.of(context);

    return LoadingText(attribute?.name, style: textTheme.labelMedium);
  }
}
