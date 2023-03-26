import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:diviction_counselor/model/user.dart';
import 'package:diviction_counselor/service/matchList_service.dart';
import 'package:diviction_counselor/service/survey_service.dart';
import 'package:diviction_counselor/widget/survey/survey_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/style.dart';
import '../../model/counselor.dart';
import '../../util/getUserData.dart';
import '../../widget/profile_image.dart';

class UserProfileData {
  String title;
  String answer;

  UserProfileData({required this.title, required this.answer});
}

@override
class UserProfileScreen extends ConsumerStatefulWidget {
  final User user;
  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  CounselorProfileScreenState createState() => CounselorProfileScreenState();
}

class CounselorProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool isMatched = false;
  late Map<String, List<Map<String, dynamic>>> datas;
  late Future<Map<String, List<Map<String, dynamic>>>> futureData;

  List<UserProfileData> profileData = [
    UserProfileData(
      title: 'Introduction',
      answer:
          'Hello, I\'m James working at The Center for Health and Rehabilitation. This center provide Adult Addictive Diseases & Substance Abuse services.\nI hope our service helps you',
    ),
    UserProfileData(
        title: 'Activity Area', answer: 'Georgia, Atlanta, Fulton County, USA'),
    UserProfileData(
        title: 'Contact Hours',
        answer: 'Monday ~ Friday\n 9:00AM ~ 12:00PM, 1:00PM ~ 8:30PM'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureData = loadData();
    getMatchingData();
  }

  void getMatchingData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    isMatched = sharedPreferences.getBool('isMatched') ?? false;
  }

  Future<Map<String, List<Map<String, dynamic>>>> loadData() async {
    final List<Map<String, dynamic>> DASS_result =
        await SurveyService().DASSdataGet();
    final List<Map<String, dynamic>> DAST_result =
        await SurveyService().DASTdataGet();
    final List<Map<String, dynamic>> AUDIT_result =
        await SurveyService().AUDITdataGet();
    datas = {
      'DASS': [],
      'DAST': [],
      'AUDIT': [],
    };
    setState(() {
      DASS_result.forEach((data) {
        datas['DASS']!.add({
          'date': data['date'],
          'melancholyScore': data['melancholyScore'],
          'unrestScore': data['unrestScore'],
          'stressScore': data['stressScore'],
        });
      });
      DAST_result.forEach((data) {
        Map<String, dynamic> surveyData = {
          'date': data['date'],
          'score': data['question'],
        };
        datas['DAST']!.add(surveyData);
      });
      AUDIT_result.forEach((data) {
        Map<String, dynamic> surveyData = {
          'date': data['date'],
          'score': data['score'],
        };
        datas['AUDIT']!.add(surveyData);
      });
    });
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Palette.appColor,
          // floatingActionButton: isMatched
          //     ? FloatingActionButton.extended(
          //   onPressed: () async {
          //     final user = await GetUser.getUserId();
          //     MatchingService()
          //         .createMatch(user, widget.user.id)
          //         .then((value) {
          //       if (value) {
          //         ScaffoldMessenger.of(context)
          //             .showSnackBar(const SnackBar(
          //           content: Text('request success'),
          //         ));
          //       } else {
          //         ScaffoldMessenger.of(context)
          //             .showSnackBar(const SnackBar(
          //           content: Text('request fail'),
          //         ));
          //       }
          //     });
          //   },
          //   label: const Text('request consult'),
          //   icon: const Icon(Icons.add_reaction_sharp),
          //   backgroundColor: Palette.appColor,
          // )
          //     : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: Palette.appColor,
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => Navigator.pop(context)),
                    expandedHeight: MediaQuery.of(context).size.height * 0.47,
                    floating: false,
                    forceElevated: innerBoxIsScrolled,
                    pinned: true,
                    toolbarHeight: MediaQuery.of(context).size.height * 0.08,
                    title: Text(
                      'About ${widget.user.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                        background: _Header(user: widget.user))),
              ];
            },
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Column(
                      children: profileData
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 10, left: 5),
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        e.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color:
                                              Palette.appColor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        e.answer,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Addiction self-diagnosis result',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.white, // grey[100], Color(0x00FFFFFF)
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1, color: Colors.black12),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width,
                        height: 360,
                        child: FutureBuilder<
                            Map<String, List<Map<String, dynamic>>>>(
                          future: futureData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // 로딩 중일 때 표시할 UI
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              // 데이터를 성공적으로 받아올 때 표시할 UI
                              Map<String, List<Map<String, dynamic>>> data =
                                  snapshot.data!;
                              return ContainedTabBarView(
                                tabBarProperties: TabBarProperties(
                                  indicatorColor: Colors.blue,
                                ),
                                tabs: const [
                                  Text('Psychological',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  Text('Drug',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  Text('Alcohol',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                ],
                                views: [
                                  Survey_Chart(
                                    data: data['DASS']!,
                                    multiLine: true,
                                    maxY: 42,
                                  ),
                                  Survey_Chart(
                                    data: data['DAST']!,
                                    multiLine: false,
                                    maxY: 10,
                                  ),
                                  Survey_Chart(
                                    data: data['DAST']!,
                                    multiLine: false,
                                    maxY: 40,
                                  ), // AUDIT
                                ],
                                onChange: (index) => print(index),
                              );
                            } else if (snapshot.hasError) {
                              // 에러가 발생했을 때 표시할 UI
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // 아직 로딩 중이거나 데이터를 받아오지 못했을 때 표시할 UI
                              return Center(child: Text('Data Load Error'));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerStatefulWidget {
  const _Header({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
  bool isChoosedPicture = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user
                      .name, // 이 정보는 회원가입 프로필 작성시에 받아옴. -> DB set -> 여기서 get
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  widget.user.email, // 이 정보는 회원가입 프로필 작성시에 받을 수 있게 추가해야 할 듯
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileImage(
                        onProfileImagePressed: () {},
                        isChoosedPicture: isChoosedPicture,
                        path: widget.user.profile_img_url,
                        imageSize: MediaQuery.of(context).size.height * 0.15,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          ReviewCountTexts(
                            subContent: '200',
                            titleContent: 'Contacted',
                          ),
                          ReviewCountTexts(
                            subContent: '125',
                            titleContent: 'Consulting',
                          ),
                          ReviewCountTexts(
                            subContent: '29Y',
                            titleContent: 'Career',
                          ),
                        ],
                      ),
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.03),
                      // Text(
                      //   'I\'m James working at the addiction center. I usually consult drug addiction, and I consult alcohol addiction. The address of the consultation center is - and it\'s always open, so feel free to visit',
                      //   style: TextStyles.blueBottonTextStyle,
                      // )
                    ]),
              ]),
        ),
      ],
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
              style: TextStyle(
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

class Survey_Chart extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final double maxY;
  final bool multiLine;

  const Survey_Chart({
    Key? key,
    required this.data,
    required this.maxY,
    required this.multiLine,
  }) : super(key: key);

  @override
  State<Survey_Chart> createState() => _Survey_ChartState();
}

class _Survey_ChartState extends State<Survey_Chart> {
  @override
  Widget build(BuildContext context) {
    // print('widget.data : ${widget.data.toString()}');
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // dividingLine,
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: (widget.data != null && widget.data != [])
                ? SurveyChart(
                    list: widget.data,
                    maxY: widget.maxY == null ? 1 : widget.maxY,
                    multiLine: widget.multiLine)
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
