import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/meal_statistics.dart';
import '../../domain/usecases/get_meal_statistics.dart';
import '../../../../core/usecases/usecase.dart';

part 'meal_statistic_event.dart';
part 'meal_statistic_state.dart';

class MealStatisticBloc extends Bloc<MealStatisticEvent, MealStatisticState> {
  final GetStatistics getStatistics;

  MealStatisticBloc({required this.getStatistics})
      : super(MealStatisticInitial()) {
    on<MealStatisticLoadEvent>(_onLoad);
  }

  Future<void> _onLoad(
    MealStatisticLoadEvent event,
    Emitter<MealStatisticState> emit,
  ) async {
    emit(MealStatisticLoading());

    final result = await getStatistics(NoParams());

    result.fold(
      (failure) => emit(MealStatisticError(failure.message)),
      (statistics) => emit(MealStatisticLoaded(statistics)),
    );
  }
}
