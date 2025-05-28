import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'favicon.dart';

class UrlAttributeField extends ConsumerWidget {
  const UrlAttributeField({
    super.key,
    required this.attributeId,
    required this.url,
    this.onChanged,
    this.textStyle,
  });

  final String attributeId;
  final Uri? url;
  final ValueChanged<Uri?>? onChanged;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(attributeId));

    final textTheme = TextTheme.of(context);
    final defaultUrlStyle = textTheme.bodySmall ?? textTheme.titleLarge;

    final textField = TextFormField(
      initialValue: url?.toString(),
      enabled: edit,
      style: (textStyle ?? defaultUrlStyle)?.copyWith(fontFamily: 'Lexend'),
      decoration: InputDecoration.collapsed(hintText: attribute?.name ?? 'Url'),
      onChanged: (value) {
        onChanged?.call(Uri.tryParse(value));
      },
    );

    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (url != null) Favicon(url.toString()),
        IntrinsicWidth(child: textField),
      ],
    );
  }
}
