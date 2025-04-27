import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';
import 'chat_ai_api.dart';
import 'chat_response.dart';

final promptServiceProvider = Provider((ref) {
  final api = ref.watch(chatAiApiProvider);
  return PromptService(api: api);
});

class PromptService {
  final ChatAiApi api;

  PromptService({required this.api});

  Future<String?> generateQuery({
    required String userPrompt,
    required List<Attribute> attributes,
    required List<AttributeType> types,
  }) async {
    final systemPrompt = buildSystemPrompt(
      attributes: attributes,
      types: types,
    );

    final response = await api.completeChat(
      chatMessages: [
        ChatMessage(role: Role.system, content: systemPrompt),
        ChatMessage(role: Role.user, content: userPrompt),
      ],
    );

    final answer = response?.choices.firstOrNull?.message.content;

    return answer;
  }

  String buildSystemPrompt({
    required List<Attribute> attributes,
    required List<AttributeType> types,
  }) {
    final attributesList = attributes
        .map((attribute) {
          return "- ${attribute.id} (${attribute.type.name})";
        })
        .join("\n");

    final typesList = types
        .map((type) {
          final operators = type.operators
              .map((operator) => operator.name)
              .join(", ");
          return "- ${type.name} (${type.baseType}): $operators";
        })
        .join("\n");

    return """
Du bist ein Materialexperte. Deine Aufgabe ist es aus User Prompts Queries für eine Materialdatenbank zusammenzubauen.

Als Input hast du eine Liste aller Attribute und deren Typen, und bekommst einen Prompt vom User, der beschreibt nach was für Materialien gesucht werden soll.

Der Query den du daraus zusammenbaust, soll in einem strukturierten Format formuliert werden.

Gewünschtes Output Format:
JSON eines ConditionGroup Root Objects dass beliebig viele Conditions oder wiederum ConditionGroups enthält, die mit "and" oder "or" verknüpft werden.

Beispiel output:
```
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
```

Mögliche Attribute und deren Typen: 
$attributesList

Die zugehörigen Typen mit ihrem Datentyp und erlaubten Operatoren:
$typesList

In deiner Antwort skizzierst du erst kurz und formlos einen Plan.
Danach antwortest du ausschließlich mit dem JSON-Query in einem Codeblock.
    """;
  }
}
