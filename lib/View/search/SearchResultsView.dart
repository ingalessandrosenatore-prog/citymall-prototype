import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Stato/ProductProvider.dart';

class SearchResultsView extends StatefulWidget {
  final String query;
  const SearchResultsView({super.key, required this.query});

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  double _radius = 5.2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger search in provider
      context.read<ProductProvider>().searchProducts(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF9F1C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueGrey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.blueGrey.shade600,
                        size: 20,
                      ),
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(text: 'City'),
                        TextSpan(
                          text: 'Mall',
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueGrey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.tune,
                      color: Colors.blueGrey.shade600,
                      size: 20,
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
                    const SizedBox(height: 16),
                    // "Results for:"
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "Results for: ",
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.query,
                          style: TextStyle(
                            color: Colors.blueGrey.shade900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Radius Filter Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.blueGrey.shade50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Search Radius",
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade400,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    "Local Area",
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${_radius.toStringAsFixed(1)} km",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: primaryColor,
                              inactiveTrackColor: Colors.blueGrey.shade100,
                              thumbColor: primaryColor,
                              overlayColor: primaryColor.withOpacity(0.2),
                              trackHeight: 6.0,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12,
                              ),
                            ),
                            child: Slider(
                              value: _radius,
                              min: 0,
                              max: 15,
                              onChanged: (val) {
                                setState(() => _radius = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          _buildFilterChip("Electronics", true),
                          const SizedBox(width: 8),
                          _buildFilterChip("Fashion", false),
                          const SizedBox(width: 8),
                          _buildFilterChip("Home", false),
                          const SizedBox(width: 8),
                          _buildFilterChip("Beauty", false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Results List (Grid actually looks better or List)
                    Consumer<ProductProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final results = provider.searchResults;
                        if (results.isEmpty) {
                          // Show dummy results if empty for UI verification
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.7,
                            children: [
                              _buildResultCard(
                                "CyberPhone X",
                                "Neural Interface",
                                "\$999",
                                "4.8",
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuB38NRXXYd2A5IrJ8KelA9EGXwB4KD1J9Yyc6Vf559E4zFziDM59yK987PzAQS6_3NPRVf9b4OPsHF5PJSaX6F2fTI8Qa3FOLIIvA5KPbyDquaDTMLz0yEKx6J7d5ShiufKKtwqhK39PaXiPQ2SrJUhuwz0DeTEr3VeKH07U7vm8eUezV4wngB-41wd7yCOPPzmugBrWT8bcx08KtIroYXEALOracH729BME8vbC21UE9N0H32taodzsYaBbxPzEJCK0WMZPADdkQ8",
                              ),
                              _buildResultCard(
                                "Neon Runner",
                                "Anti-Gravity",
                                "\$120",
                                "4.5",
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuDl6Exc7OMc1imvaHHETdmrycAJEjibsdO9RXatSy1r2OgCcsyPAFqrhRQFL_LeoS6NCgul4ndoqWUfv1PnxKe2SZwTR6ohWLAMw3gnWR0iDJMpctJNHHuvVjhUIDivrljjtgn7IilwnjXJyqJjwIJj42lYRv_MriONrZsI0VMSCQXN7SLt8pYBoWuqpb7dNqsireT21130oWjgNuNzLsYi0h6e5kRkpKHDh1h5qw9gZDKfYq1y0RtY6J6UZblufUZiFtCC-EnxjkI",
                              ),
                              _buildResultCard(
                                "Holo-Watch",
                                "Series 7",
                                "\$250",
                                "4.9",
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuDmbJsGng2Fk9RFeGq9qX_OOx2xJoyMyC-S2YBvsbT7swi0Zq5rgwjIEzZiBDP7o-Ge6uB7U-N2qa9zWxYrLcLUIIJQ2iFm5tk0_ieq2MyxeZiFjbygPqtFX50su9jWjPbS-9SmIUjKSQk3qpJA-WYpMVkYkORZwDBZRP3TqCu7dzlJm2Pk2oRw83zbyHgtZXMKXGWBu8QLpWg1clhqLp_n7f0gTM3M_mCVI2juZNbL21r0oaeRqOH7RIqpqjxQIYdBhGKAFccgUYk",
                              ),
                              _buildResultCard(
                                "Urban Jacket",
                                "Nanofiber",
                                "\$189",
                                "4.2",
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuDugFVjBlIXipVKNEPyfCGPVcqswRbSyk4zPDMbD7caSy4Q-KOaiwDFRZyMiTiqCHooa75VpJxp8nsDYgDZR44GDTHR3C-1cUbODGydGH7VZAtKpUCG_KQj7mqdZXRPekyyeaDqZRUEb-9YCwKaDvrS1TOztSEZhqxiJIP5_WvL8utyGY6WiEzOz4_2Xhn-dLDeZtB-p0l3gqveda2DezUe71RgbC7BiCYnin-77VE_ikZjsnWEdItrbeCTjfOJ1J-v9OSgEcBjVVM",
                              ),
                            ],
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final p = results[index];
                            return _buildResultCard(
                              p.name,
                              "Category", // Placeholder as db query needs improvements to fetch cat name
                              "\$${(p.variants.isNotEmpty ? p.variants.first.price : 0).toStringAsFixed(2)}",
                              "4.5", // Placeholder rating
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuDmbJsGng2Fk9RFeGq9qX_OOx2xJoyMyC-S2YBvsbT7swi0Zq5rgwjIEzZiBDP7o-Ge6uB7U-N2qa9zWxYrLcLUIIJQ2iFm5tk0_ieq2MyxeZiFjbygPqtFX50su9jWjPbS-9SmIUjKSQk3qpJA-WYpMVkYkORZwDBZRP3TqCu7dzlJm2Pk2oRw83zbyHgtZXMKXGWBu8QLpWg1clhqLp_n7f0gTM3M_mCVI2juZNbL21r0oaeRqOH7RIqpqjxQIYdBhGKAFccgUYk", // Placeholder img if none
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    const primaryColor = Color(0xFFFF9F1C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.blueGrey.shade100,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.blueGrey.shade500,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String title,
    String subtitle,
    String price,
    String rating,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueGrey.shade50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey.shade900,
            ),
            maxLines: 1,
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFFFF9F1C),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.blueGrey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
