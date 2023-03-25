import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/service/survey_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/survey_result.dart';
import '../../service/auth_service.dart';
import '../../widget/custom_textfiled.dart';
import '../../widget/profile_image.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import '../../widget/survey/survey_chart.dart';


final surdata = [
  SurveyData(
    date: '2021-08-01',
    score: 30,
  ),
  SurveyData(
    date: '2021-08-02',
    score: 13,
  ),
  SurveyData(
    date: '2021-08-06',
    score: 22,
  ),
];

final editModeProvider = StateProvider((ref) => false);

List<String> title = [
  'Introduction',
  'Activity Area',
  'Contact Hours',
  'Question Answer' // Q&A에 대해서 질문 준비해야함(중독자, 상담자)
];

@override
class CounselorProfileScreen extends ConsumerStatefulWidget {
  const CounselorProfileScreen({Key? key}) : super(key: key);

  @override
  CounselorProfileScreenState createState() => CounselorProfileScreenState();
}

class CounselorProfileScreenState extends ConsumerState<CounselorProfileScreen> {
  List<String> title = [
    'Introduction',
    'Activity Area',
    'Contact Hours',
    // 'Question Answer' // Q&A에 대해서 질문 준비해야함(중독자, 상담자)
  ];
  List<TextEditingController> textEditingController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  late Map<String, List<Map<String, dynamic>>> datas;
  late Future<Map<String, List<Map<String, dynamic>>>> futureData;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  void getProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    textEditingController[0].text = prefs.getString('Introduction') ?? '';
    textEditingController[1].text = prefs.getString('Activity Area') ?? '';
    textEditingController[2].text = prefs.getString('Contact Hours') ?? '';
    textEditingController[3].text = prefs.getString('Question Answer') ?? '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ref.invalidate(editModeProvider);
    textEditingController.forEach((element) {
      element.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final editMode = ref.watch(editModeProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Palette.appColor,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: Palette.appColor,
                    leading: null,
                    toolbarHeight: 0,
                    automaticallyImplyLeading: false,
                    expandedHeight: MediaQuery.of(context).size.height * 0.37,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: _Header(
                          textEditingController: textEditingController,
                        ))),
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Column(
                          children: List.generate(title.length, (index) => index)
                              .map(
                                (index) => IntrinsicHeight(
                              child: CustomTextEditor(
                                TitleContent: title[index],
                                textEditingController:
                                textEditingController[index],
                                isreadOnly: !editMode,
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final CounselorProvider = FutureProvider<Counselor>((ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email')!;

  return await AuthService().getCounselor(email);
});

// final imageProvider2 = StateProvider<String?>((ref) => null);

class _Header extends ConsumerStatefulWidget {
  const _Header({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final List<TextEditingController> textEditingController;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
  bool isChoosedPicture = false;
  // 수정권한 부여, 프로필 수정 페이지와 미리보기 페이지의 차이점이 없어서 스크린을 2개로 만들기가 애매합니다.
  // 로그인시 받아온 이메일 값과 해당 정보의 이메일 값을 비교해서 초기화 시키기
  String path = 'asset/image/DefaultProfileImage.png';

  @override
  Widget build(BuildContext context) {
    final editMode = ref.watch(editModeProvider);
    final counselor = ref.watch(CounselorProvider);
    // final image = ref.watch(imageProvider2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TopBar(onEditButtonpressed: onEditButtonpressed),
        SizedBox(height: MediaQuery.of(context).size.height * 0.0115),
        Padding(
            padding: const EdgeInsets.only(top: 12, left: 35, right: 35),
            child: counselor.when(
              data: (data) {
                // if (data.profile_img_url != null) {
                //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //     ref.read(imageProvider2.notifier).state =
                //         data.profile_img_url!;
                //   });
                // }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProfileImage(
                                onProfileImagePressed: () {},
                                isChoosedPicture: isChoosedPicture,
                                path: data.profile_img_url,
                                // type: 1,
                                imageSize:
                                MediaQuery.of(context).size.height * 0.15,
                              ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: const [],
                              ),
                            ]),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.032),
                      Text(
                        data.name, // 이 정보는 회원가입 프로필 작성시에 받아옴. -> DB set -> 여기서 get
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        data.address, // 이 정보는 회원가입 프로필 작성시에 받을 수 있게 추가해야 할 듯
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]);
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => const Center(
                child: Text('fail to load'),
              ),
            )),
      ],
    );
  }

  onProfileImagePressed() async {
    // print("onProfileImagePressed 실행완료");
    // final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    // if (image != null) {
    //   ref.read(imageProvider2.notifier).state = image.path;
    //   setState(() {
    //     this.isChoosedPicture = true;
    //   });
    // }
    // print(image);
  }

  onEditButtonpressed() async {
    // 수정후 Done 버튼이 눌렸을 때 API Call을 통해서 내용 업데이트 해줘야 함
    if (ref.read(editModeProvider.notifier).state) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var i in [0, 1, 2, 3]) {
        prefs.setString(title[i], widget.textEditingController[i].text);
      }
      // API Call - 회원 프로필 업데이트
    }
    ref.read(editModeProvider.notifier).state = !ref.read(editModeProvider);
  }
}

class _TopBar extends ConsumerWidget {
  final VoidCallback onEditButtonpressed;

  const _TopBar({
    Key? key,
    required this.onEditButtonpressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(editModeProvider);
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 23,
            ),
          ),
          TextButton(
            onPressed: onEditButtonpressed,
            child: Text(
              isEditMode ? 'Done' : 'Edit',
              style: TextStyle(
                fontSize: 18,
                color: isEditMode
                    ? Colors.redAccent
                    : const Color.fromARGB(255, 227, 250, 247),
                // color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ReviewCountTexts extends StatelessWidget {
  final String titleContent;
  final String subContent;

  const ReviewCountTexts({
    Key? key,
    required this.titleContent,
    required this.subContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subContent,
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
              maxLines: 1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.002,
            ),
            Text(
              titleContent,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(165, 255, 255, 255),
              ),
              maxLines: 1,
            ),
          ],
        ));
  }
}
