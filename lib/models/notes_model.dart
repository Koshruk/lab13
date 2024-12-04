class Notes{
  final int id;
  final String text;
  final String date;

  Notes({required this.text, required this.date, this.id = 0});

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'] ?? 0,
      text: map['text'] ?? '',
      date: map['date_time'] ?? '',
    );
  }


}