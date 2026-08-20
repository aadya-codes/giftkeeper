import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';


class AIService {
  static Future<List<String>> generateIdeas({
    required Person person,
  }) async {
    final prompt = """
    You are an expert gift recommendation assistant.

    Your goal is to recommend gifts that feel personal and thoughtful and practical.

    Person Information

    Relationship:
    ${person.relationship}

    Interests:
    ${person.interests}

    Additional Notes:
    ${person.notes}

    Already Gifted:
    ${person.giftIdeas.where((g) => g.given).map((g) => g.name).join(", ")}

    Instructions:
    - Carefully use ALL the information provided.
    - Pay close attention to the Notes section, including any budget, favourite brands, colours, hobbies, dislikes, allergies, wishlist items, or special requests.
    - If a budget is mentioned, keep every recommendation within that budget.
    - Never recommend something already given.
    - Avoid repetitive or very similar ideas.
    - Prefer gifts that feel personal rather than generic.
    - Include a variety of physical gifts, experiences, DIY ideas, and useful items when appropriate.
    - If information is limited, make reasonable assumptions based on the person's interests.
    - Return exactly 10 gift ideas.
    - One idea per line.
    - Do not number the list.
    - Do not include explanations.
    """;

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/generate-gifts"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "prompt": prompt,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Groq Error ${response.statusCode}\n${response.body}",
      );
    }

    final json = jsonDecode(response.body);

    print("BACKEND RESPONSE: ${response.body}");

    final text = json["ideas"] as String;

    return text
        .split("\n")
        .map((e) => e.replaceFirst(RegExp(r'^\d+[\).\s-]*'), "").trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}