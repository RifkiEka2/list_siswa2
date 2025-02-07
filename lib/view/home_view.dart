import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:siswa_app/utils/services.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List data = [];
  List<String> classess = ['X', 'XI', 'XII'];
  late String classValue = classess.first.toString();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController major = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataFormAPI().then((onValue) async {
      setState(() => data = onValue['data']);
    });
  }

  Future<Map<String, dynamic>> getDataFormAPI() => Services().getData();

  onSubmit(context) async {
    Services()
        .postData(classValue, major.text, firstName.text, lastName.text)
        .then((onResponse) {
      String message = onResponse['data']['message'].toString();
      if (onResponse['status'] == 422) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Succes'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      getDataFormAPI().then((onValue) async {
        setState(() => data = onValue['data']);
      });
    });
  }

  // Future<void> getData() async {
  //   var url = Uri.parse('https://test123.alapalap.fun/api/student');
  //   await http.get(url).then((response) async {
  //     var jsonData = await jsonDecode(response.body);
  //     setState(() => data = jsonData['data']);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: screenHeight * 0.5,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: firstName,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(4.0),
                            hintText: 'First Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: lastName,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(4.0),
                            hintText: 'Last Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          value: classValue,
                          onChanged: (val) {
                            setState(() {
                              classValue = val.toString();
                            });
                          },
                          items: classess.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: major,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(4.0),
                            hintText: 'Major',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Submit'),
                        ),
                      )
                    ]),
                  );
                });
              });
        },
        child: const Icon(Icons.add),
      ),
      if (data.isEmpty) ...[const Text('Loading...')],
      for (int idx = 0; idx < data.length; idx++) ...[
        Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(data[idx]['fname'],
                        style: const TextStyle(color: Colors.white)),
                    Text(data[idx]['lname'],
                        style: const TextStyle(color: Colors.white)),
                  ],
                )))
      ]
    ]);
  }
}
