import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ConsumptionEntry {
  final num distance;
  final num volume;
  final num petrolPrice;
  final DateTime date;
  final String id;

  ConsumptionEntry(
      {@required this.distance,
      @required this.volume,
      @required this.petrolPrice,
      this.date,
      this.id});

  factory ConsumptionEntry.fromSnapshot(QueryDocumentSnapshot element) {
    var data = element.data();
    return ConsumptionEntry(
      distance: data['distance'],
      volume: data['volume'],
      petrolPrice: data['petrolPrice'],
      date: data['date']?.toDate(),
      id: element.id,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'distance': distance,
      'volume': volume,
      'petrolPrice': petrolPrice,
      'date': date,
    };
  }

  double get pricePerLiter => petrolPrice / volume;

  double litersPer100Km(ConsumptionEntry previous) {
    if (previous == null) {
      return 0;
    }
    return volume / (distance - previous.distance) * 100;
  }
}
