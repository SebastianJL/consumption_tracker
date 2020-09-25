import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:consumption_tracker/src/overview_tab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consumption_tracker/src/charts_tab.dart';

const appName = 'Consumption Tracker';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ConsumptionTracker());
}

class ConsumptionTracker extends StatelessWidget {
  final _firebaseInit = Firebase.initializeApp();

  final appTheme =  ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        primaryColor: Colors.pinkAccent,
        accentColor: Colors.lightBlue,
        errorColor: Colors.amber,
        buttonTheme: ButtonThemeData(
          splashColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appTheme,
        home: FutureBuilder(
            future: _firebaseInit,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return BlocProvider(
                  create: (context) => ConsumptionEntryCubit(),
                  child: HomePage(),
                );
              } else {
                return Center(child: Text('Initializing Firebase.'));
              }
            }));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(),
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

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: DrawerHeader(
              child: Column(
                children: [
                  Expanded(
                      child:
                          Image.asset('assets/icons8-odometer-white-100.png')),
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
            applicationIcon: SizedBox(
                width: 90,
                child: Image.asset("assets/icons8-odometer-100.png")),
            aboutBoxChildren: [
              Text('App icon provided by Icons8, see https://icons8.com')
            ],
          )
        ],
      ),
    );
  }
}
