import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../model/network_result.dart';
import '../network/dio_client.dart';

class ChecklistService {
  static final ChecklistService _authService = ChecklistService._internal();
  factory ChecklistService() {
    return _authService;
  }
  ChecklistService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<bool> saveChecklist(int userId, List<String> checklist) async {
    try {
      checklist.forEach((element) async {
        NetWorkResult result = await DioClient().request(
            'post',
            '$_baseUrl/checklist/save',
            {
              {
                "patientId": 0,
                "startDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
                "endDate": DateFormat('yyyy-MM-dd')
                    .format(DateTime.now().add(Duration(days: 30))),
                "content": element
              }
            },
            true);
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
