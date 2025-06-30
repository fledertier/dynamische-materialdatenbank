import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/units.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:dynamische_materialdatenbank/query/query_converters.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      'prompt': prompt,
      'attributes':
          attributes
              .map(
                (attribute) => attribute.toJson().removeKeys({
                  'required',
                  'multiline',
                  'nameEn',
                }),
              )
              .toList(),
      'types':
          types.map((type) {
            return {
              'id': type.id,
              'operators':
                  type.operators.map((operator) => operator.name).toList(),
            };
          }).toList(),
      'units':
          UnitTypes.values.map((type) {
            return {'id': type.id, 'units': type.units};
          }).toList(),
    });

    return result.data as String?;
  }

  QueryResult? _parseAnswer(String? answer) {
    if (answer == null) {
      return null;
    }

    final pattern = RegExp(r'([^`]*)```([^`]*)```');
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
