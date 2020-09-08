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
    final ConsumptionEntryCubit consumptionEntryCubit =
        BlocProvider.of<ConsumptionEntryCubit>(context);
    return StreamBuilder(
      stream: consumptionEntryCubit.stream,
      builder: (context, snapshot) {
        UnmodifiableListView<ConsumptionEntry> consumptionEntries;
        if (!snapshot.hasData) {
          consumptionEntries = consumptionEntryCubit.all();
        } else {
          consumptionEntries = snapshot.data;
        }
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
                    '${entry.kilometers}km, ${entry.litres}L, ${entry.petrolPrice}Fr'),
                subtitle: Text('${entry.date}'),
                trailing: Icon(Icons.delete_sweep),
              ),
              onDismissed: (direction) =>
                  consumptionEntryCubit.deleteEntry(entry),
              direction: DismissDirection.endToStart,
              background: Container(color: Colors.red),
            );
          },
        );
      },
    );
  }
}
