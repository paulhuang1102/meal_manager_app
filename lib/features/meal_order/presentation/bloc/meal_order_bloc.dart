import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/meal_order.dart';
import '../../domain/usecases/get_meal_orders.dart';
import '../../domain/usecases/add_meal_order.dart';
import '../../domain/usecases/delete_meal_order.dart';
import '../../../../core/usecases/usecase.dart';

part 'meal_order_event.dart';
part 'meal_order_state.dart';

class MealOrderBloc extends Bloc<MealOrderEvent, MealOrderState> {
  final GetMealOrders getMealOrders;
  final AddMealOrder addMealOrder;
  final DeleteMealOrder deleteMealOrder;

  MealOrderBloc({
    required this.getMealOrders,
    required this.addMealOrder,
    required this.deleteMealOrder,
  }) : super(MealOrderInitial()) {
    on<MealOrderLoadEvent>(_onLoad);
    on<MealOrderToggleEvent>(_onToggle);
  }

  Future<void> _onLoad(
    MealOrderLoadEvent event,
    Emitter<MealOrderState> emit,
  ) async {
    emit(MealOrderLoading());

    final result = await getMealOrders(NoParams());

    result.fold(
      (failure) => emit(MealOrderError(failure.message)),
      (orders) => emit(MealOrderLoaded(orders)),
    );
  }

  Future<void> _onToggle(
    MealOrderToggleEvent event,
    Emitter<MealOrderState> emit,
  ) async {
    if (state is! MealOrderLoaded) return;

    final currentOrders = (state as MealOrderLoaded).orders;

    // Check if order already exists for this person and meal type
    MealOrder? existingOrder;
    try {
      existingOrder = currentOrders.firstWhere(
        (order) =>
            order.personId == event.personId &&
            order.mealType == event.mealType,
      );
    } catch (e) {
      existingOrder = null;
    }

    if (existingOrder != null) {
      final deleteResult = await deleteMealOrder(
        DeleteMealOrderParams(id: existingOrder.id),
      );

      deleteResult.fold(
        (failure) => emit(MealOrderError(failure.message)),
        (_) => add(MealOrderLoadEvent()),
      );
    } else {
     final newOrder = MealOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        personId: event.personId,
        personName: event.personName,
        mealType: event.mealType,
        orderDate: DateTime.now(),
      );

      final addResult = await addMealOrder(
        AddMealOrderParams(order: newOrder),
      );

      addResult.fold(
        (failure) => emit(MealOrderError(failure.message)),
        (_) => add(MealOrderLoadEvent()),
      );
    }
  }
}
