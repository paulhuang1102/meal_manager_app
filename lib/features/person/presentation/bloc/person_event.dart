import 'package:equatable/equatable.dart';
import '../../domain/entities/person.dart';

abstract class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object?> get props => [];
}

class PersonLoadEvent extends PersonEvent {}

class PersonAddEvent extends PersonEvent {
  final Person person;

  const PersonAddEvent(this.person);

  @override
  List<Object> get props => [person];
}

class PersonUpdateEvent extends PersonEvent {
  final Person person;

  const PersonUpdateEvent(this.person);

  @override
  List<Object> get props => [person];
}

class PersonDeleteEvent extends PersonEvent {
  final String id;

  const PersonDeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}

class PersonSearchEvent extends PersonEvent {
  final String? name;
  final int? minAge;
  final int? maxAge;
  final int? birthMonth;

  const PersonSearchEvent({
    this.name,
    this.minAge,
    this.maxAge,
    this.birthMonth,
  });

  @override
  List<Object?> get props => [name, minAge, maxAge, birthMonth];
}

class PersonClearSearchEvent extends PersonEvent {}
