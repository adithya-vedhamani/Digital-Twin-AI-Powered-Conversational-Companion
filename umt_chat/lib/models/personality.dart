class PersonalityEntry {
  int userId;
  String question;
  String response;

  PersonalityEntry({
    required this.userId,
    required this.question,
    required this.response,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'question': question,
      'response': response,
    };
  }
}
