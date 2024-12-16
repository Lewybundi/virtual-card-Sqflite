import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'barnav_riv.g.dart';

@riverpod
class BottomNav extends _$BottomNav {
  @override
  int build() {
    return 0;
  }
  void indexValue(int index){
    state =index;
  }
}