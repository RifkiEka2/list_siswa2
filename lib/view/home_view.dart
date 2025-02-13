import 'package:flutter/material.dart';
import 'package:siswa_app/utils/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List data = [];
  List<String> classes = ['X', 'XI', 'XII'];
  late String classValue = classes.first;
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

  onSubmit(context) {
    Services()
        .postData(firstName.text, lastName.text, classValue, major.text)
        .then((onResponse) {
      String message = onResponse['data']['message'].toString();
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(onResponse['status'] == 422 ? 'Error!!' : 'Success!!'),
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
                onResponse['status'] == 422
                    ? null
                    : getDataFormAPI().then((onValue) async {
                        setState(() => data = onValue['data']);
                      });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
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
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
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
                          padding: const EdgeInsets.all(16.0),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: classValue.toString(),
                            onChanged: (val) =>
                                setState(() => classValue = val.toString()),
                            items: classes
                                .map<DropdownMenuItem<String>>((String value) {
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                elevation: 0,
                              ),
                              onPressed: () => onSubmit(context),
                              child: const Text(
                                "Submit",
                              )),
                        )
                      ]),
                    );
                  });
                });
          },
          child: const Icon(Icons.add),
        ),
        if (data.isEmpty) const Text('Loading...'),
        for (int idx = 0; idx < data.length; idx++) ...[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 100,
              color: Colors.blueAccent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "First Name: ${data[idx]['fname']}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text("Last Name: ${data[idx]['lname']}",
                              style: const TextStyle(color: Colors.white)),
                          Text("Major: ${data[idx]['major']}",
                              style: const TextStyle(color: Colors.white)),
                          Text("Classes: ${data[idx]['classes']}",
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Column(children: [
                      TextButton(
                          onPressed: () {}, child: const Icon(Icons.edit)),
                      TextButton(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Warning'),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'Are you sure you want to delete this student?'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () async {
                                      Services()
                                          .deleteData(data[idx]['id'])
                                          .then((onValue) {
                                        getDataFormAPI().then((onValue) async {
                                          setState(
                                              () => data = onValue['data']);
                                        });
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Icon(Icons.delete, color: Colors.white)),
                    ]),
                  ]),
            ),
          ),
        ],
      ],
    );
  }
}
