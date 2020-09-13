import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:consumption_tracker/src/overview_tab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consumption_tracker/src/charts_tab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ConsumptionTracker());
}

class ConsumptionTracker extends StatelessWidget {
  final _firebaseInit = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInit,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              theme: ThemeData(primaryColor: Colors.pinkAccent),
              home: BlocProvider(
                create: (context) => ConsumptionEntryCubit(),
                child: HomePage(),
              ),
            );
          }

          return MaterialApp(home: Center(child: Text('Loading')));

        });
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
