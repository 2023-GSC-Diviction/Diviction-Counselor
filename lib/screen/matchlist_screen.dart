import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/service/matchList_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchListScreen extends ConsumerStatefulWidget {
  const MatchListScreen({super.key});

  @override
  MatchListScreenState createState() => MatchListScreenState();
}

class MatchListScreenState extends ConsumerState<MatchListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: MatchingService().getMatchList(1), // MatchService().getMatchList(6)
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final matches = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Matching List', style: TextStyles.titleTextStyle),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (BuildContext context, int index) {
                      final person = matches[index]['member'];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage('${person['profile_img_url']}'),
                        ),
                        title: Text('${person['email']}, ${calculateAge(person['birth'] as String)} yo'),
                        subtitle: Text('${person['gender']}, ${person['address']}'),
                        onTap: () {
                          // 각 항목을 눌렀을 때 동작할 코드
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
          // Text('${match['matchId']}, ${match['counselorEmail']}, ${match['patientEmail']}');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Text('No data');
        }
      },
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

/*

// return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text('Matching List', style: TextStyles.titleTextStyle),
    //       const SizedBox(height: 20),
    //       ListView.builder(
    //         shrinkWrap: true,
    //         padding: const EdgeInsets.only(bottom: 40),
    //         itemCount: 4,
    //         itemBuilder: (context, index) {
    //           return Container(
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(10),
    //                 border: Border.all(color: Palette.borderColor)),
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //             margin: const EdgeInsets.symmetric(vertical: 10),
    //             child: GestureDetector(
    //               onTap: () {},
    //               child: Container(
    //                 width: 100,
    //                 height: 30,
    //                 decoration: BoxDecoration(
    //                   color: Colors.blue,
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //                 child: const Center(
    //                   child: Text('consult',
    //                       style: TextStyles.blueBottonTextStyle),
    //                 ),
    //               ),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );

 */
