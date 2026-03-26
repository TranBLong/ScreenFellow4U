import 'package:flutter/material.dart';
import 'package:ktck/chooseaguide/newattractions.dart';
import 'package:ktck/login/explore/explore.dart';

class TripInformationScreen extends StatefulWidget {
  const TripInformationScreen({super.key});

  @override
  State<TripInformationScreen> createState() => _TripInformationScreenState();
}

class _TripInformationScreenState extends State<TripInformationScreen> {
  DateTime? selectedDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  String selectedCity = 'Danang';
  int numberOfTravelers = 1;

  final List<AttractionItem> attractions = [
    AttractionItem(
      name: 'Dragon Bridge',
      imageUrl:
          'assets/images/chooseaguide/tripinformation/dragon-bridge-03 1.png',
      isSelected: true,
    ),
    AttractionItem(
      name: 'Cham Museum',
      imageUrl: 'assets/images/chooseaguide/tripinformation/3005_museum 1.png',
      isSelected: true,
    ),
    AttractionItem(
      name: 'My Khe Beach',
      imageUrl:
          'assets/images/chooseaguide/tripinformation/my-khe-beach-01 1.png',
      isSelected: true,
    ),
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4CD9C0)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: fromTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4CD9C0)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => fromTime = picked);
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: toTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4CD9C0)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => toTime = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trip Information',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Date'),
            _buildTappableField(
              icon: Icons.calendar_today_outlined,
              hint: 'mm/dd/yy',
              value: selectedDate != null ? _formatDate(selectedDate!) : null,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            _buildSectionLabel('Time'),
            Row(
              children: [
                Expanded(
                  child: _buildTappableField(
                    icon: Icons.access_time,
                    hint: 'From',
                    value: fromTime != null ? _formatTime(fromTime!) : null,
                    onTap: () => _selectFromTime(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTappableField(
                    icon: Icons.access_time,
                    hint: 'To',
                    value: toTime != null ? _formatTime(toTime!) : null,
                    onTap: () => _selectToTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionLabel('City'),
            _buildTappableField(
              icon: Icons.location_on_outlined,
              hint: 'Select city',
              value: selectedCity,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildSectionLabel('Number of travelers'),
            const SizedBox(height: 10),
            _buildTravelerCounter(),
            const SizedBox(height: 20),
            _buildSectionLabel('Attractions'),
            const SizedBox(height: 12),
            _buildAttractionsGrid(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const Explore()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CD9C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTappableField({
    required IconData icon,
    required String hint,
    String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[500]),
            const SizedBox(width: 10),
            Text(
              value ?? hint,
              style: TextStyle(
                fontSize: 14,
                color: value != null ? Colors.black87 : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelerCounter() {
    return Row(
      children: [
        _buildCounterButton(
          icon: Icons.arrow_drop_down,
          onTap: () {
            if (numberOfTravelers > 1) {
              setState(() => numberOfTravelers--);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '$numberOfTravelers',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        _buildCounterButton(
          icon: Icons.arrow_drop_up,
          onTap: () => setState(() => numberOfTravelers++),
        ),
      ],
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF4CD9C0),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildAttractionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NewAttractionsScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF4CD9C0), size: 28),
                SizedBox(height: 6),
                Text(
                  'Add New',
                  style: TextStyle(
                    color: Color(0xFF4CD9C0),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...attractions.map((attraction) => _buildAttractionCard(attraction)),
      ],
    );
  }

  Widget _buildAttractionCard(AttractionItem attraction) {
    final imageWidget = attraction.imageUrl.startsWith('http')
        ? Image.network(
            attraction.imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.asset(
            attraction.imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );

    return GestureDetector(
      onTap: () {
        setState(() => attraction.isSelected = !attraction.isSelected);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              attraction.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
              ),
            ),
          ),
          if (attraction.isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CD9C0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }
}

class AttractionItem {
  final String name;
  final String imageUrl;
  bool isSelected;

  AttractionItem({
    required this.name,
    required this.imageUrl,
    this.isSelected = false,
  });
}
