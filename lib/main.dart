import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:consumption_tracker/src/overview_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consumption_tracker/src/charts_tab.dart';

void main() {
  runApp(ConsumptionTracker());
}

class ConsumptionTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => ConsumptionEntryCubit(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ConsumptionTracker'),
          bottom: TabBar(tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Charts'),
          ]),
        ),
        body: TabBarView(
          children: [
            OverviewTab(),
            ChartsTab(),
          ],
        ),
      ),
    );
  }
}
