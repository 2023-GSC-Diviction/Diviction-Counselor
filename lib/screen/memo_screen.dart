import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/model/memo.dart';
import 'package:diviction_counselor/provider/memoList_provider.dart';
import 'package:diviction_counselor/provider/memo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memoProvider = StateNotifierProvider.autoDispose<MemoState, SaveState>(
    (ref) => MemoState());
final memoListProvider =
    StateNotifierProvider.autoDispose<MemoListProvider, List<Memo>>(
        (ref) => MemoListProvider());

class MemoScreen extends ConsumerStatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends ConsumerState<MemoScreen> {
  List<Memo> memoList = [];
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Widget이 올바른 상태에서 MemoListProvider를 호출하기 위해 addListener를 사용합니다.
    ref.read(memoListProvider.notifier).addListener((state) {
      if (!mounted) return;
      setState(() {});
    });
    ref.read(memoListProvider.notifier).getMemoList(1);
  }

  @override
  void dispose() {
    ref.invalidate(memoListProvider);
    super.dispose();
  }

  void addMemo(String content) {
    Map<String, dynamic> data = {
      'title': 'title1',
      'matchId': 1,
      'content': content,
    };
    ref.read(memoProvider.notifier).memoSave(data);
    setState(() {
      Memo memo = Memo(
        memoId: 11, // [test] 임시
        title: 'title', // [test] 임시
        content: content,
        initDate: DateTime.now().toString(),
        modiDate: DateTime.now().toString(),
      );
      memoList.add(memo);
    });
    // print(memoList);
  }

  void removeMemo(int index) {
    setState(() {
      memoList.removeAt(index);
    });
    ref.read(memoProvider.notifier).memoDelete(memoList[index].toMap());
  }

  Future<void> _navigateAndEditMemo(BuildContext context, int index) async {
    final Memo? updatedMemo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoEditScreen(memo: memoList[index]),
      ),
    );
    if (updatedMemo != null) {
      setState(() {
        memoList[index] = updatedMemo;
      });
      ref.read(memoProvider.notifier).memoUpdate(updatedMemo.toMap());
    } else {
      print('Error : updatedMemo is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final memoLists = ref.watch(memoListProvider);
    memoList = memoLists;
    // 시간순 정렬, 수정된 시간이 최근인게 가장 위로 오게함
    memoList.sort((a, b) => b.modiDate.compareTo(a.modiDate));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Patient Counseling Diary'),
          centerTitle: true,
          backgroundColor: Palette.appColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: ListView.builder(
                    itemCount: memoList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    _navigateAndEditMemo(context, index);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          '${memoList[index].initDate.toString().split(' ')[0]}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '(modified ${formatTime(DateTime.parse(memoList[index].modiDate))})',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ]),
                                      SizedBox(height: 10),
                                      Text(memoList[index].content),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => removeMemo(index),
                                color: Palette.appColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: memoController,
                          decoration: const InputDecoration(
                            hintText: 'Write a memo',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          addMemo(memoController.text);
                          memoController.clear();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    Duration diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) {
      return 'now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes Sago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${time.toString().split(' ')[0]}';
    }
  }
}

class MemoEditScreen extends StatefulWidget {
  final Memo memo;

  const MemoEditScreen({
    Key? key,
    required this.memo,
  }) : super(key: key);

  @override
  _MemoEditScreenState createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  late TextEditingController memoController;

  @override
  void initState() {
    super.initState();
    memoController = TextEditingController(text: widget.memo.content);
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }

  void saveMemo() {
    final newMemo = Memo(
      memoId: widget.memo.memoId,
      title: widget.memo.title,
      content: memoController.text,
      initDate: widget.memo.initDate,
      modiDate: DateTime.now().toString(),
    );
    Navigator.pop(context, newMemo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Memo'),
        centerTitle: true,
        backgroundColor: Palette.appColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveMemo,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: memoController,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Edit the memo',
              ),
            ),
            const Divider(),
            Text(
              'last modified date : ${widget.memo.modiDate}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
