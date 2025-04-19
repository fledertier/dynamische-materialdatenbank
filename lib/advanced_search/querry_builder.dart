import 'package:dynamische_materialdatenbank/advanced_search/condition_controller.dart';
import 'package:dynamische_materialdatenbank/advanced_search/condition_widget.dart';
import 'package:dynamische_materialdatenbank/advanced_search/query_service.dart';
import 'package:dynamische_materialdatenbank/filter/labeled.dart';
import 'package:flutter/material.dart';

class QueryBuilder extends StatefulWidget {
  const QueryBuilder({super.key, this.initialQuery, this.onQuery});

  final MaterialQuery? initialQuery;
  final void Function(MaterialQuery? query)? onQuery;

  @override
  State<QueryBuilder> createState() => _QueryBuilderState();
}

class _QueryBuilderState extends State<QueryBuilder> {
  final formKey = GlobalKey<FormState>();
  late final List<ConditionController> controllers;

  @override
  void initState() {
    super.initState();
    controllers =
        widget.initialQuery?.conditions
            .map((clause) => ConditionController(clause))
            .toList() ??
        [ConditionController()];
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
      if (controllers.isEmpty) {
        widget.onQuery?.call(null);
      } else {
        final conditions = controllers.map((c) => c.toCondition()).toList();
        final query = MaterialQuery(conditions: conditions);
        widget.onQuery?.call(query);
      }
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
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final controller in controllers)
            Labeled(
              padding: EdgeInsets.zero,
              gap: 4,
              label:
                  controller == controllers.first
                      ? Text("Where")
                      : Text("And where"),
              child: ConditionWidget(
                key: ValueKey(controller),
                controller: controller,
                onRemove: () => removeCondition(controller),
              ),
            ),
          TextButton(
            onPressed: addCondition,
            child: const Text("Add condition"),
          ),
        ],
      ),
    );
  }
}
