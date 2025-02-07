import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Data Siswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 8, 255)),
        useMaterial3: true,
      ),
      home: const StudentFormPage(),
    );
  }
}

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _classesController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();

  final List<Map<String, String>> _students = [];
  bool isEditing = false; // Menandakan apakah kita dalam mode edit
  int? editingIndex; // Menyimpan index data yang sedang diedit

  final _formKey = GlobalKey<FormState>(); // Form key untuk validasi

  void _addStudent() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (isEditing && editingIndex != null) {
          // Update data siswa jika sedang dalam mode edit
          _students[editingIndex!] = {
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'classes': _classesController.text,
            'major': _majorController.text,
          };
          isEditing = false;
          editingIndex = null;
        } else {
          // Menambah siswa baru
          _students.add({
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'classes': _classesController.text,
            'major': _majorController.text,
          });
        }

        // Clear input fields
        _firstNameController.clear();
        _lastNameController.clear();
        _classesController.clear();
        _majorController.clear();
      });
    }
  }

  void _deleteStudent(int index) {
    setState(() {
      _students.removeAt(index);

      // Jika sedang dalam mode edit dan baris yang diedit dihapus, reset input fields dan tombol kembali ke Kirim
      if (isEditing && editingIndex == index) {
        isEditing = false;
        editingIndex = null;
        _firstNameController.clear();
        _lastNameController.clear();
        _classesController.clear();
        _majorController.clear();
      }
    });
  }

  void _editStudent(int index) {
    setState(() {
      // Set input fields with existing student data for editing
      _firstNameController.text = _students[index]['firstName'] ?? '';
      _lastNameController.text = _students[index]['lastName'] ?? '';
      _classesController.text = _students[index]['classes'] ?? '';
      _majorController.text = _students[index]['major'] ?? '';
      isEditing = true;
      editingIndex = index; // Save the index of the student being edited
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Data Siswa'),
        backgroundColor: Colors.purple[100],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Form key untuk validasi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _classesController,
                  decoration: const InputDecoration(
                    labelText: 'Classes',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Classes is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _majorController,
                  decoration: const InputDecoration(
                    labelText: 'Major',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Major is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _addStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 102, 100, 129),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 16.0,
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Update' : 'Kirim', // Tombol akan berubah tergantung status isEditing
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Data Siswa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _students.isEmpty
                    ? const Text('Belum ada data siswa.')
                    : Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(1),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Color.fromARGB(255, 66, 66, 66)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('First Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Last Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Class',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Major',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Actions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ],
                          ),
                          ..._students.asMap().entries.map(
                            (entry) {
                              int index = entry.key;
                              Map<String, String> student = entry.value;
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(student['firstName'] ?? ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(student['lastName'] ?? ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(student['classes'] ?? ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(student['major'] ?? ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _editStudent(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _deleteStudent(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}