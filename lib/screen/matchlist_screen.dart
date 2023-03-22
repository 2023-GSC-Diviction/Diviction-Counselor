import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/service/match_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchListScreen extends ConsumerStatefulWidget {
  const MatchListScreen({super.key});

  @override
  MatchListScreenState createState() => MatchListScreenState();
}

final data = [
  {
    "id": 1,
    "email": "lin019@naver.com",
    "name": "이름1",
    "birth": "2003-03-16",
    "address": "연수",
    "gender": "FEMALE",
    "profile_img_url":
        "https://ffa49639e85dc6968888bcf619ca7f275e300699aa18058625c879e-apidata.googleusercontent.com/download/storage/v1/b/diviction/o/user-profile%2Fuser-profile_user-basic-icon.jpg?jk=Ac_6HjLwtvhTOWgmEa8Wl4X7MYowYtueJcIaeUeEq8UXXJ9Y95sqZOUmLanyaP2IeuchRm3-9g0G1ewUuOmgIbi_N3-HD1p418F3GwuuvVrhyUNuh4_mZ1GqRpzErJk-E5YUI52nynk63KsF5oDcrZlhkaiLQFIj2Y5F0l_XosB0g242B3WIUfL5xUY-e38H7K9kfHeRXyXZAig3IQFpdYhzSOHgCCsDLF1XJRvBRhBTnrnvpozQNdWE61_KFnuWU4mGAo3wewDDaOqUMfcPFy7shpvZpI8W2q2w2GpWpwLo9FNtNDKopFHgZrWLA2emj8BnIuokgp9pNhtb-n4c-5kGTsPHfXZhugp20Sqnh9fHTfMphn5pCCxBj7DMsdtI87930UcRK7g_iBNANtma542flnhEkmpADblYlB9Cnx8UICjIrINo2iR2Pz3C8G-jsXph4EIwwak8TNuV_7NootZMY1f2PQ4ohvCmjyepgCI_9HHvUXCVo_MidpN3XUlre1QlRDbfIOEyZIBaGKoEI8ujcHzc6lKAaNq-9CORDFrLOECI6VcB55AMHHSmFCx6zZovBleECbnnlflJgakntzzc0URehvBdKR-hiwzl52mrw93tO4spU0FZb9Q5R4SJmO5PlGfPIBnhX8SBTs_ZXhxL2N7qaRuFI8RrfQqx_mTsM3eNsLcgAFgNHVw8k_nYOF_1ZlDkvsEGlCwD1xUONJAfXofp6YBDdPIr6vOHPa_D78kXIfU-ODwGqOE5lka7uHd5GNvlw27GsmYpyITbhxkWF_8v1knd4Oy24X1roOzxjBKjPZADHHH78z_NSUaSCDGl3cw7BbvOIKsVyOzzr6cvOX1YDy-I-sL85WI-OyIN4R2bwJZfCpR4s6D28En6m393D95THfWErB2-d4Po3BXkj5A_fhb07-vUPP2DN-Ec7iyWMSLbUeLbPVc0W-ejNVNk1ovXqJ7zPpCbXy8qdccSBUKVrl9FrYqkdWaQH78csC32ZXlzf15CFswOKm1XpCUHDGYwd1UI8WLAPnJiqh6Qa92Jog8C0JXJYLRi2lrdaryZ-VB6Cpe9QsGIrHt56CjPwZB77Ha-aS7e1aZe1dnWdg3bLl-Dmhw2PDwm_DYbin1cT7Jm6_fydg8vVXC26BJw1PJQdFK-u2XaWkNktwhHYW-RorWd5P_PW2btP6ASVnzfXZK0gDMp_HQ87-tM5Xd_9mlgr3M8Dbxfdv4-f6zaeo2jMnEM5OMGVz1ghU_z3zGKB7T9gyC9JIo4adYfULJwRxq-zNdTd9mSxYlCzIgSDPMNleryce_SXRK2SH1sL-kvBExFml1SK94nQwgWhO-JCmWvNh9E_2q4&isca=1"
  },
  {
    "id": 2,
    "email": "test11@gmail.com",
    "name": "이름2",
    "birth": "1989-09-09",
    "address": "string",
    "gender": "MALE",
    "profile_img_url":
        "https://ffa49639e85dc6968888bcf619ca7f275e300699aa18058625c879e-apidata.googleusercontent.com/download/storage/v1/b/diviction/o/user-profile%2Fuser-profile_user-basic-icon.jpg?jk=Ac_6HjLwtvhTOWgmEa8Wl4X7MYowYtueJcIaeUeEq8UXXJ9Y95sqZOUmLanyaP2IeuchRm3-9g0G1ewUuOmgIbi_N3-HD1p418F3GwuuvVrhyUNuh4_mZ1GqRpzErJk-E5YUI52nynk63KsF5oDcrZlhkaiLQFIj2Y5F0l_XosB0g242B3WIUfL5xUY-e38H7K9kfHeRXyXZAig3IQFpdYhzSOHgCCsDLF1XJRvBRhBTnrnvpozQNdWE61_KFnuWU4mGAo3wewDDaOqUMfcPFy7shpvZpI8W2q2w2GpWpwLo9FNtNDKopFHgZrWLA2emj8BnIuokgp9pNhtb-n4c-5kGTsPHfXZhugp20Sqnh9fHTfMphn5pCCxBj7DMsdtI87930UcRK7g_iBNANtma542flnhEkmpADblYlB9Cnx8UICjIrINo2iR2Pz3C8G-jsXph4EIwwak8TNuV_7NootZMY1f2PQ4ohvCmjyepgCI_9HHvUXCVo_MidpN3XUlre1QlRDbfIOEyZIBaGKoEI8ujcHzc6lKAaNq-9CORDFrLOECI6VcB55AMHHSmFCx6zZovBleECbnnlflJgakntzzc0URehvBdKR-hiwzl52mrw93tO4spU0FZb9Q5R4SJmO5PlGfPIBnhX8SBTs_ZXhxL2N7qaRuFI8RrfQqx_mTsM3eNsLcgAFgNHVw8k_nYOF_1ZlDkvsEGlCwD1xUONJAfXofp6YBDdPIr6vOHPa_D78kXIfU-ODwGqOE5lka7uHd5GNvlw27GsmYpyITbhxkWF_8v1knd4Oy24X1roOzxjBKjPZADHHH78z_NSUaSCDGl3cw7BbvOIKsVyOzzr6cvOX1YDy-I-sL85WI-OyIN4R2bwJZfCpR4s6D28En6m393D95THfWErB2-d4Po3BXkj5A_fhb07-vUPP2DN-Ec7iyWMSLbUeLbPVc0W-ejNVNk1ovXqJ7zPpCbXy8qdccSBUKVrl9FrYqkdWaQH78csC32ZXlzf15CFswOKm1XpCUHDGYwd1UI8WLAPnJiqh6Qa92Jog8C0JXJYLRi2lrdaryZ-VB6Cpe9QsGIrHt56CjPwZB77Ha-aS7e1aZe1dnWdg3bLl-Dmhw2PDwm_DYbin1cT7Jm6_fydg8vVXC26BJw1PJQdFK-u2XaWkNktwhHYW-RorWd5P_PW2btP6ASVnzfXZK0gDMp_HQ87-tM5Xd_9mlgr3M8Dbxfdv4-f6zaeo2jMnEM5OMGVz1ghU_z3zGKB7T9gyC9JIo4adYfULJwRxq-zNdTd9mSxYlCzIgSDPMNleryce_SXRK2SH1sL-kvBExFml1SK94nQwgWhO-JCmWvNh9E_2q4&isca=1"
  },
  {
    "id": 7,
    "email": "user1@gmail.com",
    "name": "이름3",
    "birth": "2000-09-19",
    "address": "string",
    "gender": "MALE",
    "profile_img_url":
        "https://ffa49639e85dc6968888bcf619ca7f275e300699aa18058625c879e-apidata.googleusercontent.com/download/storage/v1/b/diviction/o/user-profile%2Fuser-profile_user-basic-icon.jpg?jk=Ac_6HjLwtvhTOWgmEa8Wl4X7MYowYtueJcIaeUeEq8UXXJ9Y95sqZOUmLanyaP2IeuchRm3-9g0G1ewUuOmgIbi_N3-HD1p418F3GwuuvVrhyUNuh4_mZ1GqRpzErJk-E5YUI52nynk63KsF5oDcrZlhkaiLQFIj2Y5F0l_XosB0g242B3WIUfL5xUY-e38H7K9kfHeRXyXZAig3IQFpdYhzSOHgCCsDLF1XJRvBRhBTnrnvpozQNdWE61_KFnuWU4mGAo3wewDDaOqUMfcPFy7shpvZpI8W2q2w2GpWpwLo9FNtNDKopFHgZrWLA2emj8BnIuokgp9pNhtb-n4c-5kGTsPHfXZhugp20Sqnh9fHTfMphn5pCCxBj7DMsdtI87930UcRK7g_iBNANtma542flnhEkmpADblYlB9Cnx8UICjIrINo2iR2Pz3C8G-jsXph4EIwwak8TNuV_7NootZMY1f2PQ4ohvCmjyepgCI_9HHvUXCVo_MidpN3XUlre1QlRDbfIOEyZIBaGKoEI8ujcHzc6lKAaNq-9CORDFrLOECI6VcB55AMHHSmFCx6zZovBleECbnnlflJgakntzzc0URehvBdKR-hiwzl52mrw93tO4spU0FZb9Q5R4SJmO5PlGfPIBnhX8SBTs_ZXhxL2N7qaRuFI8RrfQqx_mTsM3eNsLcgAFgNHVw8k_nYOF_1ZlDkvsEGlCwD1xUONJAfXofp6YBDdPIr6vOHPa_D78kXIfU-ODwGqOE5lka7uHd5GNvlw27GsmYpyITbhxkWF_8v1knd4Oy24X1roOzxjBKjPZADHHH78z_NSUaSCDGl3cw7BbvOIKsVyOzzr6cvOX1YDy-I-sL85WI-OyIN4R2bwJZfCpR4s6D28En6m393D95THfWErB2-d4Po3BXkj5A_fhb07-vUPP2DN-Ec7iyWMSLbUeLbPVc0W-ejNVNk1ovXqJ7zPpCbXy8qdccSBUKVrl9FrYqkdWaQH78csC32ZXlzf15CFswOKm1XpCUHDGYwd1UI8WLAPnJiqh6Qa92Jog8C0JXJYLRi2lrdaryZ-VB6Cpe9QsGIrHt56CjPwZB77Ha-aS7e1aZe1dnWdg3bLl-Dmhw2PDwm_DYbin1cT7Jm6_fydg8vVXC26BJw1PJQdFK-u2XaWkNktwhHYW-RorWd5P_PW2btP6ASVnzfXZK0gDMp_HQ87-tM5Xd_9mlgr3M8Dbxfdv4-f6zaeo2jMnEM5OMGVz1ghU_z3zGKB7T9gyC9JIo4adYfULJwRxq-zNdTd9mSxYlCzIgSDPMNleryce_SXRK2SH1sL-kvBExFml1SK94nQwgWhO-JCmWvNh9E_2q4&isca=1"
  },
  {
    "id": 8,
    "email": "user10@gmail.com",
    "name": "이름4",
    "birth": "1992-08-09",
    "address": "string",
    "gender": "FEMALE",
    "profile_img_url":
        "https://ffa49639e85dc6968888bcf619ca7f275e300699aa18058625c879e-apidata.googleusercontent.com/download/storage/v1/b/diviction/o/user-profile%2Fuser-profile_user-basic-icon.jpg?jk=Ac_6HjLwtvhTOWgmEa8Wl4X7MYowYtueJcIaeUeEq8UXXJ9Y95sqZOUmLanyaP2IeuchRm3-9g0G1ewUuOmgIbi_N3-HD1p418F3GwuuvVrhyUNuh4_mZ1GqRpzErJk-E5YUI52nynk63KsF5oDcrZlhkaiLQFIj2Y5F0l_XosB0g242B3WIUfL5xUY-e38H7K9kfHeRXyXZAig3IQFpdYhzSOHgCCsDLF1XJRvBRhBTnrnvpozQNdWE61_KFnuWU4mGAo3wewDDaOqUMfcPFy7shpvZpI8W2q2w2GpWpwLo9FNtNDKopFHgZrWLA2emj8BnIuokgp9pNhtb-n4c-5kGTsPHfXZhugp20Sqnh9fHTfMphn5pCCxBj7DMsdtI87930UcRK7g_iBNANtma542flnhEkmpADblYlB9Cnx8UICjIrINo2iR2Pz3C8G-jsXph4EIwwak8TNuV_7NootZMY1f2PQ4ohvCmjyepgCI_9HHvUXCVo_MidpN3XUlre1QlRDbfIOEyZIBaGKoEI8ujcHzc6lKAaNq-9CORDFrLOECI6VcB55AMHHSmFCx6zZovBleECbnnlflJgakntzzc0URehvBdKR-hiwzl52mrw93tO4spU0FZb9Q5R4SJmO5PlGfPIBnhX8SBTs_ZXhxL2N7qaRuFI8RrfQqx_mTsM3eNsLcgAFgNHVw8k_nYOF_1ZlDkvsEGlCwD1xUONJAfXofp6YBDdPIr6vOHPa_D78kXIfU-ODwGqOE5lka7uHd5GNvlw27GsmYpyITbhxkWF_8v1knd4Oy24X1roOzxjBKjPZADHHH78z_NSUaSCDGl3cw7BbvOIKsVyOzzr6cvOX1YDy-I-sL85WI-OyIN4R2bwJZfCpR4s6D28En6m393D95THfWErB2-d4Po3BXkj5A_fhb07-vUPP2DN-Ec7iyWMSLbUeLbPVc0W-ejNVNk1ovXqJ7zPpCbXy8qdccSBUKVrl9FrYqkdWaQH78csC32ZXlzf15CFswOKm1XpCUHDGYwd1UI8WLAPnJiqh6Qa92Jog8C0JXJYLRi2lrdaryZ-VB6Cpe9QsGIrHt56CjPwZB77Ha-aS7e1aZe1dnWdg3bLl-Dmhw2PDwm_DYbin1cT7Jm6_fydg8vVXC26BJw1PJQdFK-u2XaWkNktwhHYW-RorWd5P_PW2btP6ASVnzfXZK0gDMp_HQ87-tM5Xd_9mlgr3M8Dbxfdv4-f6zaeo2jMnEM5OMGVz1ghU_z3zGKB7T9gyC9JIo4adYfULJwRxq-zNdTd9mSxYlCzIgSDPMNleryce_SXRK2SH1sL-kvBExFml1SK94nQwgWhO-JCmWvNh9E_2q4&isca=1"
  }
];

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
      future: MatchService().getMatchList(6),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return ListView.builder(
                itemCount: matches.length,
                itemBuilder: (BuildContext context, int index) {
                  final person = data[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage('${person['profile_img_url']}'),
                    ),
                    title: Text('${person['name']}'),
                    subtitle: Text('${person['birth']}, ${person['address']}'),
                    onTap: () {
                      // 각 항목을 눌렀을 때 동작할 코드
                    },
                  );
                },
              );
              // Text('${match['matchId']}, ${match['counselorEmail']}, ${match['patientEmail']}');
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Text('No data');
        }
      },
    );
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
