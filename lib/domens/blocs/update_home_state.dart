import 'package:equatable/equatable.dart';

abstract class MyState extends Equatable {
  const MyState();

  @override
  List<Object?> get props => [];
}

class ScreenUpdatedState extends MyState {
  final bool isTrue;

  const ScreenUpdatedState(this.isTrue);

  @override
  List<Object?> get props => [isTrue];
}
