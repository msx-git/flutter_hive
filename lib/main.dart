import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'card_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('staff_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Hive Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _staffBox = Hive.box('staff_box');

  List<Map<String, dynamic>> _members = [];
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();

  final TextEditingController _positionTextController = TextEditingController();

  final TextEditingController _salaryTextController = TextEditingController();

  Future<void> _addMember(Map<String, dynamic> newMember) async {
    await _staffBox.add(newMember);
    _refreshMemberList();
  }

  Future<void> _updateMember(int memberKey, Map<String, dynamic> member) async {
    await _staffBox.put(memberKey, member);
    _refreshMemberList();
  }

  Future<void> _deleteMember(int memberKey) async {
    await _staffBox.delete(memberKey);
    _refreshMemberList();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Member has been deleted')));
  }

  void _refreshMemberList() {
    final data = _staffBox.keys.map((key) {
      final member = _staffBox.get(key);
      return {
        'key': key,
        'firstName': member['firstName'],
        'lastName': member['lastName'],
        'position': member['position'],
        'salary': member['salary'],
      };
    }).toList();

    setState(() {
      _members = data.reversed.toList();
    });
  }

  @override
  void initState() {
    _refreshMemberList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80.0),
          itemCount: _members.length,
          itemBuilder: (_, index) {
            final currentMember = _members[index];
            return CardWidget(
              currentMember: currentMember,
              showInputForm: _showInputForm,
              deleteMember: _deleteMember,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputForm(context, null),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
  void _showInputForm(BuildContext context, int? memberKey) async {
    if (memberKey != null) {
      final existingItem =
      _members.firstWhere((member) => member['key'] == memberKey);
      _firstNameTextController.text = existingItem['firstName'];
      _lastNameTextController.text = existingItem['lastName'];
      _positionTextController.text = existingItem['position'];
      _salaryTextController.text = existingItem['salary'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
              top: 15,
              right: 15,
              left: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _firstNameTextController,
                decoration: const InputDecoration(label: Text('Firstname')),
                textInputAction: TextInputAction.next,
                autofocus: true,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _lastNameTextController,
                decoration: const InputDecoration(label: Text('Lastname')),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _positionTextController,
                decoration: const InputDecoration(label: Text('Position')),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _salaryTextController,
                decoration: const InputDecoration(label: Text('Salary')),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  if (memberKey != null) {
                    _updateMember(
                      memberKey,
                      {
                        'firstName': _firstNameTextController.text.trim(),
                        'lastName': _lastNameTextController.text.trim(),
                        'position': _positionTextController.text.trim(),
                        'salary': _salaryTextController.text.trim(),
                      },
                    );
                  } else {
                    _addMember({
                      'firstName': _firstNameTextController.text,
                      'lastName': _lastNameTextController.text,
                      'position': _positionTextController.text,
                      'salary': _salaryTextController.text,
                    });
                  }

                  _firstNameTextController.clear();
                  _lastNameTextController.clear();
                  _positionTextController.clear();
                  _salaryTextController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                    memberKey == null ? 'Add member' : 'Update member data'),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
