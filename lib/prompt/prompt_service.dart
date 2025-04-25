import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';

final promptServiceProvider = Provider((ref) => PromptService());

class PromptService {
  String buildPrompt({
    required List<Attribute> attributes,
    required List<AttributeType> types,
    required String prompt,
  }) {
    final attributesList =
        attributes
            .map(
              (attribute) => {
                "id": attribute.id,
                "name": attribute.nameDe,
                "type": attribute.type.name,
                "required": attribute.required,
              },
            )
            .toList();

    final typesList =
        types
            .map(
              (type) => {
                "id": type.name,
                "baseType": type.baseType,
                "operators":
                    type.operators.map((operator) => operator.name).toList(),
              },
            )
            .toList();

    final encodedAttributes = jsonEncode(attributesList);
    final encodedTypes = jsonEncode(typesList);
    final encodedPrompt = jsonEncode(prompt);

    return """
Du bist ein Materialexperte. Deine Aufgabe ist es einen Query für eine Materialdatenbank zusammenzubauen.

Als Input bekommst du einen Prompt der Beschreibt nach was für Materialien gesucht wird, und eine Liste aller Attribute und deren Typen. Der Query soll in einem strukturierten Format formuliert werden.

Gewünschtes Output Format:
JSON eines ConditionGroup Root Objects dass beliebig viele Conditions oder wiederum ConditionGroups enthält, die mit "and" oder "or" verknüpft werden.

Beispiel output:
{
	"combinator": "and",
	"nodes": [
		{
			"attribute": "description",
			"operator": "contains",
			"parameter": "Birkenholz",
		},
	    {
	    	"combinator": "or",
	    	"nodes": [
	    		{
	    			"attribute": "density",
	    			"operator": "lessThan",
	    			"parameter": 10.9,
	    		},
	    		{
					"attribute": "biodegradable",
					"operator": "equals",
					"parameter": true,
				},
				{
					"attribute": "manufacturer",
					"operator": "contains",
					"parameter": "BAUX",
				}
	    	],
	    },
	],
}

Mögliche Attribute: 
$encodedAttributes

Die zugehörigen Typen mit erlaubten Operatoren:
$encodedTypes

Generiere nun den Query für den folgenden Prompt: 
$encodedPrompt
    """;
  }
}
