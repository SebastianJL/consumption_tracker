import 'dart:collection';

import 'package:consumption_tracker/src/consumption_entry_form.dart';
import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OverviewTab extends StatefulWidget {
  @override
  _OverviewTabState createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        ConsumptionEntryForm(),
        Expanded(child: ConsumptionEntryList()),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ConsumptionEntryList extends StatelessWidget {
  final distanceFormat = NumberFormat('###,###km');
  final pricePerLiterFormat = NumberFormat('#0.00 CHF/l');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumptionEntryCubit, ConsumptionEntryState>(
      builder: (context, state) {
        UnmodifiableListView<ConsumptionEntry> consumptionEntries;
        if (state is ConsumptionEntryData) {
          consumptionEntries = state.entries;
          if (consumptionEntries.isEmpty) {
            return Center(child: Text('NoData'));
          }
          return ListView.builder(
            itemCount: consumptionEntries.length,
            itemBuilder: (context, index) {
              final entry = consumptionEntries[index];
              return Dismissible(
                key: GlobalKey(),
                child: ListTile(
                  title: Text('${distanceFormat.format(entry.distance)}'),
                  subtitle: Text(
                    '${pricePerLiterFormat.format(entry.petrolPrice / entry.volume)}',
                  ),
                  trailing: Icon(Icons.delete_sweep),
                ),
                confirmDismiss: (_) => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    var nav = Navigator.of(context);
                    return AlertDialog(
                      title: Text('Delete entry?'),
                      actions: [
                        FlatButton(
                            child: Text('No'), onPressed: () => nav.pop(false)),
                        FlatButton(
                            child: Text('Yes'), onPressed: () => nav.pop(true)),
                      ],
                    );
                  },
                ),
                onDismissed: (_) =>
                    BlocProvider.of<ConsumptionEntryCubit>(context)
                        .deleteEntry(entry),
                direction: DismissDirection.endToStart,
                background: Container(color: Colors.red),
              );
            },
          );
        } else if (state is ConsumptionEntryError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('Error: unknown'));
        }
      },
    );
  }
}
