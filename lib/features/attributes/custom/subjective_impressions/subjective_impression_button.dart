import 'dart:math';

import 'package:dynamische_materialdatenbank/features/attributes/custom/subjective_impressions/ball.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/subjective_impressions/subjective_impression.dart';
import 'package:dynamische_materialdatenbank/shared/widgets/language_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectiveImpressionButton extends ConsumerWidget {
  const SubjectiveImpressionButton({
    super.key,
    required this.ball,
    required this.onUpdate,
    this.edit = false,
  });

  final Ball ball;
  final void Function(SubjectiveImpression? impression) onUpdate;
  final bool edit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final impression = ball.impression;

    if (impression == null) {
      return IconButton.outlined(
        constraints: BoxConstraints.tight(Size.fromRadius(ball.radius)),
        icon: Icon(Icons.add, size: 18),
        onPressed: () => onUpdate(null),
      );
    }

    return FilledButton(
      style: FilledButton.styleFrom(
        foregroundColor: Colors.black,
        disabledForegroundColor: Colors.black,
        backgroundColor: ball.color,
        disabledBackgroundColor: ball.color,
        fixedSize: Size.fromRadius(ball.radius),
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
      onPressed: edit ? () => onUpdate(impression) : null,
      child: Transform.rotate(
        angle: ball.rotation,
        child: Text(
          impression.name.resolve(language) ?? impression.name.value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: sqrt(ball.radius * 3.6)),
        ),
      ),
    );
  }
}
