import 'package:flutter/material.dart';
import 'package:ktck/mytrip/creaternewtrip/creaternewtrip.dart';
import 'package:ktck/mytrip/database/trip_database.dart';
import 'package:ktck/mytrip/models/trip.dart';

class CurrentTripDetailScreen extends StatefulWidget {
  final Trip trip;

  const CurrentTripDetailScreen({super.key, required this.trip});

  @override
  State<CurrentTripDetailScreen> createState() => _CurrentTripDetailScreenState();
}

class _CurrentTripDetailScreenState extends State<CurrentTripDetailScreen> {
  late Trip _trip;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
  }

  Future<void> _editTrip() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateNewTripScreen(trip: _trip),
      ),
    );
    if (changed == true) {
      final updated = await TripDatabase.instance.readTrip(_trip.id!);
      if (updated != null && mounted) {
        setState(() => _trip = updated);
      }
    }
  }

  Future<void> _deleteTrip() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Trip'),
          content: const Text('Do you want to delete this trip?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await TripDatabase.instance.delete(_trip.id!);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: const Icon(Icons.close, size: 28),
                    ),
                  ),
                  const Text(
                    'Trip Detail',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              'assets/images/mytrip/mytripcurrent/dragon-bridge-03 2.png',
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 180,
                                color: Colors.orange[200],
                                child: const Icon(
                                  Icons.image,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 16,
                            child: Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Danang, Vietnam',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -24,
                            right: 24,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00C9A7),
                                  width: 3,
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage(
                                  'assets/images/explore/BestGuides/Emmy 1.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Location', _trip.location),
                            const SizedBox(height: 12),
                            _buildDetailRow('Date', _trip.date),
                            const SizedBox(height: 12),
                            _buildDetailRow('Time', '${_trip.timeFrom} - ${_trip.timeTo}'),
                            const SizedBox(height: 12),
                            _buildDetailRow('Guide', _trip.language, valueColor: const Color(0xFF00C9A7)),
                            const SizedBox(height: 12),
                            _buildDetailRow('Travelers', '${_trip.travelers}'),
                            const SizedBox(height: 16),
                            const Text(
                              'Attractions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _trip.attractions
                                  .split(',')
                                  .map((item) => _buildAttractionChip(item.trim()))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Fee',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  '\$${_trip.fee.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00C9A7),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _deleteTrip,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _editTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C9A7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttractionChip(String title) {
    if (title.isEmpty) return const SizedBox();
    return Chip(
      label: Text(title),
      backgroundColor: Colors.grey[100],
    );
  }
}
