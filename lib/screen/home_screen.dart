import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/model/user.dart';
import 'package:diviction_counselor/screen/profile/user_profile_screen.dart';
import 'package:diviction_counselor/service/matchList_service.dart';
import 'package:diviction_counselor/service/user_service.dart';
import 'package:diviction_counselor/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

final matchListProvider = FutureProvider<List<dynamic>>((ref) async {
  final matches = await MatchingService().getMatchList(1);
  return matches;
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String name = 'User';

  getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const MyAppbar(
          isMain: true,
          hasBack: false,
        ),
        backgroundColor: Palette.appColor,
        resizeToAvoidBottomInset: false,
        body: Consumer(builder: (context, watch, _) {
          final userList = ref.watch(matchListProvider);
          return FutureBuilder<List<dynamic>>(
            future: userList.when(
              data: (matches) => Future.value(matches),
              loading: () => Future.value([]),
              error: (error, stackTrace) => Future.error(error),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = User.fromJson(snapshot.data![index]['member']);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Header(name: name),
                            const Text(
                              'Request received',
                              style: TextStyles.subTitmeTextStyle,
                            ),
                            const SizedBox(height: 10),
                            _ReqiestUserList(user: user),
                          ],
                        );
                      },
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('No data');
              }
            },
          );
        }),
      ),
    );
  }

  int calculateAge(String birthdayStr) {
    DateTime today = DateTime.now();
    DateTime birthday = DateTime.parse(birthdayStr);

    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }
}

class _Header extends ConsumerWidget {
  const _Header({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget recordText() => Container(
        width: MediaQuery.of(context).size.width,
        child: Text.rich(
          TextSpan(
              text: 'Hello, ',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 0.02,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                  text: '\n$name!',
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      height: 1.4,
                      letterSpacing: 0.02,
                      fontWeight: FontWeight.w700),
                )
              ]),
          textAlign: TextAlign.start,
        ));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      recordText(),
      const SizedBox(
        height: 20,
      ),
      // const CheckListWidget(),
      // const SizedBox(
      //   height: 20,
      // ),
    ]);
  }
}

class _ReqiestUserList extends ConsumerStatefulWidget {
  const _ReqiestUserList({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _ReqiestUserListState createState() => _ReqiestUserListState();
}

class _ReqiestUserListState extends ConsumerState<_ReqiestUserList> {
  int calculateAge(String birthdayStr) {
    DateTime today = DateTime.now();
    DateTime birthday = DateTime.parse(birthdayStr);

    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    print('widget.user.profile_img_url : ${widget.user.profile_img_url}');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfileScreen(user: widget.user)));
                },
                child: Container(
                  height: 75,
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.profile_img_url!,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/icons/user_icon.png'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${widget.user.name}, ${calculateAge(widget.user.birth)} years old',
                                style: TextStyles.chatNicknameTextStyle
                                    .copyWith(fontSize: 16)),
                            Text('${widget.user.gender}, ${widget.user.email}',
                                style: TextStyles.chatNotMeBubbleTextStyle
                                    .copyWith(fontSize: 16))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: Palette.appColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('accept', style: TextStyles.blueBottonTextStyle),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
