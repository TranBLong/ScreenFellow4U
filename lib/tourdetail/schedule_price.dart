import 'package:flutter/material.dart';

class TourScheduleSection extends StatefulWidget {
  const TourScheduleSection({super.key});

  @override
  State<TourScheduleSection> createState() => _TourScheduleSectionState();
}

class _TourScheduleSectionState extends State<TourScheduleSection> {
  int _selectedDay = 0;

  final List<String> _days = ['Day 1', 'Day 2'];

  final List<Map<String, dynamic>> _day1Schedule = [
    {
      'time': '6:00AM',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
    },
    {
      'time': '10:00AM',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
    },
    {
      'time': '1:00PM',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets.',
    },
    {
      'time': '8:00PM',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
    },
  ];

  final List<Map<String, dynamic>> _day2Schedule = [
    {
      'time': '7:00AM',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
    },
    {
      'time': '12:00PM',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
    },
    {
      'time': '6:00PM',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
    },
  ];

  final List<Map<String, dynamic>> _priceList = [
    {'label': 'Adult (>10 years old)', 'price': '\$400.00'},
    {'label': 'Child (5 - 10 years old)', 'price': '\$320.00'},
    {'label': 'Child (<5 years old)', 'price': 'Free'},
  ];

  @override
  Widget build(BuildContext context) {
    final schedule = _selectedDay == 0 ? _day1Schedule : _day2Schedule;
    final routeLabel = _selectedDay == 0
        ? 'Ho Chi Minh - Da Nang'
        : 'Da Nang - Hoi An';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Title
          Row(
            children: [
              Icon(Icons.view_column_outlined, size: 22, color: Colors.black87),
              const SizedBox(width: 8),
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

          // Day tabs
          Row(
            children: List.generate(_days.length, (index) {
              final isSelected = _selectedDay == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF00C9A7)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF00C9A7)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _days[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Route label
          Text(
            routeLabel,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          // Timeline
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final item = schedule[index];
              final isLast = index == schedule.length - 1;
              return _timelineItem(
                time: item['time'],
                description: item['description'],
                isLast: isLast,
              );
            },
          ),

          const SizedBox(height: 28),

          // Price section
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black87, width: 2),
                ),
                child: Center(
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
              Text(
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

          // Price table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: List.generate(_priceList.length, (index) {
                final item = _priceList[index];
                final isLast = index == _priceList.length - 1;
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
                            item['label'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            item['price'],
                            style: TextStyle(
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
          // Timeline column
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00C9A7),
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

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00C9A7),
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

// Gá»i hÃ m nÃ y khi nháº¥n nÃºt Share

