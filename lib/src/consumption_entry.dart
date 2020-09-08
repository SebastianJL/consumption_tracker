import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:flutter/cupertino.dart';

class ConsumptionEntry {
  final num distance;
  final num volume;
  final num petrolPrice;
  final DateTime date;

  ConsumptionEntry(
      {@required this.distance,
      @required this.volume,
      @required this.petrolPrice,
      this.date});

  factory ConsumptionEntry.fromSnapshot(QueryDocumentSnapshot element) {
    var data = element.data();
    return ConsumptionEntry(
      distance: data['distance'],
      volume: data['volume'],
      petrolPrice: data['petrolPrice'],
      date: DateTime.tryParse(data['date'] ?? ''),
    );
  }
}
