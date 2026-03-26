import 'package:flutter/material.dart';

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _FilterBottomSheet(),
  );
}

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  int _selectedTab = 0; // 0: Guides, 1: Tours
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  final List<String> _languages = [
    'Vietnamese',
    'English',
    'Korean',
    'Spanish',
    'French',
  ];
  final Set<String> _selectedLanguages = {};

  @override
  void dispose() {
    _dateController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 22,
                    color: Colors.black54,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 22), // balance close button
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Guides / Tours tabs
                Row(
                  children: [
                    _tabButton('Guides', 0),
                    const SizedBox(width: 10),
                    _tabButton('Tours', 1),
                  ],
                ),

                const SizedBox(height: 24),

                // Date
                const Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _inputField(
                  controller: _dateController,
                  hint: 'mm/dd/yy',
                  prefixIcon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.datetime,
                ),

                const SizedBox(height: 20),

                // Guide's Language (only show for Guides tab)
                if (_selectedTab == 0) ...[
                  const Text(
                    "Guide's Language",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _languages.map((lang) {
                      final selected = _selectedLanguages.contains(lang);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedLanguages.remove(lang);
                            } else {
                              _selectedLanguages.add(lang);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF00C9A7)
                                : Colors.white,
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF00C9A7)
                                  : Colors.grey[350]!,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            lang,
                            style: TextStyle(
                              fontSize: 13,
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Fee
                const Text(
                  'Fee',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _inputField(
                  controller: _feeController,
                  hint: 'Fee',
                  prefixIcon: Icons.monetization_on_outlined,
                  suffix: '(\$/hour)',
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 28),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'tab': _selectedTab == 0 ? 'guides' : 'tours',
                        'date': _dateController.text,
                        'languages': _selectedLanguages.toList(),
                        'fee': _feeController.text,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C9A7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'APPLY FILTERS',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00C9A7) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF00C9A7) : Colors.grey[350]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (suffix != null)
            Text(
              suffix,
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
        ],
      ),
    );
  }
}
