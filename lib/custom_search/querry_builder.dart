import 'package:dynamische_materialdatenbank/custom_search/query_condition.dart';
import 'package:flutter/material.dart';

class QueryBuilder extends StatefulWidget {
  const QueryBuilder({super.key});

  @override
  State<QueryBuilder> createState() => _QueryBuilderState();
}

class _QueryBuilderState extends State<QueryBuilder> {
  final controllers = [WhereClauseController()];

  void addWhereClause() {
    setState(() {
      controllers.add(WhereClauseController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...controllers.map((controller) {
            return WhereClause(
              controller: controller,
            );
          }),
          TextButton(
            onPressed: addWhereClause,
            child: const Text("Add Condition"),
          ),
        ],
      ),
    );
  }
}
