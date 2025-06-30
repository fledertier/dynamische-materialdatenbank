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
    required Map<String, Attribute> attributesById,
    required List<AttributeType> types,
    required String prompt,
  }) async {
    final answer = await _answerPrompt(
      prompt,
      attributesById.values.toList(),
      types,
    );
    final result = parseAnswer(answer);
    if (result == null) {
      return null;
    }
    return parseQuery(result.query, attributesById);
  }

  Future<String?> _answerPrompt(
    String prompt,
    List<Attribute> attributes,
    List<AttributeType> types,
  ) async {
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
            return {'id': type.id, 'unit': type.base};
          }).toList(),
    });

    return result.data as String?;
  }

  QueryResult? parseAnswer(String? answer) {
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

  ConditionGroup? parseQuery(
    String string,
    Map<String, Attribute>? attributesById,
  ) {
    final json = jsonDecode(string) as Json?;
    return ConditionGroupConverter.maybeFromJson(json, attributesById);
  }
}

class QueryResult {
  final String? plan;
  final String query;

  const QueryResult({this.plan, required this.query});
}
