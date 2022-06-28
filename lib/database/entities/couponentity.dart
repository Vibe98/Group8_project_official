import 'package:floor/floor.dart';

@entity 
class CouponEntity{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? day;
  final int? month;
  final bool? present;
  final bool? used;
  
  CouponEntity(this.id, this.day, this.month, this.present, this.used);

}