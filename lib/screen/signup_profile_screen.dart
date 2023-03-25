import 'dart:io';

import 'package:diviction_counselor/service/auth_service.dart';
import 'package:diviction_counselor/widget/custom_round_button.dart';
import 'package:diviction_counselor/widget/profile_image.dart';
import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/screen/login_screen.dart';
import 'package:diviction_counselor/widget/title_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../widget/edit_profile_image.dart';

enum SignupState { proceeding, success, fail, apifail }

final SignupProvider =
    StateProvider<SignupState>((ref) => SignupState.proceeding);

final imageProvider = StateProvider<String?>((ref) => null);

class SignUpProfileScreen extends ConsumerStatefulWidget {
  final String id;
  final String password;

  const SignUpProfileScreen({
    Key? key,
    required this.id,
    required this.password,
  }) : super(key: key);

  @override
  SignUpProfileScreenState createState() => SignUpProfileScreenState();
}

class SignUpProfileScreenState extends ConsumerState<SignUpProfileScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime defaultDate = DateTime(
      DateTime.now().year - 19, DateTime.now().month, DateTime.now().day);

  // 회원가입시 프로필 이미지의 path를 DB에 저장하고 프로필 탭에서 DB에 접근하여 사진 로딩하기.
  bool isChoosedPicture = false;
  String path = 'asset/image/DefaultProfileImage.png';
  XFile? ImageFile;

  bool isGenderchoosed = false;
  String userGender = 'MALE';

  TextEditingController textEditingController_name = TextEditingController();
  TextEditingController textEditingController_birth = TextEditingController();
  TextEditingController textEditingController_address = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    ref.invalidate(SignupProvider);
    ref.invalidate(imageProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = ref.watch(SignupProvider);
    final userImage = ref.watch(imageProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (isComplete) {
        case SignupState.success:
          ref.invalidate(authProvider);
          showSnackbar('Sign up success');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => LoginScreen()));
          break;
        case SignupState.fail:
          showSnackbar('Sign up failed');
          break;
        case SignupState.apifail:
          showSnackbar('Sign up api failed');
          break;
        default:
      }
    });

    // GestureDetector를 최상단으로 두고, requestFocus(FocusNode())를 통해서 키보드를 닫을 수 있음.
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.11),
              TitleHeader(
                titleContext: 'Profile',
                subContext: '',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              EditProfileImage(
                onProfileImagePressed: onProfileImagePressed,
                path: userImage,
                type: 1,
                imageSize: MediaQuery.of(context).size.height * 0.12,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _CustomInputField(
                HintText: 'Name',
                inputIcons: Icons.person_outline,
                textEditingController: textEditingController_name,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              _CustomInputField(
                HintText: 'Date of Birth',
                inputIcons: Icons.cake_outlined,
                textEditingController: textEditingController_birth,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              _DatePicker(
                onDateTimeChanged: onDateTimeChanged,
                selectedDate: selectedDate,
                defaultDate: defaultDate,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              _CustomInputField(
                HintText: 'Street Address',
                inputIcons: Icons.home_outlined,
                textEditingController: textEditingController_address,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              _GenderChoosed(
                onGenderChoosedMale: onGenderChoosedMale,
                onGenderChoosedFemale: onGenderChoosedFemale,
                userGender: userGender,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              CustomRoundButton(
                  title: 'Profile completed!',
                  onPressed: () => onPressedSignupButton(userImage)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  onDateTimeChanged(DateTime value) {
    setState(() {
      selectedDate = value;
      textEditingController_birth.text =
          '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
    });
  }

  onProfileImagePressed() async {
    print("onProfileImagePressed 실행완료");
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        this.isChoosedPicture = true;
        this.path = image.path;
        this.ImageFile = image;
      });
    }
    // print(image);
  }

  onGenderChoosedMale() {
    setState(() {
      isGenderchoosed = true;
      userGender = 'MALE';
    });
    print(userGender);
  }

  onGenderChoosedFemale() {
    setState(() {
      isGenderchoosed = true;
      userGender = 'FEMALE';
    });
    print(userGender);
  }

  onPressedSignupButton(String? image) async {
    print('프로필 완성 버튼 눌림');
    print('email : $widget.id');
    print('password : $widget.password');
    print('이름 : ${textEditingController_name.text}');
    print('생년월일 : ${textEditingController_birth.text}');
    print('주소 : ${textEditingController_address.text}');
    print('성별 : ${userGender}');
    print('프로필 이미지 경로 : ${path}');

    Map<String, String> counselor = {
      'email': widget.id,
      'password': widget.password,
      'name': 'name', // textEditingControllerForName.text
      'address': 'address', // textEditingControllerForAddress.text
      'birth': textEditingController_birth.text,
      'gneder': userGender,
      // 'confirm': false,
    };
    try {
      if(image != null) {
        ref.read(authProvider.notifier).SignupWithloadImage(image, counselor);
      }
      // bool result = await AuthService().signUp(counselor);
      // if (result) {
      //   ref.read(SignupProvider.notifier).state = SignupState.success;
      // } else {
      //   ref.read(SignupProvider.notifier).state = SignupState.fail;
      // }
    } catch (e) {
      ref.read(SignupProvider.notifier).state = SignupState.apifail;
    }
  }
}

class _CustomInputField extends StatelessWidget {
  final HintText;
  final textEditingController;
  final inputIcons;

  const _CustomInputField({
    Key? key,
    required this.HintText,
    required this.textEditingController,
    required this.inputIcons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(56),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              inputIcons,
              size: 30,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Expanded(
              child: TextField(
                controller: textEditingController,
                cursorColor: Colors.grey,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none, // TextField 아래 밑줄 제거
                  hintText: HintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime defaultDate;
  final ValueChanged<DateTime> onDateTimeChanged;
  const _DatePicker({
    Key? key,
    required this.onDateTimeChanged,
    required this.selectedDate,
    required this.defaultDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ScrollDatePicker(
        selectedDate:
            selectedDate == DateTime.now() ? defaultDate : selectedDate,
        locale: Locale('ko'),
        onDateTimeChanged: onDateTimeChanged,
      ),
    );
  }
}

class _GenderChoosed extends StatelessWidget {
  final String userGender;
  final VoidCallback onGenderChoosedMale;
  final VoidCallback onGenderChoosedFemale;

  const _GenderChoosed({
    Key? key,
    required this.userGender,
    required this.onGenderChoosedMale,
    required this.onGenderChoosedFemale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GenderButton(
          gender: 'Male',
          onGenderChoosed: onGenderChoosedMale,
          userGender: userGender,
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        GenderButton(
          gender: 'Female',
          onGenderChoosed: onGenderChoosedFemale,
          userGender: userGender,
        ),
      ],
    );
  }
}

class GenderButton extends StatelessWidget {
  final String gender;
  final String userGender;
  final VoidCallback onGenderChoosed;

  const GenderButton({
    Key? key,
    required this.gender,
    required this.userGender,
    required this.onGenderChoosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.055,
        child: ElevatedButton(
          onPressed: onGenderChoosed,
          style: ElevatedButton.styleFrom(
            // 메인 컬러 - 배경색
            primary: (userGender[0] == gender[0])
                ? Colors.blue[300]
                : Color(0xFFEEEEEE),
            // 서브 컬러 - 글자 및 글자 및 애니메이션 색상
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
              side: BorderSide(width: 1, color: Colors.black12),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
          child: Text(gender),
        ),
      ),
    );
  }
}
