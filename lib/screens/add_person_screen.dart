import 'package:flutter/material.dart';
import '../models/person.dart';

class AddPersonScreen extends StatefulWidget {
  final Person? person;

  const AddPersonScreen({
    super.key,
    this.person,
  });

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  static const List<String> _months = [
    "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String relationship = "Family";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    final person = widget.person;
    if (person == null) return;

    nameController.text = person.name;
    relationship = person.relationship;
    interestsController.text = person.interests;
    notesController.text = person.notes;

    if (person.year != null) {
      yearController.text = person.year.toString();
    }

    // Use "today" as a safe placeholder year for internal DateTime math
    // when the person has no birth year on file — it's never shown to
    // the user or saved back, only used to compute month/day.
    // Placeholder year math only matters when there's no real birth year —
    // in that case we need *some* year to build a DateTime, purely to
    // represent month/day. Using the current year is wrong whenever the
    // birthday hasn't happened yet this year: e.g. today is July but the
    // birthday is in August, so "August <this year>" is a future date.
    // showDatePicker's lastDate is capped at "today", so a future
    // initialDate breaks it silently — the picker won't let you change
    // anything. Falling back a year fixes that.
    final now = DateTime.now();
    int placeholderYear = person.year ?? now.year;

    var candidate = DateTime(placeholderYear, person.month, person.day);
    if (person.year == null && candidate.isAfter(now)) {
      placeholderYear -= 1;
      candidate = DateTime(placeholderYear, person.month, person.day);
    }

    selectedDate = candidate;

    birthdayController.text = _formatDate(selectedDate!);
  }

  String _formatDate(DateTime date) => "${date.day} ${_months[date.month]}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person == null ? "Add Person" : "Edit Person"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: birthdayController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Birthday",
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    birthdayController.text = _formatDate(picked);
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Birth Year (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: relationship,
              decoration: const InputDecoration(
                labelText: "Relationship",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Family", child: Text("Family")),
                DropdownMenuItem(value: "Friend", child: Text("Friend")),
                DropdownMenuItem(value: "Partner", child: Text("Partner")),
                DropdownMenuItem(value: "Coworker", child: Text("Coworker")),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],
              onChanged: (value) => setState(() => relationship = value!),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: interestsController,
              decoration: const InputDecoration(
                labelText: "Interests (comma separated)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name.")),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose a birthday.")),
      );
      return;
    }

    final yearText = yearController.text.trim();

    if (widget.person != null) {
    widget.person!.name = nameController.text.trim();
    widget.person!.day = selectedDate!.day;
    widget.person!.month = selectedDate!.month;
    widget.person!.year = yearText.isEmpty ? null : int.tryParse(yearText);
    widget.person!.relationship = relationship;
    widget.person!.interests = interestsController.text.trim();
    widget.person!.notes = notesController.text.trim();

    Navigator.pop(context, widget.person);
    return;
  }

  Navigator.pop(
    context,
    Person(
      name: nameController.text.trim(),
      day: selectedDate!.day,
      month: selectedDate!.month,
      year: yearText.isEmpty ? null : int.tryParse(yearText),
      relationship: relationship,
      interests: interestsController.text.trim(),
      notes: notesController.text.trim(),
    ),
  );
  }

  @override
    void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    yearController.dispose();
    interestsController.dispose();
    notesController.dispose();
    super.dispose();
    }
}