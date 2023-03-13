import 'package:flutter/material.dart';

void main() => runApp(const MultiSelect());

class MultiSelect extends StatefulWidget {
  const MultiSelect({super.key});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  existsInTrashCan(Course course) => trashCan.contains(course);
  List<Course> trashCan = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.cyan.shade900,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: trashCan.isEmpty
            ? AppBar(
                title: const Text('Multi-Delete'),
                centerTitle: true,
                backgroundColor: Colors.grey.shade900,
              )
            : AppBar(
                backgroundColor: Colors.grey.shade800,
                leading: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      trashCan.clear();
                    });
                  },
                ),
                title: Text(trashCan.length.toString()),
                actions: [
                  IconButton(
                      onPressed: () {
                        coursesData
                            .removeWhere((item) => trashCan.contains(item));
                        trashCan.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
        body: ListView(
          children: [
            const SizedBox(height: 30),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coursesData.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (BuildContext context, int index) {
                return PrettyCard(
                  name: coursesData[index].name,
                  isSelected: existsInTrashCan(coursesData[index]),
                  trashCan: trashCan,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Single Tap!'),
                      duration: Duration(seconds: 1),
                    ));
                  },
                  onDelete: () {
                    if (trashCan.contains(coursesData[index])) {
                      trashCan.remove(coursesData[index]);
                      setState(() {});
                    } else {
                      trashCan.add(coursesData[index]);
                      setState(() {});
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PrettyCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final void Function()? onDelete;
  final void Function()? onTap;
  final List trashCan;

  const PrettyCard(
      {Key? key,
      required this.name,
      required this.isSelected,
      this.onDelete,
      this.onTap,
      required this.trashCan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        surfaceTintColor: isSelected ? Colors.black : null,
        color: Colors.cyan.shade900,
        child: ListTile(
          dense: true,
          selected: isSelected,
          onTap: trashCan.isNotEmpty ? onDelete : onTap,
          onLongPress: onDelete,
          tileColor: Colors.cyan.shade900,
          selectedColor: Colors.white,
          selectedTileColor: Colors.cyan.shade900,
          title: Text(name),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.cyan.shade50,
                  width: 3,
                  style: isSelected ? BorderStyle.solid : BorderStyle.none)),
        ),
      ),
    );
  }
}

class Course {
  final String id;
  final String name;
  Course({
    required this.id,
    required this.name,
  });
}

List<Course> coursesData = [
  Course(id: '1', name: 'MTH'),
  Course(id: '2', name: 'STS'),
  Course(id: '3', name: 'ACC'),
  Course(id: '4', name: 'ETH'),
  Course(id: '5', name: 'PHY'),
  Course(id: '6', name: 'CSC'),
];
