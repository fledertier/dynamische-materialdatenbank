import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dynamische_materialdatenbank/query/query_converters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';
import '../constants.dart';
import '../types.dart';
import 'condition_group.dart';

final queryServiceProvider = Provider((ref) => QueryService());

class QueryService {
  Future<ConditionGroup?> generateQuery({
    required List<Attribute> attributes,
    required List<AttributeType> types,
    required String prompt,
  }) async {
    final answer = await _answerPrompt(prompt, attributes, types);
    final result = _parseAnswer(answer);
    if (result == null) {
      return null;
    }
    return _parseQuery(result.query);
  }

  Future<String?> _answerPrompt(
    String prompt,
    List<Attribute> attributes,
    List<AttributeType> types,
  ) async {
    // return exampleAnswer;

    final result = await FirebaseFunctions.instanceFor(
      region: region,
    ).httpsCallable(Functions.chat).call({
      "prompt": prompt,
      "attributes":
          attributes.map((attribute) {
            return {"id": attribute.id, "type": attribute.type.name};
          }).toList(),
      "types":
          types.map((type) {
            return {
              "id": type.id,
              "operators":
                  type.operators.map((operator) => operator.name).toList(),
            };
          }).toList(),
    });

    return result.data as String?;
  }

  QueryResult? _parseAnswer(String? answer) {
    if (answer == null) {
      return null;
    }

    final pattern = RegExp(r"([^`]*)```([^`]*)```");
    final match = pattern.firstMatch(answer);

    if (match == null) {
      return null;
    }

    final plan = match.group(1)?.trim();
    final query = match.group(2)?.trim();

    if (query == null || query.isEmpty) {
      return null;
    }

    return QueryResult(plan: plan, query: query);
  }

  ConditionGroup? _parseQuery(String string) {
    final json = jsonDecode(string) as Json?;
    return ConditionGroupConverter.maybeFromJson(json);
  }
}

class QueryResult {
  final String? plan;
  final String query;

  const QueryResult({this.plan, required this.query});
}

const exampleAnswer = """
Plan:
1. Identifizieren des Attributs, das mit dem Suchbegriff "holz" übereinstimmt.
2. Da "holz" ein allgemeiner Begriff ist, kann er in verschiedenen Attributen vorkommen, aber am wahrscheinlichsten ist er in "description" oder "name" enthalten.
3. Da wir nicht genau wissen, wo "holz" vorkommen könnte, verwenden wir den Operator "contains" für beide Attribute.

```
{
  "type": "or",
  "nodes": [
    {
      "attribute": "description",
      "operator": "contains",
      "parameter": "holz"
    },
    {
      "attribute": "name",
      "operator": "contains",
      "parameter": "holz"
    }
  ]
}
```
""";
