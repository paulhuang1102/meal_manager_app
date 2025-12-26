import '../../domain/entities/meal_order.dart';

class MealOrderModel extends MealOrder {
  const MealOrderModel({
    required super.id,
    required super.personId,
    required super.personName,
    required super.mealType,
    required super.orderDate,
  });

  factory MealOrderModel.fromJson(Map<String, dynamic> json) {
    return MealOrderModel(
      id: json['id'] as String,
      personId: json['personId'] as String,
      personName: json['personName'] as String,
      mealType: MealType.values.firstWhere(
        (e) => e.toString() == json['mealType'],
      ),
      orderDate: DateTime.parse(json['orderDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'personName': personName,
      'mealType': mealType.toString(),
      'orderDate': orderDate.toIso8601String(),
    };
  }

  factory MealOrderModel.fromEntity(MealOrder order) {
    return MealOrderModel(
      id: order.id,
      personId: order.personId,
      personName: order.personName,
      mealType: order.mealType,
      orderDate: order.orderDate,
    );
  }
}
