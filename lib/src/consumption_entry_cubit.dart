import 'dart:async';
import 'dart:collection';

//import 'package:bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:meta/meta.dart';

part 'consumption_entry_state.dart';

class ConsumptionEntryCubit extends Cubit<ConsumptionEntryState> {
  ConsumptionEntryCubit() : super(ConsumptionEntryInitial()) {
    _entriesController.add(_consumptionEntries);
  }

  final _entriesController =
      StreamController<List<ConsumptionEntry>>.broadcast();

  final _consumptionEntries = <ConsumptionEntry>[
    ConsumptionEntry(kilometers: 86606, litres: 15.28, petrolPrice: 21.85),
    ConsumptionEntry(kilometers: 86882, litres: 18.82, petrolPrice: 25.45),
    ConsumptionEntry(kilometers: 87150, litres: 12.32, petrolPrice: 15.24),

  ];

  Stream<List<ConsumptionEntry>> get stream => _entriesController.stream;

  List<ConsumptionEntry> all() => UnmodifiableListView(_consumptionEntries);

  addEntry(ConsumptionEntry entry) {
    _consumptionEntries.add(entry);
    emitEntries();
  }

  deleteEntry(ConsumptionEntry entry) {
    _consumptionEntries.remove(entry);
    emitEntries();
  }

  emitEntries() {
    _entriesController.add(UnmodifiableListView(_consumptionEntries));
  }

  @override
  Future<void> close() {
    _entriesController.close();
    return super.close();
  }
}
