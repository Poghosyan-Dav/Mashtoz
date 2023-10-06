import 'package:equatable/equatable.dart';

abstract class MyEvent extends Equatable {
  const MyEvent();

  @override
  List<Object?> get props => [];
}

class UpdateScreenEvent extends MyEvent {
  final bool isTrue;

  const UpdateScreenEvent(this.isTrue);

  @override
  List<Object?> get props => [isTrue];
}