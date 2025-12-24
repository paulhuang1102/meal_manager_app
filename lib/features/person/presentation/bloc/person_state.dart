import 'package:equatable/equatable.dart';
import '../../domain/entities/person.dart';

abstract class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object?> get props => [];
}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> persons;
  final bool isSearching;

  const PersonLoaded(this.persons, {this.isSearching = false});

  @override
  List<Object> get props => [persons, isSearching];
}

class PersonError extends PersonState {
  final String message;

  const PersonError(this.message);

  @override
  List<Object> get props => [message];
}

class PersonOperationSuccess extends PersonState {
  final String message;

  const PersonOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
