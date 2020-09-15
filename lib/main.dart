import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:consumption_tracker/src/overview_tab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consumption_tracker/src/charts_tab.dart';

const appName = 'ConsumptionTracker';

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
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                child: DrawerHeader(
                  child: Column(
                    children: [
                      Expanded(
                          child: Image.asset(
                              'assets/icons8-odometer-white-100.png')),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          appName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.motorcycle),
                title: Text('Vehicle 1'),
              ),
              ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('Vehicle 2'),
              ),
              Divider(),
              AboutListTile(
                child: Text('About'),
                icon: Icon(Icons.info_outline),
                applicationName: appName,
                dense: false,
                applicationIcon: Image.asset("assets/icons8-odometer-50.png"),
                aboutBoxChildren: [
                  Text('App icon provided by Icons8, see https://icons8.com')
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('BMW R1100R'),
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
