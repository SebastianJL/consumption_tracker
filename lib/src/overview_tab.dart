import 'dart:collection';

import 'package:consumption_tracker/src/consumption_entry_form.dart';
import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  title: Text(
                      '${entry.distance}km, ${entry.volume}L, ${entry.petrolPrice}Fr'),
                  subtitle: Text('${entry.date}'),
                  trailing: Icon(Icons.delete_sweep),
                ),
                onDismissed: (direction) =>
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
