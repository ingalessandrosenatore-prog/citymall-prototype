import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Stato/ProductProvider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double _distance = 7.5;

  @override
  void initState() {
    super.initState();
    // Load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF9F1C);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://lh3.googleusercontent.com/aida-public/AB6AXuB6OeZ3R0cA-cBmDFLeg4ceLH9i0Cl8oEgv7DllswlI0_cbouM5uXzKEmc7XKkqhZOJy6EvQvMrzXyPCz8VU8wp7_gFUJ8gMy87o0_R6jpBC_KGm8h1peGyMNnAbfOPdv1oqhROIklhLZAyJTVRe_NbSrDNdHblpRE-eIjmGYi5iAbzvZbPKOls2nuJiCOSCNi2qLuB3siifzwKViS-AVckqeWwGFgX_vUKTvwA4eqDduMv7KuJqWHZRaKCBwRcBXzMOSf4d31wOUQ",
                                  fit: BoxFit.cover,
                                  width: 48,
                                  height: 48,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.person),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Title
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 28,
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

                        // Actions
                        Row(
                          children: [
                            _buildHeaderButton(Icons.notifications_outlined),
                            const SizedBox(width: 8),
                            _buildHeaderButton(Icons.settings_outlined),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Distance Slider Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blueGrey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Distance",
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${_distance.toStringAsFixed(1)} km",
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: primaryColor,
                              inactiveTrackColor: Colors.blueGrey.shade200,
                              thumbColor: primaryColor,
                              overlayColor: primaryColor.withOpacity(0.2),
                              trackHeight: 6.0,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12,
                              ),
                            ),
                            child: Slider(
                              value: _distance,
                              min: 0,
                              max: 15,
                              onChanged: (val) {
                                setState(() => _distance = val);
                                // Trigger filter update logic here if needed
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "0km",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey.shade400,
                                  ),
                                ),
                                Text(
                                  "15km",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Special Offers
              _buildSectionHeader("Special Offers", "See all"),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildOfferCard(
                      "50% Off",
                      "Summer Collection",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuB18yjTrzpmE1Xq2mPvLkTZkGmzZeD3x4Hm_l-okjRBzlSBj-wZ_5smX-t9BDisv0GS9uR-S2TCWOJSknfsPK1izg8ezHxlt5riXgwE3zaTnJuabYCtE2Zrzni3hEi2w_4Y3g9fP2-Lfw3zCTvpR7v-En5uI-0ee8r0AHqtLc5K221NJ-inl5Z2Nee2BZ0ejGlYsMIX_FxBbm3Mu6FvfINIwx8Hul1pHL_DCJ5Us371On4WPOjNBk56Q_4lIEdkuAc_QmPVQ-rhXm0",
                      primaryColor,
                    ),
                    const SizedBox(width: 16),
                    _buildOfferCard(
                      "New Arrival",
                      "Nike Air Max Exclusive",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuAC-ipA5i9Xh-cXs7RgNe3moj2Dsv49ZMkADLJH7m4DFmrr9oMcmQY_spFqKR3uEY6Iqjxl92nHnnYrB5kh_sXxUsNZUqebtiZ10ew_ElfO2e529R23DL1Rot1aTDVMJ3peVmUiESaVxfWcuZgZV38T8bVzawyXDRvSUIweXzAiXxXxg0cYx7F0WvfE2oagCa0li4IuBlWrHr713CynI0D0rTMqDZ_2wwZc2TTgZUH8RWJ83qlLOxwCHms1IkVSNe9c76IqiuDGAvk",
                      Colors.purple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue Shopping
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Continue Shopping",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blueGrey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blueGrey.shade100,
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuBokp-asQAy7YGJF53pgIIFvEOA9B7DimccXKD2M00nLmXtUAiDB4faXk6_uo9kCsIFptB1aw6uEC3gcEou2hzd5Zg7oNxn9MP1Q2o88N5Gp2AZQHLQ8JKBYaBvqL9aQA7mFjCnENjOHJS3GsqsY4cqB1_QIr4aQGngxf8vhz0NBC4emnVcDv5dzGEwpGmsxeoXhgP8s-ogSR89QAFNR_SHsYIE1jdQXD1OGHmNocpL7e_8M-s0ZM6E4T1e8uw4ldzqRMJWzm6cS5k",
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sony WH-1000XM4",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "In cart: 1 item",
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: 0.6,
                                    backgroundColor: Colors.blueGrey.shade100,
                                    color: primaryColor,
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Trending Products (Vertical)
              _buildSectionHeader("Trending Products", ""),
              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // If no recommended use placeholders or real data
                  final products = provider
                      .recommendedProducts; // Using recommended as placeholder for trending
                  // Or use hardcoded if DB empty
                  if (products.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildTrendingProductCard(
                            "Smartphone Ultra",
                            "\$899.00",
                            Icons.smartphone,
                          ),
                          const SizedBox(height: 12),
                          _buildTrendingProductCard(
                            "Urban Sneakers",
                            "\$129.50",
                            Icons.directions_run,
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: products
                        .map(
                          (p) => _buildTrendingProductCard(
                            p.name,
                            "\$${(p.variants.isNotEmpty ? p.variants.first.price : 0).toStringAsFixed(2)}",
                            Icons.shopping_bag,
                          ),
                        )
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Recommended Stores (Horizontal)
              _buildSectionHeader("Recommended Stores", ""),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildStoreCard(
                      "Zara Home",
                      "Interior Design",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuBv99cycKc7u-2EIrWsMull4nHzcMWmNBq0IwhLlgDgAmczbm7tQKpVGEYc8vWFfEBGL0dSXfyrDTLFfyTqmvt4Bq0lOne5esDsOTLVVv6jTM99gSlS9Mq1QlBImwG1ab95F7lQk96u1IuswIzpHZ8plXinr3YbBoNL_5yOEvwmAEvCdhDQCmXcL28I6CYXKNWzhM0HBGzh1OnnX3kNZs82MGGhVLscT8rcgSDkH5riRDMjhGIprCtBCerW8jo-l5Iaz2CYN3IgHoQ",
                    ),
                    const SizedBox(width: 12),
                    _buildStoreCard(
                      "Barcellona",
                      "Imported Goods",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuBdfnL8Q7HgaUaOmUSvSuc2ahNLHZ96D5phEYDURotvBrN2Td-fwpefghFAJYqewnmKkQakAk-EU1fXNeEfQnfgfH-iJJikV6R6HqthFCo0B_joeMBbOENJk9qnae338f3YoyfhKMphXE9rlSD9CVLznFOFKmcxUe6JmShendNQzZRNzI839y0RypTyZgPbSnNclp-t9d6hOlMfMLvR8gW2Wq8x7EU0ULgDWvn7meiRI6cbTQ0btPRmMrt3bq1clJ6J60xIXxlaR2Y",
                    ),
                    const SizedBox(width: 12),
                    _buildStoreCard(
                      "Tech Hub",
                      "Electronics",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuBM-MPjh4bfRTRd0b7XY9ZVfK2rXjhNbRJZfABc0Cau8BZQNkQTtfg6q-JJ_LB_fK1WRdoODn_EQ2ShzesPbBE0ueh4QIhA8yA_PDPhD-0aoS8FEQQ00_5tvoVJQs0obfX1WjBJkFR1c5Zb0aRFJ8rA43jSdDzy4tKjdPmFl4mnP6DwegkdY3ah1X43CR-iI8F2V0AuPgBeDWEnJxTYlcUaqQWFXn4u_v32ra4ZkEtn9BrcbZ9kWM7sjwJcoCb91PNWU0htq42CPPc",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // You Might Like Grid
              _buildSectionHeader("You Might Like", ""),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                  children: [
                    _buildGridProduct(
                      "Smart Watch V2",
                      "\$199",
                      "4.8",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuBDpwZoI5HE93TXoIYIR0g7Z8ds89hMSRhTKsfptllV15IjxrPyXZQ5PHq_RWjLnmvylttRjJm-HDTQhnT9I-1wNc-X82kpl10v68fu7-6LdD2w1_j11xh_lmqvfxkeU_h8Nz6qIfok-B8BMP1OZMvzZErWcNbKPW48bpxmQonCm4iahPCqyEwCD4uGZb6nC9de9BrssXG-FupjsLYdCgXi2Qa8bssowVmElUEakZYVu-aWCiMfrxKei113D3w8-XP2qMy-58OeBUY",
                    ),
                    _buildGridProduct(
                      "Apple Watch Series",
                      "\$399",
                      "4.9",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuAM3izw5lgC8QcRQWcgMn37QflB8LmXpuMJ-5xvDnKr_MO3CHO8h7ujdfyOratd2WSkxDKoEb0nCGcgnBgaOT17jjke2XWJdnGpNdAJGKNzdGQuMzo4Ynbe_h2HLhHZbra1dFbvVj-CHzEx7JxVS4_STx1u4DHKfVXC3wzBndGFxg7R8eWqZPdo8XKSg-_BzJHkWTJU-FkH58zO3OojjeImNgCBL3RxF1ld0sbfLF5zAZeISUEdpq5v32qcbhK_M7E5K2Dm7w6YdxU",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon) {
    return Container(
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
      child: Icon(icon, color: Colors.blueGrey.shade600, size: 20),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (action.isNotEmpty)
            Text(
              action,
              style: const TextStyle(
                color: Color(0xFFFF9F1C),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(
    String badge,
    String title,
    String imageUrl,
    Color badgeColor,
  ) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Shop Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingProductCard(String title, String price, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.grey.shade400, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFFFF9F1C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9F1C),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9F1C).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(String name, String category, String imageUrl) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridProduct(
    String title,
    String price,
    String rating,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFFFF9F1C),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Icon(
                Icons.add_shopping_cart_rounded,
                size: 18,
                color: Colors.blueGrey.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
