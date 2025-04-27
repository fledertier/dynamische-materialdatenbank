import 'package:dio/dio.dart';
import 'package:dynamische_materialdatenbank/prompt/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_response.dart';

final chatAiApiProvider = Provider((ref) => ChatAiApi());

class ChatAiApi {
  static const apiKey = String.fromEnvironment("CHAT_AI_API_KEY");
  static const baseUrl = "https://chat-ai.academiccloud.de/v1";

  /// Textgenerierung und vervollständigung
  static const completions = "/completions";

  /// Benutzer-Assistenten Gespräche
  static const chatCompletions = "/chat/completions";

  /// Liste der verfügbaren Modelle
  static const models = "/models";

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
    ),
  );

  Future<ChatResponse?> completeChat({
    Models model = Models.sauerkraut70b,
    required List<ChatMessage> chatMessages,
    double temperature = 0.5,
    double topP = 0.5,
    int? maxTokens,
  }) async {
    final response = await dio.post(
      chatCompletions,
      data: {
        "model": model.model,
        "messages": chatMessages.map((e) => e.toJson()).toList(),
        "temperature": temperature,
        "top_p": topP,
        if (maxTokens != null) "max_tokens": maxTokens,
      },
    );

    final json = response.data;
    if (json == null) return null;
    return ChatResponse.fromJson(json);
  }
}
