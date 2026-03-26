import 'package:flutter/material.dart';
import 'package:ktck/searchsystem/searchresult.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _popularDestinations = [
    'Danang, Vietnam',
    'Ho Chi Minh, Vietnam',
    'Venice, Italy',
  ];

  List<String> _results = [];

  void _openResultIfDanang(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'danang, vietnam') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SearchResultScreen(
            destination: 'Danang, Vietnam',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Auto-focus keyboard khi mở màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    _controller.addListener(() {
      final query = _controller.text.trim().toLowerCase();
      setState(() {
        if (query.isEmpty) {
          _results = [];
        } else {
          _results = _popularDestinations
              .where((d) => d.toLowerCase().contains(query))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _controller.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Close button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              // Search field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Where you want to explore',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: isSearching
                        ? GestureDetector(
                            onTap: () => _controller.clear(),
                            child: Icon(
                              Icons.cancel,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  onSubmitted: (value) {
                    _openResultIfDanang(value);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Content: popular destinations or search results
              if (!isSearching) ...[
                Text(
                  'Popular destinations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _popularDestinations.map((dest) {
                    return GestureDetector(
                      onTap: () {
                        _controller.text = dest;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: dest.length),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dest,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ] else ...[
                if (_results.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'No results found',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey[200]),
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        onTap: () {
                          _openResultIfDanang(item);
                        },
                      );
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
