import 'dart:async';
import 'dart:collection';

//import 'package:bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:meta/meta.dart';

part 'consumption_entry_state.dart';

class ConsumptionEntryCubit extends Cubit<ConsumptionEntryState> {
  ConsumptionEntryCubit() : super(ConsumptionEntryInitial()) {
    firestore.collection('consumptionEntries').snapshots().listen(
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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<ConsumptionEntry> all() => UnmodifiableListView([
        ConsumptionEntry(
          distance: 0,
          volume: 0,
          petrolPrice: 0,
        )
      ]);

  addEntry(ConsumptionEntry entry) {
//    _consumptionEntries.add(entry);
//    ConsumptionEntryData(entries);
    print('add entries');
  }

  deleteEntry(ConsumptionEntry entry) {
//    _consumptionEntries.remove(entry);
//    ConsumptionEntryData(entries);
    print('remove entries');
  }

//  emitEntries(List<ConsumptionEntry> entries) {
//    _entriesController.add(UnmodifiableListView(entries));
//  }

//  @override
//  Future<void> close() {
//    _entriesController.close();
//    return super.close();
//  }
}
