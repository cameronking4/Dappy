import 'package:flutter/foundation.dart';

class BaseProvider with ChangeNotifier {
  bool isLoading = false;
  setViewState(bool val) {
    isLoading = val;
    notifyListeners();
  }
}
