import 'package:diviction_counselor/screen/bottom_navigation/ProfileTab/profile_screen.dart';
import 'package:diviction_counselor/screen/matchlist_screen.dart';
import 'package:diviction_counselor/screen/memo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/bottom_nav_provider.dart';
import '../service/chat_service.dart';
import 'chatlist_screen.dart';

final bottomNavProvider =
    StateNotifierProvider<BottomNavState, int>((ref) => BottomNavState());

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color selected = Color.fromRGBO(63, 66, 72, 1);
    const Color unSelected = Color.fromRGBO(204, 210, 223, 1);
    final currentPage = ref.watch(bottomNavProvider);

    return Scaffold(
      body: SafeArea(
        child: [MatchListScreen(), MemberListScreen(), MemoScreen(),  ProfileScreen()]
            .elementAt(currentPage),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            _BottomNavigationBarItems(Icons.home, 'Home', selected, unSelected),
            _BottomNavigationBarItems(Icons.chat, 'Counselor', selected, unSelected),
            _BottomNavigationBarItems(Icons.chat, 'Counselor', selected, unSelected),
            _BottomNavigationBarItems(Icons.account_circle_rounded, 'MyPage', selected, unSelected),
          ],
          currentIndex: currentPage,
          selectedItemColor: selected,
          unselectedItemColor: unSelected,
          onTap: (index) {
            ref.read(bottomNavProvider.notifier).state = index;
          }),
    );
  }

  BottomNavigationBarItem _BottomNavigationBarItems(IconData icon, String label, Color selected, Color unSelected) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: unSelected,
        ),
        activeIcon: Icon(
          icon,
          color: selected,
        ),
        label: label);
  }
}
