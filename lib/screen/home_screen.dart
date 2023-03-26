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

final userProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  // final isMatched = ref.watch(matchingProvider);
  // if (isMatched) {
  //   final user = await MatchingService().getMatched();
  //   return [user!.user];
  // } else {
  return UserService().getUsers({});
  // }
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
    final userList = ref.watch(userProvider);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MyAppbar(
          isMain: true,
          hasBack: false,
        ),
        backgroundColor: Colors.white,
        body: Consumer(builder: (context, watch, _) {
          final MatchuserList = ref.watch(matchListProvider);
          return SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  height: 270,
                  child: FutureBuilder<List<dynamic>>(
                    future: MatchuserList.when(
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final user = User.fromJson(
                                  snapshot.data![index]['member']);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _Header(name: name),
                                  const Text(
                                    'MatchList',
                                    style: TextStyles.subTitmeTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  _ReqiestUserList(
                                      user: user, needAccept: false),
                                ],
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('No data');
                      }
                    },
                  )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request received',
                      style: TextStyles.subTitmeTextStyle,
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList.when(
                        data: (users) => 2, // users.length
                        loading: () => 0,
                        error: (error, stackTrace) => 0,
                      ),
                      itemBuilder: (context, index) {
                        return userList.when(
                          data: (users) => _ReqiestUserList(
                              user: users.sublist(1, users.length)[index],
                              needAccept: true),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) => Text('Error: $error'),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ));
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
                  color: Palette.appColor2,
                  letterSpacing: 0.02,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                  text: '\n$name!',
                  style: const TextStyle(
                      fontSize: 30,
                      color: Palette.appColor2,
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
        height: 40,
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
    required this.needAccept,
  }) : super(key: key);

  final User user;
  final bool needAccept;

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
    // print('widget.user.profile_img_url : ${widget.user.profile_img_url}');
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
                        child: ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.user.profile_img_url!,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/icons/user_icon.png'),
                          ),
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
                                    .copyWith(fontSize: 15)),
                            Text('${widget.user.gender}',
                                style: TextStyles.chatNotMeBubbleTextStyle
                                    .copyWith(
                                        fontSize: 12, color: Colors.grey[600]))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            widget.needAccept
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Palette.appColor4.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('accept',
                            style: TextStyles.blueBottonTextStyle),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
