import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:meta/meta.dart';

part 'consumption_entry_state.dart';

class ConsumptionEntryCubit extends Cubit<ConsumptionEntryState> {
  ConsumptionEntryCubit() : super(ConsumptionEntryInitial()) {
    _consumptionEntries
        .orderBy('distance', descending: true)
        .snapshots()
        .listen(
      (QuerySnapshot event) {
        List<ConsumptionEntry> entries = event.docs
            .map((QueryDocumentSnapshot element) =>
                ConsumptionEntry.fromSnapshot(element))
            .toList();
        emit(ConsumptionEntryData(entries));
      },
      onError: (Object error) => emit(ConsumptionEntryError(error.toString())),
      cancelOnError: true,
    );
  }

  final CollectionReference _consumptionEntries =
      FirebaseFirestore.instance.collection('consumptionEntries');

  Future<void> addEntry(ConsumptionEntry entry) {
    return _consumptionEntries.add(entry.toDocument());
  }

  Future<void> deleteEntry(ConsumptionEntry entry) {
    return _consumptionEntries.doc(entry.id).delete();
  }
}
