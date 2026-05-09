import 'package:flutter/material.dart';
import 'package:ktck/mytrip/database/trip_database.dart';
import 'package:ktck/mytrip/models/trip.dart';

class _AttractionOption {
  final String name;
  final String assetPath;

  const _AttractionOption({required this.name, required this.assetPath});
}

class CreateNewTripScreen extends StatefulWidget {
  final Trip? trip;

  const CreateNewTripScreen({super.key, this.trip});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _feeController = TextEditingController();
  final _languageController = TextEditingController();
  final _attractionsController = TextEditingController();
  int _travelers = 1;
  final List<String> _selectedAttractions = [];

  static const List<_AttractionOption> _attractionOptions = [
    _AttractionOption(
      name: 'Bali',
      assetPath: 'assets/images/explore/FeaturedTours/Bali.png',
    ),
    _AttractionOption(
      name: 'Ha Long Bay',
      assetPath: 'assets/images/explore/FeaturedTours/HaLongBay.png',
    ),
    _AttractionOption(
      name: 'Nha Trang',
      assetPath: 'assets/images/explore/FeaturedTours/NhaTrang.png',
    ),
    _AttractionOption(
      name: 'My Khe Beach',
      assetPath: 'assets/images/chooseaguide/main/nhom1/myKhe_beach_main.png',
    ),
    _AttractionOption(
      name: 'War Museum',
      assetPath: 'assets/images/chooseaguide/main/nhom1/war_museum_main.png',
    ),
    _AttractionOption(
      name: 'Hoi An',
      assetPath: 'assets/images/chooseaguide/main/nhom1/hoianvietnam 1.png',
    ),
    _AttractionOption(
      name: 'Marble Mountain',
      assetPath:
          'assets/images/chooseaguide/main/nhom2/marble_mountain_main.png',
    ),
    _AttractionOption(
      name: 'Mekong Delta',
      assetPath: 'assets/images/chooseaguide/main/nhom2/mekong_delta_main.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _locationController.text = widget.trip!.location;
      _dateController.text = widget.trip!.date;
      _fromController.text = widget.trip!.timeFrom;
      _toController.text = widget.trip!.timeTo;
      _feeController.text = widget.trip!.fee.toStringAsFixed(0);
      _languageController.text = widget.trip!.language;
      _attractionsController.text = widget.trip!.attractions;
      _travelers = widget.trip!.travelers;
      final savedAttractions = widget.trip!.attractions.trim();
      if (savedAttractions.isNotEmpty &&
          savedAttractions != 'No attractions selected') {
        _selectedAttractions.addAll(
          savedAttractions
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty),
        );
      }
    }
    _syncAttractionsController();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _feeController.dispose();
    _languageController.dispose();
    _attractionsController.dispose();
    super.dispose();
  }

  void _syncAttractionsController() {
    _attractionsController.text = _selectedAttractions.join(', ');
  }

  bool _isSelected(String attractionName) {
    return _selectedAttractions.contains(attractionName);
  }

  _AttractionOption? _attractionOptionByName(String name) {
    for (final option in _attractionOptions) {
      if (option.name == name) {
        return option;
      }
    }
    return null;
  }

  List<_AttractionOption> get _selectedAttractionOptions {
    return _selectedAttractions
        .map(_attractionOptionByName)
        .whereType<_AttractionOption>()
        .toList();
  }

  Future<void> _openAttractionPicker() async {
    final selectedNames = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => AttractionPickerScreen(
          options: _attractionOptions,
          initialSelectedNames: _selectedAttractions,
        ),
      ),
    );

    if (!mounted || selectedNames == null) {
      return;
    }

    setState(() {
      _selectedAttractions
        ..clear()
        ..addAll(selectedNames);
      _syncAttractionsController();
    });
  }

  Future<void> _saveTrip() async {
    final location = _locationController.text.trim();
    final date = _dateController.text.trim();
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    final fee = double.tryParse(_feeController.text.trim()) ?? 0.0;
    final language = _languageController.text.trim();
    final attractions = _selectedAttractions.join(', ');

    if (location.isEmpty || date.isEmpty || from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the required fields.')),
      );
      return;
    }

    final trip = Trip(
      id: widget.trip?.id,
      location: location,
      date: date,
      timeFrom: from,
      timeTo: to,
      travelers: _travelers,
      fee: fee,
      language: language.isEmpty ? 'English' : language,
      attractions: attractions.isEmpty
          ? 'No attractions selected'
          : attractions,
      status: widget.trip?.status ?? 'Current',
      createdAt: widget.trip?.createdAt ?? DateTime.now().toIso8601String(),
    );

    if (widget.trip == null) {
      await TripDatabase.instance.create(trip);
    } else {
      await TripDatabase.instance.update(trip);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.trip != null;
    return Scaffold(
      backgroundColor: Colors.white,
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
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 28),
                    ),
                  ),
                  Text(
                    isEditing ? 'Edit Trip' : 'Create New Trip',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Where you want to explore'),
                    _buildTextField(
                      controller: _locationController,
                      hint: 'Danang, Vietnam',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Date'),
                    _buildTextField(
                      controller: _dateController,
                      hint: 'mm/dd/yy',
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Time'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _fromController,
                            hint: 'From',
                            icon: Icons.access_time,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildTextField(
                            controller: _toController,
                            hint: 'To',
                            icon: Icons.access_time,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Number of travelers'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildCounterButton(
                          icon: Icons.arrow_drop_down,
                          onTap: () {
                            if (_travelers > 1) {
                              setState(() => _travelers--);
                            }
                          },
                        ),
                        Container(
                          width: 80,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '$_travelers',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        _buildCounterButton(
                          icon: Icons.arrow_drop_up,
                          onTap: () {
                            setState(() => _travelers++);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Fee'),
                    _buildTextField(
                      controller: _feeController,
                      hint: 'Fee',
                      icon: Icons.monetization_on_outlined,
                      suffix: '(\$/hour)',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Guide\'s Language'),
                    _buildTextField(
                      controller: _languageController,
                      hint: 'Korean, English',
                      icon: Icons.public,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Attractions'),
                    const SizedBox(height: 12),
                    _buildAttractionsPreview(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C9A7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? 'UPDATE TRIP' : 'SAVE TRIP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIconConstraints: const BoxConstraints(minWidth: 32),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey[500]),
        suffixIcon: suffix != null
            ? Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  suffix,
                  style: TextStyle(color: Colors.black87, fontSize: 13),
                ),
              )
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00C9A7), width: 2),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: const Color(0xFF00C9A7), size: 24),
      ),
    );
  }

  Widget _buildAddNewCard() {
    return GestureDetector(
      onTap: _openAttractionPicker,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF00C9A7).withOpacity(0.55),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Color(0xFF00C9A7), size: 30),
            SizedBox(height: 8),
            Text(
              'Add New',
              style: TextStyle(
                color: Color(0xFF00C9A7),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedAttractionCard(_AttractionOption attraction) {
    return SizedBox(
      width: 118,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(attraction.assetPath, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.65),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Text(
                      attraction.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            attraction.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionsPreview() {
    final selectedOptions = _selectedAttractionOptions;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3F4EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Attraction photos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C9A7).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${selectedOptions.length} selected',
                  style: const TextStyle(
                    color: Color(0xFF00C9A7),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tap Add New to open the full photo list.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAddNewCard(),
                if (selectedOptions.isNotEmpty) const SizedBox(width: 12),
                ...selectedOptions.asMap().entries.expand((entry) {
                  final index = entry.key;
                  final attraction = entry.value;
                  return [
                    _buildSelectedAttractionCard(attraction),
                    if (index != selectedOptions.length - 1)
                      const SizedBox(width: 12),
                  ];
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class AttractionPickerScreen extends StatefulWidget {
  final List<_AttractionOption> options;
  final List<String> initialSelectedNames;

  const AttractionPickerScreen({
    super.key,
    required this.options,
    required this.initialSelectedNames,
  });

  @override
  State<AttractionPickerScreen> createState() => _AttractionPickerScreenState();
}

class _AttractionPickerScreenState extends State<AttractionPickerScreen> {
  late final List<String> _selectedNames = List<String>.from(
    widget.initialSelectedNames,
  );

  bool _isSelected(String name) => _selectedNames.contains(name);

  void _toggle(String name) {
    setState(() {
      if (_selectedNames.contains(name)) {
        _selectedNames.remove(name);
      } else {
        _selectedNames.add(name);
      }
    });
  }

  void _done() {
    Navigator.pop(context, _selectedNames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Attractions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _done,
            child: const Text(
              'DONE',
              style: TextStyle(
                color: Color(0xFF00C9A7),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: widget.options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final attraction = widget.options[index];
            final selected = _isSelected(attraction.name);

            return GestureDetector(
              onTap: () => _toggle(attraction.name),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF00C9A7)
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(attraction.assetPath, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 10,
                        child: Text(
                          attraction.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (selected)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00C9A7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
