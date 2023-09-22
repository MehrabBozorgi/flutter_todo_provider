import 'package:flutter/material.dart';
import 'package:flutter_hive_provider/model/users_model.dart';
import 'package:flutter_hive_provider/provider/handle_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    Hive.box<UsersModel>(HandleProvider.boxName).close();
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final handleP = Provider.of<HandleProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Data"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              Hive.box<UsersModel>(HandleProvider.boxName).clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: FutureBuilder(
              future: handleP.openBox,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ValueListenableBuilder(
                    valueListenable:
                        Hive.box<UsersModel>(HandleProvider.boxName)
                            .listenable(),
                    builder: (context, Box<UsersModel> box, child) {
                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final helper = box.getAt(index)!;
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                style: ListTileStyle.drawer,
                                title: Text(helper.name),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(helper.phone.toString()),
                                    Text(helper.age.toString()),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    box.delete(helper.id);
                                  },
                                ),
                                leading: Update(
                                  nameController: _nameController,
                                  phoneController: _phoneController,
                                  ageController: _ageController,
                                  handleP: handleP,
                                  helper: helper,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'name',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'phone',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'age',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        handleP.create(
                          name: _nameController.text,
                          phone: int.parse(_phoneController.text),
                          age: int.parse(_ageController.text),
                        );
                        _nameController.clear();
                        _phoneController.clear();
                        _ageController.clear();
                      },
                      child: const Text('submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Update extends StatelessWidget {
  const Update({
    Key? key,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController ageController,
    required this.handleP,
    required this.helper,
  })  : _nameController = nameController,
        _phoneController = phoneController,
        _ageController = ageController,
        super(key: key);

  final TextEditingController _nameController;
  final TextEditingController _phoneController;
  final TextEditingController _ageController;
  final HandleProvider handleP;
  final UsersModel helper;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.green,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'name',
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'phone',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'age',
                  ),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await handleP.updateBox(
                      key: helper.id,
                      name: _nameController.text,
                      phone: int.parse(_phoneController.text),
                      age: int.parse(_ageController.text),
                    );
                    _nameController.clear();
                    _phoneController.clear();
                    _ageController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
