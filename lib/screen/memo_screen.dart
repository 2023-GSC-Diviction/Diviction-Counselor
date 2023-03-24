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
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      ref.read(memoListProvider.notifier).getMemoList(1); // [test]
    });
  }

  @override
  void dispose() {
    ref.read(memoListProvider.notifier).dispose();
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
    ref
        .read(memoProvider.notifier)
        .memoDelete(memoList[index].toMap());
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
      ref
          .read(memoProvider.notifier)
          .memoUpdate(updatedMemo.toMap());
    }
    else {
      print('Error : updatedMemo is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final memoLists = ref.watch(memoListProvider);
    print(memoLists.length);
    memoList = memoLists;
    // 시간순 정렬 최근 게 가장 위로 오게함
    memoList.sort((a, b) => b.modiDate.compareTo(a.modiDate));

    return Scaffold(
      resizeToAvoidBottomInset: true, // 추가
      appBar: AppBar(
        title: const Text('Memo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 250,
                child: ListView.builder(
                  itemCount: memoList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${memoList[index].initDate.toString().split(' ')[0]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '(last modified : ${formatTime(DateTime.parse(memoList[index].modiDate))})',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 0.0),
                                title: Text(memoList[index].content),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => removeMemo(index),
                                ),
                                onTap: () =>
                                    _navigateAndEditMemo(context, index),
                              ),
                            ],
                          ),
                        ));
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
    );
  }

  String formatTime(DateTime time) {
    Duration diff = DateTime.now().difference(time);
    if (diff.inDays >= 365) {
      return '${diff.inDays ~/ 365} years ago';
    } else if (diff.inDays >= 30) {
      return '${diff.inDays ~/ 30} months ago';
    } else if (diff.inDays >= 7) {
      return '${diff.inDays ~/ 7} weeks ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'now';
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
      appBar: AppBar(
        title: const Text('Edit Memo'),
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
