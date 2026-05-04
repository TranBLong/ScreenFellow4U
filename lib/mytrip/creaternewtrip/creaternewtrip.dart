import 'package:flutter/material.dart';

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  int _travelers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
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
                  const Text(
                    'Create New Trip',
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Where you want to explore'),
                    _buildTextField(
                      hint: 'Danang, Vietnam',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Date'),
                    _buildTextField(
                      hint: 'mm/dd/yy',
                      icon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Time'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            hint: 'From',
                            icon: Icons.access_time,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildTextField(
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
                              bottom: BorderSide(color: Colors.grey, width: 0.5),
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
                      hint: 'Fee',
                      icon: Icons.monetization_on_outlined,
                      suffix: '(\$/hour)',
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Guide\'s Language'),
                    _buildTextField(
                      hint: 'Korean, English',
                      icon: Icons.public,
                    ),
                    const SizedBox(height: 32),

                    _buildSectionTitle('Attractions'),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildAddNewAttraction(),
                        _buildAttractionCard(
                          title: 'Dragon Bridge',
                          isSelected: true,
                        ),
                        _buildAttractionCard(
                          title: 'Cham Museum',
                          isSelected: false,
                        ),
                        _buildAttractionCard(
                          title: 'My Khe Beach',
                          isSelected: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C9A7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'DONE',
                    style: TextStyle(
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
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return TextField(
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

  Widget _buildCounterButton({required IconData icon, required VoidCallback onTap}) {
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

  Widget _buildAddNewAttraction() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!), // In a real app, you might use a dotted border package
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Color(0xFF00C9A7), size: 28),
          SizedBox(height: 4),
          Text(
            'Add New',
            style: TextStyle(
              color: Color(0xFF00C9A7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionCard({required String title, required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
        image: const DecorationImage(
          image: AssetImage('assets/images/explore/image 3.png'), // Placeholder
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Dark gradient at bottom for text readability
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          
          // Title
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Selection Checkmark
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00C9A7) : Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
