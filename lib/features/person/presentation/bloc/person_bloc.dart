import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_person.dart';
import '../../domain/usecases/delete_person.dart';
import '../../domain/usecases/get_persons.dart';
import '../../domain/usecases/search_persons.dart';
import '../../domain/usecases/update_person.dart';
import 'person_event.dart';
import 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final GetPersons getPersons;
  final AddPerson addPerson;
  final UpdatePerson updatePerson;
  final DeletePerson deletePerson;
  final SearchPersons searchPersons;

  PersonBloc({
    required this.getPersons,
    required this.addPerson,
    required this.updatePerson,
    required this.deletePerson,
    required this.searchPersons,
  }) : super(PersonInitial()) {
    on<PersonLoadEvent>(_onLoad);
    on<PersonAddEvent>(_onAdd);
    on<PersonUpdateEvent>(_onUpdate);
    on<PersonDeleteEvent>(_onDelete);
    on<PersonSearchEvent>(_onSearch);
    on<PersonClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onLoad(
    PersonLoadEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());

    final result = await getPersons(NoParams());

    result.fold(
      (failure) => emit(PersonError(failure.message)),
      (persons) => emit(PersonLoaded(persons)),
    );
  }

  Future<void> _onAdd(
    PersonAddEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());

    final result = await addPerson(AddPersonParams(event.person));

    await result.fold(
      (failure) async => emit(PersonError(failure.message)),
      (_) async {
        emit(const PersonOperationSuccess('Person added successfully'));
        final personsResult = await getPersons(NoParams());
        personsResult.fold(
          (failure) => emit(PersonError(failure.message)),
          (persons) => emit(PersonLoaded(persons)),
        );
      },
    );
  }

  Future<void> _onUpdate(
    PersonUpdateEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());

    final result = await updatePerson(UpdatePersonParams(event.person));

    await result.fold(
      (failure) async => emit(PersonError(failure.message)),
      (_) async {
        emit(const PersonOperationSuccess('Person updated successfully'));
        final personsResult = await getPersons(NoParams());
        personsResult.fold(
          (failure) => emit(PersonError(failure.message)),
          (persons) => emit(PersonLoaded(persons)),
        );
      },
    );
  }

  Future<void> _onDelete(
    PersonDeleteEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());

    final result = await deletePerson(DeletePersonParams(event.id));

    await result.fold(
      (failure) async => emit(PersonError(failure.message)),
      (_) async {
        emit(const PersonOperationSuccess('Person deleted successfully'));
        final personsResult = await getPersons(NoParams());
        personsResult.fold(
          (failure) => emit(PersonError(failure.message)),
          (persons) => emit(PersonLoaded(persons)),
        );
      },
    );
  }

  Future<void> _onSearch(
    PersonSearchEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());

    final result = await searchPersons(
      SearchPersonsParams(
        name: event.name,
        minAge: event.minAge,
        maxAge: event.maxAge,
        birthMonth: event.birthMonth,
      ),
    );

    result.fold(
      (failure) => emit(PersonError(failure.message)),
      (persons) => emit(PersonLoaded(persons, isSearching: true)),
    );
  }

  Future<void> _onClearSearch(
    PersonClearSearchEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());

    final result = await getPersons(NoParams());

    result.fold(
      (failure) => emit(PersonError(failure.message)),
      (persons) => emit(PersonLoaded(persons)),
    );
  }
}