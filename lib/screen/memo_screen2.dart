import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemoScreen2 extends StatefulWidget {
  const MemoScreen2({super.key});

  @override
  State<MemoScreen2> createState() => _MemoScreen2State();
}

class _MemoScreen2State extends State<MemoScreen2> {
  String _title = '';
  String _content = '';
  DateTime _modifiedTime = DateTime.now();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  final TextEditingController _textController = TextEditingController();
  final List<String> _memos = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ㅇㅇㅇ환자 상담내용 정리'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextField(
                  //   controller: _titleController,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _title = value;
                  //     });
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: '제목을 입력하세요',
                  //     border: InputBorder.none,
                  //   ),
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // Divider(thickness: 1),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '내용',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '마지막 수정 시간: ${DateFormat('yyyy-MM-dd hh:mm:ss').format(_modifiedTime)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      onChanged: (value) {
                        setState(() {
                          _content = value;
                        });
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
