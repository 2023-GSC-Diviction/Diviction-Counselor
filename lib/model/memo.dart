class Memo {
  String MemoId; // 상담자 email + 중독자 email
  String title; // ㅇㅇㅇ환자 상담내용 메모
  String content; // 내용
  String lastEditTile; // 마지막 수정시간

  Memo({
    required this.MemoId,
    required this.title,
    required this.content,
    required this.lastEditTile,
  });
}
