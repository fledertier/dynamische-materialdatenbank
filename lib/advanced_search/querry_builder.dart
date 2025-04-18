import 'package:dynamische_materialdatenbank/advanced_search/query_service.dart';
import 'package:dynamische_materialdatenbank/advanced_search/where_clause_controller.dart';
import 'package:dynamische_materialdatenbank/advanced_search/where_clause_widget.dart';
import 'package:dynamische_materialdatenbank/filter/labeled.dart';
import 'package:flutter/material.dart';

class QueryBuilder extends StatefulWidget {
  const QueryBuilder({super.key, this.onExecute});

  final void Function(MaterialQuery query)? onExecute;

  @override
  State<QueryBuilder> createState() => _QueryBuilderState();
}

class _QueryBuilderState extends State<QueryBuilder> {
  final formKey = GlobalKey<FormState>();
  final controllers = [WhereClauseController()];

  void addWhereClause() {
    setState(() {
      controllers.add(WhereClauseController());
    });
  }

  void removeWhereClause(WhereClauseController controller) {
    setState(() {
      controllers.remove(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
              child: WhereClauseWidget(
                key: ValueKey(controller),
                controller: controller,
                onRemove: () => removeWhereClause(controller),
              ),
            ),
          TextButton(
            onPressed: addWhereClause,
            child: const Text("Add Condition"),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final whereClauses =
                    controllers.map((c) => c.toWhereClause()).toList();
                final query = MaterialQuery(whereClauses: whereClauses);
                widget.onExecute?.call(query);
              }
            },
            child: const Text("Ausführen"),
          ),
        ],
      ),
    );
  }
}
