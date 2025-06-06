import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/url/favicon.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UrlAttributeField extends ConsumerStatefulWidget {
  const UrlAttributeField({
    super.key,
    required this.attributePath,
    required this.url,
    this.onChanged,
    this.textStyle,
  });

  final AttributePath attributePath;
  final Uri? url;
  final ValueChanged<Uri?>? onChanged;
  final TextStyle? textStyle;

  @override
  ConsumerState<UrlAttributeField> createState() => _UrlAttributeFieldState();
}

class _UrlAttributeFieldState extends ConsumerState<UrlAttributeField> {
  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(widget.attributePath)).value;

    final textTheme = TextTheme.of(context);
    final defaultUrlStyle = textTheme.bodySmall ?? textTheme.titleLarge;

    final textField = TextFormField(
      initialValue: widget.url?.toString(),
      enabled: edit,
      style: (widget.textStyle ?? defaultUrlStyle)?.copyWith(
        fontFamily: 'Lexend',
      ),
      decoration: InputDecoration.collapsed(hintText: attribute?.name ?? 'Url'),
      onChanged: (value) {
        widget.onChanged?.call(Uri.tryParse(value));
      },
    );

    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.url != null) Favicon(widget.url.toString()),
        IntrinsicWidth(child: textField),
      ],
    );
  }
}
