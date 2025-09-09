import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hola_mundo/views/base_view.dart';
import 'package:hola_mundo/views/clases/all_classes_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<String> usernameFuture;

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Usuario';
  }

  @override
  void initState() {
    super.initState();
    usernameFuture = getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: usernameFuture,
      builder: (context, snapshot) {
        final username = snapshot.data ?? 'Usuario';

        return BaseView(
          title: 'ACADEMIA FARFALA',
          initialIndex: 1,
          length: 2,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Tuluá', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.search, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black12.withOpacity(0.1), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 28, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Estudiante', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AllClassesPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          elevation: 4,
                        ),
                        child: const Text('Clases'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hola, $username! ✨',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.6,
                  children: const [
                    CategoryCard(label: 'Pole Dance', color: Color(0xFFFF6B6B), icon: Icons.fitness_center),
                    CategoryCard(label: 'Pole Sport', color: Color(0xFF4CD7D0), icon: Icons.sports_gymnastics),
                    CategoryCard(label: 'Twerk', color: Color(0xFF5D5FEF), icon: Icons.music_note),
                    CategoryCard(label: 'Baile en silla', color: Color(0xFFFFC247), icon: Icons.celebration),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    TabOption(label: 'Más popular', selected: true),
                    TabOption(label: 'Amigos'),
                    TabOption(label: 'Últimos'),
                    TabOption(label: 'Locales'),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D5FEF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF5D5FEF).withOpacity(0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Scorpions',
                          style: TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('World Tour - ANGELS TOUR',
                          style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 16),
                      EventDetailRow(icon: Icons.calendar_today, text: '23/07/19 7PM'),
                      SizedBox(height: 8),
                      EventDetailRow(icon: Icons.location_on, text: 'PALACE stadium'),
                      SizedBox(height: 8),
                      EventDetailRow(icon: Icons.attach_money, text: '90'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabOption extends StatelessWidget {
  final String label;
  final bool selected;

  const TabOption({super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          color: selected ? Colors.black : Colors.grey,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
        child: Text(label),
      ),
    );
  }
}

class EventDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const EventDetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}