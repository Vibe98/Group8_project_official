import 'package:floor/floor.dart';
import 'package:login_flow/database/entities/couponentity.dart';

@dao 
abstract class CouponDao{

  @insert //inserting
  Future<void> insertCoupon(CouponEntity coupon);

  @Query('SELECT * FROM CouponEntity WHERE day = :day AND month = :month')
  Future<CouponEntity?> findCoupon(int day, int month);

  @Query('SELECT * FROM CouponEntity WHERE present = :present AND used = :used')
  Future<List<CouponEntity>> findPresendAndUsedCoupons(bool present, bool used);  

  @Query('SELECT * FROM CouponEntity')
  Future<List<CouponEntity>> findAllCoupons();

  @Query('SELECT * FROM CouponEntity WHERE id=(SELECT MAX(id) FROM CouponEntity)')
  Future<CouponEntity?> findLastCoupon();

  @Query('UPDATE CouponEntity SET used = :used WHERE day = :day AND month = :month')
  Future<void> updateUsed(bool used, int day, int month);

  @Query('DELETE FROM CouponEntity')
  Future<void> deleteAllCoupons();

   @Query('DELETE FROM CouponEntity WHERE id=(SELECT MAX(id) FROM CouponEntity)')
  Future<void> deleteLastCoupon();

}