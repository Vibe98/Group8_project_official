import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:login_flow/database/entities/couponentity.dart';

@dao 
abstract class CouponDao{

  @insert //inserting
  Future<void> insertCoupon(CouponEntity coupon);

  @Query('SELECT * FROM CouponEntity WHERE day = :day AND month = :month')
  Future<CouponEntity?> findCoupon(int day, int month);

  @Query('SELECT * FROM CouponEntity')
  Future<List<CouponEntity>> findAllCoupons();

  @Query('SELECT * FROM CouponEntity WHERE id=(SELECT MAX(id) FROM CouponEntity)')
  Future<CouponEntity?> findLastCoupon();

  @Query('UPDATE CouponEntity SET present = :present WHERE day = :day AND month = :month')
  Future<void> updatePresent(bool present, int day, int month);

  @Query('UPDATE CouponEntity SET used = :used WHERE day = :day AND month = :month')
  Future<void> updateUsed(bool used, int day, int month);

  @Query('SELECT COUNT (*) FROM CouponEntity')
  Future<int?> numberOfCoupons();

  @Query('DELETE FROM CouponEntity')
  Future<void> deleteAllCoupons();

   @Query('DELETE FROM CouponEntity WHERE id=(SELECT MAX(id) FROM CouponEntity)')
  Future<void> deleteLastCoupon();

  

  

}