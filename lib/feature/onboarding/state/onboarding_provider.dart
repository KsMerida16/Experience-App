import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedInterestsProvider =
    NotifierProvider<InterestsNotifier, List<String>>(() {
      return InterestsNotifier();
    });

class InterestsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void toggleInterest(String interest) {
    if (state.contains(interest)) {
      state = state.where((item) => item != interest).toList();
    } else {
      state = [...state, interest];
    }
  }
}
