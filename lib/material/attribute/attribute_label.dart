import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../attributes/attribute_provider.dart';
import '../../widgets/loading_text.dart';

class AttributeLabel extends ConsumerWidget {
  const AttributeLabel({super.key, required this.attribute});

  final String attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(this.attribute));
    final textTheme = TextTheme.of(context);

    return LoadingText(attribute?.name, style: textTheme.labelMedium);
  }
}
