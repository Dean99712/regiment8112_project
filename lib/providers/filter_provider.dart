import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isGrouped = false;

final isGroupedProvider = StateProvider((ref) {
  return isGrouped;
});

