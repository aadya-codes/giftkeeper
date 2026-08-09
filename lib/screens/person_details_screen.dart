import 'package:flutter/material.dart';
import 'package:giftkeeper/services/notification_service.dart';
import '../models/person.dart';
import '../models/gift_idea.dart';
import '../services/hive_service.dart';
import '../services/ai_service.dart';
import 'add_person_screen.dart';

class PersonDetailsScreen extends StatefulWidget {
  final Person person;
  final List<Person> people;
  final int index;

  const PersonDetailsScreen({
    super.key,
    required this.person,
    required this.people,
    required this.index,
  });

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  static const Color primary = Color(0xFF7C6AE6);
  static const Color textDark = Color(0xFF2D3142);

  bool isGenerating = false;
  List<String> aiSuggestions = [];

  List<GiftIdea> get activeGifts =>
      widget.person.giftIdeas.where((g) => !g.given).toList();

  List<GiftIdea> get giftHistory =>
      widget.person.giftIdeas.where((g) => g.given).toList();

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
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              final updatedPerson = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPersonScreen(
                    person: widget.people[widget.index],
                  ),
                ),
              );

              if (updatedPerson != null) {
                setState(() {
                  widget.people[widget.index] = updatedPerson;
                });

                await HiveService.savePeople(widget.people);

                await NotificationService.cancelBirthdayNotifications(
                  updatedPerson,
                );

                await NotificationService.scheduleBirthdayNotifications(
                  updatedPerson,
                );

                if (!context.mounted) return;
                Navigator.pop(context, updatedPerson);
              }
            }
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                children: [

                  CircleAvatar(
                    radius: 42,
                    backgroundColor: primary.withValues(alpha: .12),
                    child: Text(
                      widget.person.name.isEmpty
                          ? "?"
                          : widget.person.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: primary,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.person.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      widget.person.relationship.isEmpty
                          ? "Friend"
                          : widget.person.relationship,
                      style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.cake_rounded,
                                color: primary,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Birthday",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatBirthday(widget.person),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.favorite_rounded,
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Relationship",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.person.relationship.isEmpty
                                    ? "Friend"
                                    : widget.person.relationship,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

                        const Text(
              "❤️ Interests",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            if (widget.person.interests.trim().isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  "No interests added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.person.interests
                    .split(",")
                    .map(
                      (interest) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          interest.trim(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

            const SizedBox(height: 28),

            const Text(
              "📝 Notes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                widget.person.notes.trim().isEmpty
                    ? "No notes yet."
                    : widget.person.notes,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7C6AE6),
                    Color(0xFF9F8CFF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: .30),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                icon: isGenerating
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome_rounded),

                label: Text(
                  isGenerating
                      ? "Finding Perfect Gifts..."
                      : " Find Perfect Gifts",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                onPressed: isGenerating
                    ? null
                    : () async {
                        setState(() {
                          isGenerating = true;
                        });

                        final ideas = await AIService.generateIdeas(
                          person: widget.person,
                        );

                        setState(() {
                          aiSuggestions = ideas;
                          isGenerating = false;
                        });
                      },
              ),
            ),

            const SizedBox(height: 28),

            if (aiSuggestions.isNotEmpty) ...[
              const Text(
                "✨ AI Suggestions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: aiSuggestions.map((idea) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .04),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [

                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: .10),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: primary,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Text(
                                idea,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            FilledButton.icon(
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text("Add"),
                              onPressed: () {
                                setState(() {
                                  widget.person.giftIdeas.add(
                                    GiftIdea(name: idea),
                                  );
                                });

                                HiveService.savePeople(widget.people);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 30),

                        const Text(
              "🎁 Gift Ideas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            if (activeGifts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      size: 58,
                      color: primary,
                    ),
                    SizedBox(height: 18),
                    Text(
                      "No gifts yet",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Generate AI ideas or add one yourself.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ...activeGifts.map(
                (gift) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .04),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        Checkbox(
                          value: gift.given,
                          activeColor: primary,
                          onChanged: (value) async {
                            if (value != true) return;

                            String tempOccasion = "Birthday";

                            final selectedOccasion =
                                await showDialog<String>(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    return AlertDialog(
                                      title: const Text("Gift Given"),
                                      content: DropdownButton<String>(
                                        value: tempOccasion,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Birthday",
                                            child: Text("Birthday"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Christmas",
                                            child: Text("Christmas"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Anniversary",
                                            child: Text("Anniversary"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Graduation",
                                            child: Text("Graduation"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Valentine's Day",
                                            child: Text("Valentine's Day"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Other",
                                            child: Text("Other"),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setDialogState(() {
                                            tempOccasion = value!;
                                          });
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(
                                            context,
                                            tempOccasion,
                                          ),
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );

                            if (selectedOccasion != null) {
                              setState(() {
                                gift.given = true;
                                gift.giftedYear = DateTime.now().year;
                                gift.occasion = selectedOccasion;

                                widget.people[widget.index] =
                                    widget.person;
                              });

                              await HiveService.savePeople(
                                widget.people,
                              );

                              if (!context.mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${gift.name} moved to Gift History 🎉",
                                    ),
                                  ),
                                );
                            }
                          },
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                gift.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              const Text(
                                "Ready to gift",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        PopupMenuButton<String>(
                          onSelected: (choice) async {
                            if (choice == "delete") {
                              setState(() {
                                widget.person.giftIdeas.remove(gift);
                              });

                              await HiveService.savePeople(
                                  widget.people);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: "delete",
                              child: Text("🗑 Delete"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add_rounded),
                label: const Text("Add Gift Idea"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  final controller = TextEditingController();

                  final giftName = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("New Gift Idea"),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "e.g. LEGO Flowers",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                controller.text.trim(),
                              );
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      );
                    },
                  );

                  if (giftName != null &&
                      giftName.trim().isNotEmpty) {
                    setState(() {
                      widget.person.giftIdeas.add(
                        GiftIdea(name: giftName),
                      );

                      widget.people[widget.index] =
                          widget.person;
                    });

                    await HiveService.savePeople(widget.people);
                  }
                },
              ),
            ),

            const SizedBox(height: 32),

                        if (giftHistory.isNotEmpty) ...[
              const Text(
                "📜 Gift History",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              ...giftHistory.map(
                (gift) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [

                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFE8F5E9),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                gift.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "${gift.occasion ?? "Gift"} • ${gift.giftedYear}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void savePerson() {
    widget.people[widget.index] = widget.person;
    HiveService.savePeople(widget.people);
  }
}