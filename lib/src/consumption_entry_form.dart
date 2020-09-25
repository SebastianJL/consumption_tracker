import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsumptionEntryForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConsumptionEntryFormState();
  }
}

class ConsumptionEntryFormState extends State<ConsumptionEntryForm> {
  final _formKey = GlobalKey<FormState>();
  var _entry = Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'km'),
                    keyboardType: TextInputType.number,
                    validator: (value) => validateNumeric(value),
                    onSaved: (newValue) =>
                        _entry['distance'] = double.parse(newValue),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'l'),
                    keyboardType: TextInputType.number,
                    validator: (value) => validateNumeric(value),
                    onSaved: (newValue) =>
                        _entry['volume'] = double.parse(newValue),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'CHF'),
                    keyboardType: TextInputType.number,
                    validator: (value) => validateNumeric(value),
                    onSaved: (newValue) =>
                        _entry['petrolPrice'] = double.parse(newValue),
                  ),
                ),
              ]),
              Row(children: [
                Expanded(
                  child: InputDatePickerFormField(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    onDateSaved: (value) => _entry['date'] = value,
                  ),
                ),
                RaisedButton(
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    var state = _formKey.currentState;
                    if (state.validate()) {
                      state.save();
                      var entry = ConsumptionEntry(
                        distance: _entry['distance'],
                        volume: _entry['volume'],
                        petrolPrice: _entry['petrolPrice'],
                        date: _entry['date'],
                      );
                      BlocProvider.of<ConsumptionEntryCubit>(context)
                          .addEntry(entry);
                      FocusScope.of(context).unfocus();
                      state.reset();
                    }
                  },
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}

String validateNumeric(String value) {
  return isNumeric(value) ? null : 'Must be numeric.';
}

bool isNumeric(String value) {
  if (value == null) {
    return false;
  }

  return num.tryParse(value) != null;
}
