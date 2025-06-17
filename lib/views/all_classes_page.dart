import 'package:flutter/material.dart';

class AllClassesPage extends StatelessWidget {
  const AllClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      {'name': 'Pole Dance', 'color': Colors.pinkAccent, 'hour': '6:00 PM'},
      {'name': 'Pole Sport', 'color': Colors.blueAccent, 'hour': '5:30 PM'},
      {'name': 'Twerk', 'color': Colors.deepPurpleAccent, 'hour': '7:00 PM'},
      {'name': 'Baile en silla', 'color': Colors.orangeAccent, 'hour': '4:00 PM'},
      {'name': 'Karate', 'color': Colors.greenAccent, 'hour': '6:30 PM'},
      {'name': 'Aéreo', 'color': Colors.cyan, 'hour': '5:00 PM'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Todas las clases',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final item = classes[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: (item['color'] as Color).withOpacity(0.3), width: 1),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: item['color'] as Color,
                        radius: 30,
                        child:
                            const Icon(Icons.fitness_center, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: item['color'] as Color,
                                onPrimary: Colors.white,
                                onSurface: Colors.black87,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: item['color'] as Color,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (selectedDate != null) {
                        final snackBar = SnackBar(
                          content: Text(
                            'Reservaste ${item['name']} para el ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} a las ${item['hour']}',
                          ),
                          backgroundColor: item['color'] as Color,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: const Icon(Icons.access_time, size: 16),
                    label: Text(item['hour'] as String),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item['color'] as Color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
