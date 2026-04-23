import 'package:flutter/material.dart';

class TourScheduleSection extends StatefulWidget {
  final List<Map<String, dynamic>> schedules;
  final List<Map<String, dynamic>> pricing;

  const TourScheduleSection({
    super.key,
    this.schedules = const <Map<String, dynamic>>[],
    this.pricing = const <Map<String, dynamic>>[],
  });

  @override
  State<TourScheduleSection> createState() => _TourScheduleSectionState();
}

class _TourScheduleSectionState extends State<TourScheduleSection> {
  int _selectedDay = 0;

  final List<Map<String, dynamic>> _fallbackSchedules = [
    {
      'day': 'Day 1',
      'route': 'Ho Chi Minh - Da Nang',
      'items': [
        {
          'time': '6:00AM',
          'description':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        },
        {
          'time': '10:00AM',
          'description':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        },
      ],
    },
    {
      'day': 'Day 2',
      'route': 'Da Nang - Hoi An',
      'items': [
        {
          'time': '7:00AM',
          'description':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        },
        {
          'time': '12:00PM',
          'description':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> _fallbackPricing = [
    {'label': 'Adult (>10 years old)', 'price': '\$400.00'},
    {'label': 'Child (5 - 10 years old)', 'price': '\$320.00'},
    {'label': 'Child (<5 years old)', 'price': 'Free'},
  ];

  @override
  void didUpdateWidget(covariant TourScheduleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final totalDays = _displaySchedules().length;
    if (totalDays > 0 && _selectedDay >= totalDays) {
      _selectedDay = 0;
    }
  }

  List<Map<String, dynamic>> _displaySchedules() {
    if (widget.schedules.isNotEmpty) return widget.schedules;
    return _fallbackSchedules;
  }

  List<Map<String, dynamic>> _displayPricing() {
    if (widget.pricing.isNotEmpty) return widget.pricing;
    return _fallbackPricing;
  }

  @override
  Widget build(BuildContext context) {
    final schedules = _displaySchedules();
    final pricing = _displayPricing();
    final selectedSchedule = schedules[_selectedDay];
    final items = (selectedSchedule['items'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
    final routeLabel = selectedSchedule['route']?.toString() ??
        selectedSchedule['RouteLabel']?.toString() ??
        'Schedule';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.view_column_outlined, size: 22, color: Colors.black87),
              SizedBox(width: 8),
              Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(schedules.length, (index) {
              final isSelected = _selectedDay == index;
              final label = schedules[index]['day']?.toString() ??
                  schedules[index]['DayNumber']?.toString() ??
                  'Day ${index + 1}';
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00C9A7) : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF00C9A7)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Text(
            routeLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No schedule available.',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            )
          else
            Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                return _timelineItem(
                  time: item['time']?.toString() ?? item['TimeSlot']?.toString() ?? '',
                  description:
                      item['description']?.toString() ?? item['Description']?.toString() ?? '',
                  isLast: index == items.length - 1,
                );
              }),
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black87, width: 2),
                ),
                child: const Center(
                  child: Text(
                    '\$',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Price',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: List.generate(pricing.length, (index) {
                final item = pricing[index];
                final isLast = index == pricing.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['label']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            item['price']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast) Divider(height: 1, color: Colors.grey[200]),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required String time,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00C9A7),
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFF00C9A7).withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C9A7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
