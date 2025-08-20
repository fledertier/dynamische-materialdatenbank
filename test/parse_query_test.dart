void main() {
  // group('parse_query', () {
  //   test('example query', () {
  //     final service = QueryService();
  //     final result = service.parseAnswer(exampleAnswer);
  //     expect(result, isNotNull);
  //     expect(result!.query, isNotNull);
  //
  //     final query = service.parseQuery(result.query);
  //     expect(query, isNotNull);
  //     expect(query!.type, ConditionGroupType.and);
  //     expect(query.nodes.length, 2);
  //
  //     final densityNode = query.nodes[0] as Condition;
  //     expect(densityNode.attributePath?.ids.first, 'density');
  //     expect(densityNode.operator, Operator.greaterThan);
  //     final densityValue = UnitNumber.fromJson(densityNode.parameter as Json);
  //     expect(densityValue.value, 0.8);
  //
  //     final descriptionNode = query.nodes[1] as Condition;
  //     expect(descriptionNode.attributePath?.ids.first, 'description');
  //     expect(descriptionNode.operator, Operator.contains);
  //     final descriptionValue = TranslatableText.fromJson(
  //       descriptionNode.parameter as Json,
  //     );
  //     expect(descriptionValue.valueDe, 'holz');
  //     expect(descriptionValue.valueEn, 'wood');
  //   });
  // });
}

const exampleAnswer = r'''Plan:
1. Identifizieren des Attributs "density" (Dichte) und setzen des Operators auf "greaterThan" (größer als).
2. Festlegen des Parameters für die Dichte auf einen Wert, der als "schwer" interpretiert werden kann (z.B. 0,8 kg/m³).
3. Identifizieren des Attributs "description" (Beschreibung) und setzen des Operators auf "contains" (enthält).
4. Festlegen des Parameters für die Beschreibung auf den Wert "holz".

```
{
"type": "and",
"nodes": [
{
"attribute": "density",
"operator": "greaterThan",
"parameter": {
"value": 0.8
}
},
{
"attribute": "description",
"operator": "contains",
"parameter": {
"valueDe": "holz",
"valueEn": "wood"
}
}
]
}
```''';
