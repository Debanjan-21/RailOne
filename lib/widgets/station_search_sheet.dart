import 'package:flutter/material.dart';
import '../constants/rail_colors.dart';
import '../data/indian_stations.dart';
import '../models/station.dart';

class StationSearchSheet extends StatefulWidget {
  final String title;
  final Station? selectedStation;

  const StationSearchSheet({
    super.key,
    required this.title,
    this.selectedStation,
  });

  static Future<Station?> show(
    BuildContext context, {
    required String title,
    Station? selectedStation,
  }) {
    return showModalBottomSheet<Station>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StationSearchSheet(
        title: title,
        selectedStation: selectedStation,
      ),
    );
  }

  @override
  State<StationSearchSheet> createState() => _StationSearchSheetState();
}

class _StationSearchSheetState extends State<StationSearchSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Station> _filteredStations = IndianStations.stationList;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStations = IndianStations.stationList;
      } else {
        _filteredStations = IndianStations.stationList.where((stn) {
          return stn.code.toLowerCase().contains(query) ||
              stn.name.toLowerCase().contains(query) ||
              stn.hindiName.contains(query) ||
              stn.city.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: RailColors.primaryNavy.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.train,
                    color: RailColors.primaryNavy,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: RailColors.textDark,
                        ),
                      ),
                      const Text(
                        'Select from Indian Railways network',
                        style: TextStyle(
                          fontSize: 12,
                          color: RailColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search station by name, code or city...',
                hintStyle: const TextStyle(fontSize: 14, color: RailColors.textLight),
                prefixIcon: const Icon(Icons.search, color: RailColors.primaryNavy),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Popular station quick chips
          if (_searchCtrl.text.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'POPULAR STATIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: RailColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildQuickChip('NDLS', 'New Delhi'),
                        _buildQuickChip('HWH', 'Howrah'),
                        _buildQuickChip('CSMT', 'Mumbai CSMT'),
                        _buildQuickChip('MAS', 'Chennai'),
                        _buildQuickChip('SBC', 'Bengaluru'),
                        _buildQuickChip('PNBE', 'Patna'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const Divider(height: 16),

          // Station Results List
          Expanded(
            child: _filteredStations.isEmpty
                ? const Center(
                    child: Text(
                      'No matching railway station found',
                      style: TextStyle(color: RailColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredStations.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final stn = _filteredStations[index];
                      final isSelected = widget.selectedStation?.code == stn.code;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 56,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? RailColors.primaryNavy
                                : const Color(0xFFEEF2F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            stn.code,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: isSelected ? Colors.white : RailColors.primaryNavy,
                            ),
                          ),
                        ),
                        title: Text(
                          stn.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: RailColors.textDark,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              stn.hindiName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: RailColors.textMuted,
                              ),
                            ),
                            const Text(' • ', style: TextStyle(color: Colors.grey)),
                            Text(
                              '${stn.city} (${stn.zone})',
                              style: const TextStyle(
                                fontSize: 12,
                                color: RailColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: RailColors.primaryNavy)
                            : null,
                        onTap: () {
                          Navigator.of(context).pop(stn);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String code, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: const Color(0xFFF1F5F9),
        label: Text('$code ($label)'),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: RailColors.primaryNavy,
        ),
        onPressed: () {
          final matched = IndianStations.stationList.firstWhere(
            (s) => s.code == code,
            orElse: () => IndianStations.defaultSource,
          );
          Navigator.of(context).pop(matched);
        },
      ),
    );
  }
}
