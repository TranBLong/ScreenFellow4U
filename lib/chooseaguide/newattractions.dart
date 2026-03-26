import 'package:flutter/material.dart';
import 'package:ktck/chooseaguide/addnewplace.dart';

class NewAttractionsScreen extends StatefulWidget {
  const NewAttractionsScreen({super.key});

  @override
  State<NewAttractionsScreen> createState() => _NewAttractionsScreenState();
}

class _NewAttractionsScreenState extends State<NewAttractionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Map<String, String>> _resultPlaces = [];
  final List<String> _selectedPlaces = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _resultPlaces = [];
      } else {
        _resultPlaces = kAddNewPlaceLocations
            .where((p) =>
                (p['name'] ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectPlace(BuildContext context, String place) {
    if (!_selectedPlaces.contains(place)) {
      setState(() {
        _selectedPlaces.add(place);
      });
    }
    _searchController.clear();
    _focusNode.requestFocus();

    if (place.toLowerCase() == 'cong coffee') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddNewPlaces()),
      );
    }
  }

  void _addCustomPlace(BuildContext context) {
    final text = _searchController.text.trim();
    if (text.isNotEmpty) {
      _selectPlace(context, text);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Attractions',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedPlaces),
            child: const Text(
              'DONE',
              style: TextStyle(
                color: Color(0xFF4CD9C0),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSearchBox(),
            ),

            // Selected chips (if any)
            if (_selectedPlaces.isNotEmpty) _buildSelectedChips(),

            // Suggestions dropdown
            if (_resultPlaces.isNotEmpty) _buildAddNewPlaceResults(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: true,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              decoration: const InputDecoration(
                hintText: 'Search places...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _addCustomPlace(context),
            ),
          ),
          GestureDetector(
            onTap: () => _addCustomPlace(context),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFF4CD9C0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewPlaceResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _resultPlaces.length,
        itemBuilder: (context, index) {
          final place = _resultPlaces[index];
          final name = place['name'] ?? '';
          final image = place['image'] ?? 'https://via.placeholder.com/150';
          return GestureDetector(
            onTap: () => _selectPlace(context, name),
            child: AttractionCard(name: name, imageUrl: image),
          );
        },
      ),
    );
  }

  Widget _buildSelectedChips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: _selectedPlaces.map((place) {
          return Chip(
            label: Text(
              place,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFF4CD9C0),
            deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
            onDeleted: () {
              setState(() => _selectedPlaces.remove(place));
            },
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide.none,
          );
        }).toList(),
      ),
    );
  }
}
