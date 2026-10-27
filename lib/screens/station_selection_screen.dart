import 'package:flutter/material.dart';
import '../data/indian_stations.dart';
import '../models/station.dart';
import '../models/ticket.dart';
import '../widgets/station_search_sheet.dart';
import 'booked_ticket_screen.dart';

class StationSelectionScreen extends StatefulWidget {
  const StationSelectionScreen({super.key});

  @override
  State<StationSelectionScreen> createState() => _StationSelectionScreenState();
}

class _StationSelectionScreenState extends State<StationSelectionScreen>
    with SingleTickerProviderStateMixin {
  // Ticket type tab: 0 = Normal, 1 = Season
  int _selectedTicketTab = 0;

  // Station location mode: 0 = Outside Station, 1 = At Station
  int _selectedLocationMode = 0;

  Station? _sourceStation;
  Station? _destinationStation;

  late AnimationController _swapAnimController;

  final List<Map<String, String>> _recentSearches = [
    {
      'srcName': 'DUMDUM JN.',
      'srcCode': 'DDJ',
      'destName': 'BARASAT JN.',
      'destCode': 'BT',
    },
    {
      'srcName': 'BARASAT JN.',
      'srcCode': 'BT',
      'destName': 'DUMDUM JN.',
      'destCode': 'DDJ',
    },
    {
      'srcName': 'BARRACKPORE',
      'srcCode': 'BP',
      'destName': 'DUMDUM JN.',
      'destCode': 'DDJ',
    },
    {
      'srcName': 'SEALDAH',
      'srcCode': 'SDAH',
      'destName': 'BARRACKPORE',
      'destCode': 'BP',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Default initial stations matching screenshot 2
    _sourceStation = const Station(
      code: 'DDJ',
      name: 'DUMDUM JN.',
      hindiName: 'दमदम जंक्शन',
      city: 'Kolkata',
      zone: 'ER',
    );
    _destinationStation = const Station(
      code: 'BT',
      name: 'BARASAT JN.',
      hindiName: 'बारासात जंक्शन',
      city: 'Kolkata',
      zone: 'ER',
    );

    _swapAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _swapAnimController.dispose();
    super.dispose();
  }

  void _swapStations() {
    _swapAnimController.forward(from: 0.0);
    setState(() {
      final temp = _sourceStation;
      _sourceStation = _destinationStation;
      _destinationStation = temp;
    });
  }

  void _openStationSearch(bool isSource) async {
    final result = await StationSearchSheet.show(
      context,
      title: isSource ? 'Select Source Station' : 'Select Destination Station',
      selectedStation: isSource ? _sourceStation : _destinationStation,
    );

    if (result != null) {
      setState(() {
        if (isSource) {
          _sourceStation = result;
        } else {
          _destinationStation = result;
        }
      });
    }
  }

  void _selectRecentSearch(Map<String, String> item) {
    setState(() {
      _sourceStation = Station(
        code: item['srcCode']!,
        name: item['srcName']!,
        hindiName: item['srcName']!,
        city: 'Kolkata',
        zone: 'ER',
      );
      _destinationStation = Station(
        code: item['destCode']!,
        name: item['destName']!,
        hindiName: item['destName']!,
        city: 'Kolkata',
        zone: 'ER',
      );
    });
  }

  void _onProceedToBook() {
    if (_sourceStation == null || _destinationStation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both Source and Destination stations.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    if (_sourceStation!.code == _destinationStation!.code) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Source and Destination stations cannot be the same!'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    // Automatically generate ticket with current date & time
    final ticket = Ticket.generate(
      source: _sourceStation!,
      destination: _destinationStation!,
      trainType: 'ORDINARY (ORD)',
      travelClass: 'SECOND (II)',
      adults: 1,
      children: 0,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookedTicketScreen(ticket: ticket),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with centered title and right close icon
              _buildTopBar(),

              const SizedBox(height: 12),

              // White Booking Card
              _buildMainCard(),

              const SizedBox(height: 28),

              // Recent Searches Section
              _buildRecentSearchesSection(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Unreserved E-Ticket',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D2952),
                letterSpacing: -0.2,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD6E6FA), width: 1.5),
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Color(0xFF0066FF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFECEFF2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D2952).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Normal / Season Segmented Tab
          _buildSegmentedTab(),

          const SizedBox(height: 18),

          // 2. Outside Station / At Station Pills
          _buildLocationPills(),

          const SizedBox(height: 24),

          // 3. From & To Station Inputs with Swap Button
          _buildStationInputsBox(),

          const SizedBox(height: 32),

          // 4. Primary "Proceed To Book" Button
          _buildProceedButton(),

          const SizedBox(height: 14),

          // 5. Secondary "Check Upcoming Trains" Button
          _buildCheckTrainsButton(),

          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildSegmentedTab() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTicketTab = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedTicketTab == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: _selectedTicketTab == 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Normal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _selectedTicketTab == 0
                        ? const Color(0xFF0066FF)
                        : const Color(0xFF2D3748),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTicketTab = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedTicketTab == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: _selectedTicketTab == 1
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Season',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _selectedTicketTab == 1
                        ? const Color(0xFF0066FF)
                        : const Color(0xFF2D3748),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPills() {
    return Row(
      children: [
        // Outside Station (Active by default)
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedLocationMode = 0),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _selectedLocationMode == 0
                    ? const Color(0xFF0066FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: _selectedLocationMode == 0
                    ? null
                    : Border.all(color: const Color(0xFFD6DBE1), width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Outside Station',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _selectedLocationMode == 0
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.info_outline,
                    size: 15,
                    color: _selectedLocationMode == 0
                        ? Colors.white
                        : const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // At Station
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedLocationMode = 1),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _selectedLocationMode == 1
                    ? const Color(0xFF0066FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: _selectedLocationMode == 1
                    ? null
                    : Border.all(color: const Color(0xFFD6DBE1), width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'At Station',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _selectedLocationMode == 1
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.info_outline,
                    size: 15,
                    color: _selectedLocationMode == 1
                        ? Colors.white
                        : const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStationInputsBox() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FROM
            const Text(
              'From',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7), // Light blue label as in screenshot
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _openStationSearch(true),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_subway_outlined,
                      size: 22,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _sourceStation != null
                            ? '${_sourceStation!.name}, ${_sourceStation!.code}'
                            : 'Source',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _sourceStation != null
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _sourceStation != null
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFCBD5E1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 48), // Padding for swap button
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),

            // TO
            const Text(
              'To',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7),
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _openStationSearch(false),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_subway_outlined,
                      size: 22,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _destinationStation != null
                            ? '${_destinationStation!.name}, ${_destinationStation!.code}'
                            : 'Destination',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _destinationStation != null
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _destinationStation != null
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFCBD5E1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 48), // Padding for swap button
                  ],
                ),
              ),
            ),
          ],
        ),

        // THE CIRCULAR SWAP BUTTON
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: _swapStations,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFD6E6FA), // Light soft blue circle
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0066FF).withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: RotationTransition(
                turns: _swapAnimController,
                child: const Icon(
                  Icons.swap_vert,
                  color: Color(0xFF0066FF),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _onProceedToBook,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0066FF), // Exact electric blue
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26), // Smooth rounded pill
          ),
        ),
        child: const Text(
          'Proceed To Book',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckTrainsButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Checking upcoming trains on this route...'),
              backgroundColor: Color(0xFF0066FF),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF0066FF), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.white,
        ),
        child: const Text(
          'Check Upcoming Trains',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0066FF),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0D2952),
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 104,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _recentSearches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = _recentSearches[index];
              return InkWell(
                onTap: () => _selectRecentSearch(item),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 175,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0EFFF), // Soft light-blue background
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD0E4FA)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item['srcName']}, ${item['srcCode']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D2952),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // S-curve connector icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0066FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 16,
                            height: 2,
                            color: const Color(0xFF90BFFF),
                          ),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0066FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${item['destName']}, ${item['destCode']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D2952),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
