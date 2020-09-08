import 'package:flutter/cupertino.dart';

class ConsumptionEntry {
  final double kilometers;
  final double litres;
  final double petrolPrice;
  final DateTime date;

  ConsumptionEntry(
      {@required this.kilometers,
      @required this.litres,
      @required this.petrolPrice,
      this.date});
}
