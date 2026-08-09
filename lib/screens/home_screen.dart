import 'package:flutter/material.dart'; 
import 'add_person_screen.dart'; 
import '../models/person.dart'; 
import '../services/hive_service.dart'; 
import '../screens/person_details_screen.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState() => _HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> {
  List<Person> people = [];

  static const Color primary = Color(0xFF7C6AE6);
  static const Color textDark = Color(0xFF2D3142);

  String formatBirthday(Person person) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    if (person.year == null) {
      return "${person.day} ${months[person.month]}";
    }

    return "${person.day} ${months[person.month]} ${person.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GiftKeeper"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Icon(
              Icons.favorite_rounded,
              color: primary.withValues(alpha: .8),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          color: primary,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Expanded(
                        child: Text(
                          "Upcoming Birthdays",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "${people.length} ${people.length == 1 ? "person" : "people"} saved",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: people.isEmpty ? 0 : 1,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(30),
                    backgroundColor: primary.withValues(alpha: .12),
                    valueColor: const AlwaysStoppedAnimation(primary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
Expanded(
  child: ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: people.length,
    itemBuilder: (context, index) {
      final person = people[index];

      final birthday = person.year == null
          ? "${person.day}/${person.month}"
          : "${person.day}/${person.month}/${person.year}";

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Dismissible(
          key: Key(person.id),

          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B81),
                  Color(0xFFFF4757),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.delete_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Delete Person?"),
                content: Text(
                  "Remove ${person.name} from GiftKeeper?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete"),
                  ),
                ],
              ),
            );
          },

          onDismissed: (_) async {
            setState(() {
              people.removeAt(index);
            });

            await HiveService.savePeople(people);

            await NotificationService.cancelBirthdayNotifications(person);

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${person.name} removed"),
              ),
            );
          },

          child: InkWell(
            borderRadius: BorderRadius.circular(24),

            onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (_) => PersonDetailsScreen(
                        person: person,
                        people: people,
                        index: index,
                    ),
                    ),
                );

                setState(() {
                    sortPeople();
                });
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: primary.withValues(alpha: .12),
                    child: Text(
                      person.name.isEmpty
                          ? "?"
                          : person.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          person.relationship.isEmpty
                              ? "Friend"
                              : person.relationship,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: .10),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "🎂 $birthday",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: .10),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                birthdayStatus(person),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ),
),
        

          ],
        ),
      ),
    
      floatingActionButton: FloatingActionButton.extended(
elevation: 2,
  backgroundColor: primary,
  foregroundColor: Colors.white,
  icon: const Icon(Icons.favorite_rounded),
  label: const Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      "Add Person",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  onPressed: () async {
    final person = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPersonScreen(),
      ),
    );

    if (person != null) {
      setState(() {
        people.add(person);
        sortPeople();
      });

      await HiveService.savePeople(people);
      await NotificationService.scheduleBirthdayNotifications(person);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${person.name} added successfully ❤️"),
        ),
      );
    }
  },
),

floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void sortPeople() {
    // Sort by how soon the birthday actually falls, not raw month/day —
    // otherwise a January birthday (6 months away) would show above an
    // August birthday (2 weeks away) once it's mid-year.
    people.sort(
      (a, b) => daysUntilBirthday(a).compareTo(daysUntilBirthday(b)),
    );
  }

  @override
  void initState() {
    super.initState();
    people = HiveService.loadPeople();
    sortPeople();
  }

  DateTime getNextBirthday(Person person) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime nextBirthday = DateTime(
      today.year,
      person.month,
      person.day,
    );

    if (nextBirthday.isBefore(today)) {
      nextBirthday = DateTime(
        today.year + 1,
        person.month,
        person.day,
      );
    }

    return nextBirthday;
  }

  int daysUntilBirthday(Person person) {
    final nextBirthday = getNextBirthday(person);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return nextBirthday.difference(today).inDays;
  }

  String birthdayStatus(Person person) {
    final days = daysUntilBirthday(person);

    if (days == 0) return "🎉 Today!";
    if (days == 1) return "🎈 Tomorrow";

    return "$days days left";
  }
}