import 'dart:collection';

import 'package:consumption_tracker/src/consumption_entry_form.dart';
import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
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
        Expanded(
          child: BlocBuilder<ConsumptionEntryCubit, ConsumptionEntryState>(
            builder: (context, state) {
              UnmodifiableListView<ConsumptionEntry> consumptionEntries;
              if (state is ConsumptionEntryData) {
                consumptionEntries = state.entries;
                if (consumptionEntries.isEmpty) {
                  return Center(child: Text('NoData'));
                } else {
                  return ConsumptionEntryList(consumptionEntries);
                }
              } else if (state is ConsumptionEntryError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return Center(child: Text('Error: unknown'));
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ConsumptionEntryList extends StatelessWidget {
  final distanceFormat = NumberFormat('###,###km');
  final pricePerLiterFormat = NumberFormat('#0.00 CHF/l');
  final litersPer100KmFormat = NumberFormat("#0.0 l/1'00'km");

  // final listKey = GlobalKey<AnimatedListState>();
  final List<ConsumptionEntry> entries;

  ConsumptionEntryList(this.entries, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedList<ConsumptionEntry>(
      items: entries,
      areItemsTheSame: (a, b) => a.id == b.id,
      itemBuilder: (context, animation, _, index) =>
          _buildListTile(context, index, animation),
    );
  }

  AnimatedWidget _buildListTile(
      BuildContext context, int index, Animation<double> animation) {
    final entry = entries[index];
    final previous = (index < entries.length - 1) ? entries[index + 1] : null;
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text('${distanceFormat.format(entry.distance)}'),
        subtitle: Text(
          '${pricePerLiterFormat.format(entry.pricePerLiter)}    '
          '${litersPer100KmFormat.format(entry.litersPer100Km(previous))}',
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            if (await _showConfirmDeletionDialog(context)) {
              BlocProvider.of<ConsumptionEntryCubit>(context)
                  .deleteEntry(entry);
            }
          },
        ),
      ),
    );
  }

  Future<bool> _showConfirmDeletionDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var nav = Navigator.of(context);
        return AlertDialog(
          title: Text('Delete entry?'),
          actions: [
            FlatButton(child: Text('No'), onPressed: () => nav.pop(false)),
            FlatButton(child: Text('Yes'), onPressed: () => nav.pop(true)),
          ],
        );
      },
    );
  }
}
