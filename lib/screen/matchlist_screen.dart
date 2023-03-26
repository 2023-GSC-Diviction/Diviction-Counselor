import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/service/matchList_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matchListProvider = FutureProvider<List<dynamic>>((ref) async {
  final matches = await MatchingService().getMatchList(1);
  return matches;
});

class MatchListScreen extends ConsumerStatefulWidget {
  const MatchListScreen({super.key});

  @override
  MatchListScreenState createState() => MatchListScreenState();
}

class MatchListScreenState extends ConsumerState<MatchListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final matchesAsyncValue = ref.watch(matchListProvider);
      return FutureBuilder<List<dynamic>>(
        future: matchesAsyncValue.when(
          data: (matches) => Future.value(matches),
          loading: () => Future.value([]),
          error: (error, stackTrace) => Future.error(error),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Matching List', style: TextStyles.titleTextStyle),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final person = snapshot.data![index]['member'];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage('${person['profile_img_url']}'),
                          ),
                          title: Text(
                              '${person['email']}, ${calculateAge(person['birth'] as String)} yo'),
                          subtitle:
                          Text('${person['gender']}, ${person['address']}'),
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
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Text('No data');
          }
        },
      );
    });
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
