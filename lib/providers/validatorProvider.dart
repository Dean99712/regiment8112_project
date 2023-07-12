import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValidatorNotifier extends StateNotifier<String> {
  ValidatorNotifier() : super("");

  String? validator(
      String value, String emptyText, String text, RegExp validator) {
    if (value.isEmpty) {
      return emptyText;
    }
    bool isValid = validator.hasMatch(value);
    if (!isValid) {
      print(text);
      return text;
    }
    return null;
  }

}

final validatorProvider = StateNotifierProvider<ValidatorNotifier,String >((ref) {
  return ValidatorNotifier();
});
