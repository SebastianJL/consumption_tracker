part of 'consumption_entry_cubit.dart';

@immutable
abstract class ConsumptionEntryState {}

class ConsumptionEntryInitial extends ConsumptionEntryState {}

class ConsumptionEntryError extends ConsumptionEntryState {
  final String message;

  ConsumptionEntryError(this.message);
}

class ConsumptionEntryData extends ConsumptionEntryState {
  final UnmodifiableListView<ConsumptionEntry> entries;

  ConsumptionEntryData(List<ConsumptionEntry> entries)
      : this.entries = UnmodifiableListView(entries);
}
