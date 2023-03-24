class Memo {
  int memoId;
  String title;
  String content;
  String initDate; // 메모 생성시간
  String modiDate; // 메모 수정시간

  Memo({
    required this.memoId,
    required this.title,
    required this.content,
    required this.initDate,
    required this.modiDate,
  });

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      memoId: json['memoId'],
      title: json['title'],
      content: json['content'],
      initDate: json['initDate'],
      modiDate: json['modiDate'],
    );
  }
}
