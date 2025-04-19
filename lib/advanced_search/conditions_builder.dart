import 'package:dynamische_materialdatenbank/advanced_search/condition_controller.dart';
import 'package:dynamische_materialdatenbank/advanced_search/condition_widget.dart';
import 'package:flutter/material.dart';

import 'condition.dart';

class ConditionsBuilder extends StatefulWidget {
  const ConditionsBuilder({
    super.key,
    this.initialConditions,
    this.onSubmit,
    this.editable = true,
  });

  final List<Condition>? initialConditions;
  final void Function(List<Condition> conditions)? onSubmit;
  final bool editable;

  @override
  State<ConditionsBuilder> createState() => _ConditionsBuilderState();
}

class _ConditionsBuilderState extends State<ConditionsBuilder> {
  final formKey = GlobalKey<FormState>();
  late final List<ConditionController> controllers;

  @override
  void initState() {
    super.initState();
    controllers =
        widget.initialConditions?.map(ConditionController.new).toList() ?? [];
  }

  void addCondition() {
    setState(() {
      controllers.add(ConditionController());
    });
  }

  void removeCondition(ConditionController controller) {
    setState(() {
      controllers.remove(controller);
    });
  }

  void validateAndBuild() {
    if (formKey.currentState?.validate() ?? false) {
      final conditions = controllers.map((c) => c.toCondition()).toList();
      widget.onSubmit?.call(conditions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        Future.microtask(validateAndBuild);
      },
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final controller in controllers)
            ConditionWidget(
              key: ValueKey(controller),
              enabled: widget.editable,
              controller: controller,
              onRemove: () => removeCondition(controller),
            ),
          if (widget.editable)
            TextButton(
              onPressed: addCondition,
              child: const Text("Add condition"),
            ),
        ],
      ),
    );
  }
}
