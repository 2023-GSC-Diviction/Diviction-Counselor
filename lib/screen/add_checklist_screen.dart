import 'package:diviction_counselor/service/checklist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/style.dart';
import '../model/user.dart';

final checklistProvider = StateProvider<int>((ref) => 1);
final checklistItemProvider = StateProvider<List<String>>((ref) => ['']);

class AddChecklistScreen extends ConsumerStatefulWidget {
  const AddChecklistScreen({super.key, required this.user});

  final User user;

  @override
  AddChecklistScreenState createState() => AddChecklistScreenState();
}

class AddChecklistScreenState extends ConsumerState<AddChecklistScreen> {
  @override
  Widget build(BuildContext context) {
    int index = ref.watch(checklistProvider);
    List<String> checklist = ref.watch(checklistItemProvider);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Palette.appColor3,
            title: const Text('Add Checklist',
                style: TextStyle(color: Palette.appColor4)),
            elevation: 1,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios))),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(
                      'Add Checklist for ${widget.user.name}',
                      style: TextStyles.titleTextStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    for (int i = 0; i < index; i++)
                      CheckListItemWidget(index: i),
                  ]),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 60),
                              primary: Palette.appColor4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            ChecklistService()
                                .saveChecklist(widget.user.id, checklist);
                            Navigator.pop(context);
                          },
                          child: const Text('Add Checklist')))
                ])));
  }
}

class CheckListItemWidget extends ConsumerStatefulWidget {
  const CheckListItemWidget({super.key, required this.index});

  final int index;
  @override
  CheckListItemWidgetState createState() => CheckListItemWidgetState();
}

class CheckListItemWidgetState extends ConsumerState<CheckListItemWidget> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  ref.read(checklistItemProvider.notifier).state[widget.index] =
                      value;
                },
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                maxLines: null,
                controller: _textEditingController,
                cursorColor: Colors.grey,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true, // 이걸 true로 해야 색상을 넣어줄 수 있음
                  fillColor: Palette.appColor5.withOpacity(0.05),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Palette.appColor4,
              onPressed: () {
                ref.read(checklistProvider.notifier).state++;
                ref.read(checklistItemProvider.notifier).state.add('');
              },
            ),
            widget.index != 0
                ? IconButton(
                    onPressed: () {
                      ref.read(checklistProvider.notifier).state--;
                      ref
                          .read(checklistItemProvider.notifier)
                          .state
                          .removeAt(widget.index);
                    },
                    icon: const Icon(Icons.minimize),
                  )
                : Container()
          ],
        ));
  }
}
