import '../types.dart';

class ChatResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;

  const ChatResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
  });

  factory ChatResponse.fromJson(Json json) {
    return ChatResponse(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      choices:
          (json['choices'] as List)
              .map((choice) => Choice.fromJson(choice))
              .toList(),
    );
  }
}

class Choice {
  final int index;
  final ChatMessage message;
  final String? finishReason;
  final String? stopReason;

  const Choice({
    required this.index,
    required this.message,
    this.finishReason,
    this.stopReason,
  });

  factory Choice.fromJson(Json json) {
    return Choice(
      index: json['index'],
      message: ChatMessage.fromJson(json['message']),
      finishReason: json['finish_reason'],
      stopReason: json['stop_reason'],
    );
  }
}

class ChatMessage {
  final Role role;
  final String content;

  const ChatMessage({required this.role, required this.content});

  factory ChatMessage.fromJson(Json json) {
    return ChatMessage(
      role: Role.values.byName(json['role']),
      content: json['content'],
    );
  }

  Json toJson() {
    return {"role": role.name, "content": content};
  }
}

enum Role { system, user, assistant }
