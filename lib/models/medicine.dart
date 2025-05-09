import 'package:hive/hive.dart';

part 'medicine.g.dart'; // This line is important for code generation

@HiveType(typeId: 0)
class Medicine extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) String medtype;
  @HiveField(2) String brand;
  @HiveField(3) int quantity;
  @HiveField(4) double stock;
  @HiveField(5) String uses;
  @HiveField(6) String sideEffects;
  @HiveField(7) String ingredients;
  @HiveField(8) String directions;
  @HiveField(9) String warnings;

  Medicine({
    required this.name,
    required this.medtype,
    required this.brand,
    required this.quantity,
    required this.stock,
    required this.uses,
    required this.sideEffects,
    required this.ingredients,
    required this.directions,
    required this.warnings,
  });
}
