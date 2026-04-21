import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'SearchResultsView.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF9F1C);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Elements (Abstract blur)
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ), // Blur handled by backdrop filter if needed or just opacity
            ),

            Column(
              children: [
                // Header (Back + Cancel)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Back Logic handled by current index swap in MainWrapper usually,
                      // but here we might just hide keyboard or clear.
                      // Text("CityMall", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _searchController.clear();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.blueGrey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recent Searches
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recent Searches",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Clear all",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildRecentSearchItem(
                          "Cyberdeck Keyboards",
                          "Electronics • Yesterday",
                        ),
                        _buildRecentSearchItem(
                          "Neon Hoodies",
                          "Fashion • 2 days ago",
                        ),
                        _buildRecentSearchItem(
                          "Gaming Mouse Wireless",
                          "Electronics • Last week",
                        ),

                        const SizedBox(height: 32),

                        // Trending
                        const Text(
                          "Trending",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTrendingChip("Smart Home"),
                            _buildTrendingChip("Drones"),
                            _buildTrendingChip("Holographic Displays"),
                            _buildTrendingChip("VR Headsets"),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Categories
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCategoryCard(
                                "Electronics",
                                Colors.purple,
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuDTrlomVMvfaObCaYV4VufrzoRzlPeYr4KwlaRLxJugBeCH1kUvQAmFWl2EqI9_DkMYS3acgK7QCFS6Wi2mb2gWdkNw8kStNo6JiFcza5A1MHgbtzR97_vlXNBx-GqGvsz57Elrgo1kU5u1n6C45gHe9W0L6B8ToCjfPUh1dPq0etKUr7v4WKJhSsqzRg_Hi_eVOJql5hVyrgWzOcxpr22eHWI9Nw8a41rdVXhgRJU28mMO_xGEn0b95fhxxUIT1MaRh9LDibzVN9M",
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildCategoryCard(
                                "Fashion",
                                Colors.orange,
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuBnjgx776dPPQpqi2-b2erYxLIvFKRwRlReTaE8c8TU_Zi27sxmKagrpfqcQROcGPXW22TXAbTeblHbfgvTFge6TwfwEnufHpM8Vg6eMkZe-6wKhlx5pRI_8zqyf1u1wMl2utAZUx_C9PbL_kN39A26skk8iobJAiqWRnVMkZamvmYJmGqn_vUbg5eJAqN6FvN-nDvCZhZuy9Kt-WzVyjiuWyACYgnp3ef3x9t9cidtfhPIRilC4Dxb-6_1QuinHAq_pW75I6_-tYA",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100), // Space for bottom input
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Search Input Floating
            Positioned(
              bottom: 100, // Above nav bar
              left: 24,
              right: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.blueGrey.shade100),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus:
                      false, // Don't autofocus to avoid keyboard popping continuously
                  decoration: InputDecoration(
                    hintText: "Find your gear...",
                    hintStyle: TextStyle(color: Colors.blueGrey.shade300),
                    border: InputBorder.none,
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search, color: primaryColor),
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsView(query: value),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String text, String subtext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.blueGrey.shade50),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9F1C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.history,
              color: Color(0xFFFF9F1C),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                Text(
                  subtext,
                  style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.close, color: Colors.blueGrey.shade300, size: 18),
        ],
      ),
    );
  }

  Widget _buildTrendingChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.trending_up, color: Color(0xFFFF9F1C), size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, Color color, String imageUrl) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
