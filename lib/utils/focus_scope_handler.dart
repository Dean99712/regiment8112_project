import 'package:flutter/cupertino.dart';

void handleFocusScopeNode(BuildContext context, FocusScopeNode focusScope) {
  focusScope = FocusScope.of(context);
  if (!focusScope.hasPrimaryFocus) {
    focusScope.unfocus();
  }
}
