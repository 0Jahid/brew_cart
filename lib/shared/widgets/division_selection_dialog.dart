import 'package:flutter/material.dart';

class DivisionSelectionDialog extends StatelessWidget {
  final Map<String, dynamic>? selectedDivision;
  final ValueChanged<Map<String, dynamic>> onDivisionSelected;

  const DivisionSelectionDialog({
    super.key,
    required this.selectedDivision,
    required this.onDivisionSelected,
  });

  static final List<Map<String, dynamic>> _divisions = [
    {'name': 'Dhaka', 'lat': 23.8103, 'lng': 90.4125},
    {'name': 'Chattogram', 'lat': 22.3569, 'lng': 91.7832},
    {'name': 'Khulna', 'lat': 22.8456, 'lng': 89.5403},
    {'name': 'Rajshahi', 'lat': 24.3745, 'lng': 88.6042},
    {'name': 'Barishal', 'lat': 22.7010, 'lng': 90.3535},
    {'name': 'Sylhet', 'lat': 24.8949, 'lng': 91.8687},
    {'name': 'Rangpur', 'lat': 25.7439, 'lng': 89.2752},
    {'name': 'Mymensingh', 'lat': 24.7471, 'lng': 90.4203},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Division',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _divisions.length,
          itemBuilder: (context, index) {
            final division = _divisions[index];
            final isSelected = selectedDivision?['name'] == division['name'];

            return ListTile(
              leading: Icon(
                Icons.location_on,
                color: isSelected ? Colors.green : Colors.grey,
              ),
              title: Text(
                division['name'],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.green : Colors.black87,
                ),
              ),
              subtitle: Text(
                'Lat: ${division['lat']}, Lng: ${division['lng']}',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                onDivisionSelected(division);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
