import 'package:flutter/material.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  List<Map<String, dynamic>> memoList = [
    {
      'content':
          '1111111111111111111111111111111111111111111111111111111111111111111',
      'time': DateTime.parse('2022-03-22 04:51:50.251805')
    },
    {
      'content': '222222222222222222222222222222222222',
      'time': DateTime.parse('2023-01-22 04:51:52.865112')
    },
    {
      'content': '3333333333333333333333333333333333333333333333333333',
      'time': DateTime.parse('2023-02-22 04:51:55.541841')
    },
    {
      'content':
          '4444444444444444444444444444444444444444444444444444444444444444',
      'time': DateTime.parse('2023-03-12 04:51:58.125609')
    },
    {
      'content':
          '5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555',
      'time': DateTime.parse('2023-03-22 04:52:02.655365')
    },
    {
      'content': '666666666666666666666666666666666',
      'time': DateTime.parse('2023-03-22 02:52:02.655365')
    },
    {
      'content': '777777777777777777777777777777777777',
      'time': DateTime.parse('2023-03-22 02:52:02.655365')
    },
    {
      'content': '8888888888888888888888888888888888',
      'time': DateTime.parse('2023-03-22 04:22:02.655365')
    },
    {
      'content': '99999999999999999999999999999',
      'time': DateTime.parse('2020-03-22 04:22:02.655365')
    },
  ];

  TextEditingController memoController = TextEditingController();

  void addMemo(String content) {
    setState(() {
      memoList.add({'content': content, 'time': DateTime.now()});
    });
    print(memoList);
  }

  void removeMemo(int index) {
    setState(() {
      memoList.removeAt(index);
    });
  }

  Future<void> _navigateAndEditMemo(BuildContext context, int index) async {
    final newMemo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoEditScreen(
          initialMemo: memoList[index]['content'],
          date: memoList[index]['time'].toString().split(' ')[0],
        ),
      ),
    );
    if (newMemo != null) {
      setState(() {
        memoList[index]['content'] = newMemo;
        memoList[index]['time'] = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 시간순 정렬 최근 게 가장 위로 오게함
    memoList.sort((a, b) => b['time'].compareTo(a['time']));

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
                                    '${memoList[index]['time'].toString().split(' ')[0]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '(${formatTime(memoList[index]['time'])})',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 0.0),
                                title: Text(memoList[index]['content']),
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
  final String initialMemo;
  final String date;

  const MemoEditScreen({
    Key? key,
    required this.initialMemo,
    required this.date,
  }) : super(key: key);

  @override
  _MemoEditScreenState createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  late TextEditingController memoController;

  @override
  void initState() {
    super.initState();
    memoController = TextEditingController(text: widget.initialMemo);
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }

  void saveMemo() {
    final newMemo = memoController.text;
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
              'last modified date : ${widget.date}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
