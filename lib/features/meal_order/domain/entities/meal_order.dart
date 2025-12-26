import 'package:equatable/equatable.dart';

enum MealType {
  breakfast,
  lunch,
  dinner,
}

class MealOrder extends Equatable {
  final String id;
  final String personId;
  final String personName;
  final MealType mealType;
  final DateTime orderDate;

  const MealOrder({
    required this.id,
    required this.personId,
    required this.personName,
    required this.mealType,
    required this.orderDate,
  });

  @override
  List<Object> get props => [id, personId, personName, mealType, orderDate];
}
