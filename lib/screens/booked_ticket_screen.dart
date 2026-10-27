import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ticket.dart';

class BookedTicketScreen extends StatefulWidget {
  final Ticket ticket;

  const BookedTicketScreen({super.key, required this.ticket});

  @override
  State<BookedTicketScreen> createState() => _BookedTicketScreenState();
}

class _BookedTicketScreenState extends State<BookedTicketScreen> {
  // 5-Minute Countdown Timer (Starts from 5min and goes to 0)
  int _secondsRemaining = 300;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _secondsRemaining = 300;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins : $secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xFF1976D2),
        automaticallyImplyLeading: false,
        titleSpacing: 12,
        title: Row(
          children: [
            // Circular Back Button
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Mobile: ${widget.ticket.mobileNumber}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // White Greeting Banner
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Thank You ${widget.ticket.passengerName}, Happy Journey !',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                children: [
                  // DYNAMIC PREVIEW BOX (DARK GLOWING CARD)
                  _buildDynamicPreviewCard(),

                  const SizedBox(height: 14),

                  // WHITE SEASON TICKET DETAILS CARD
                  _buildSeasonTicketCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicPreviewCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C222B), Color(0xFF12161D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2AD5C9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF2AD5C9).withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Rail: INDIAN RAILWAYS (Vertical)
            Container(
              width: 32,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Color(0x33FFFFFF),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: const Text(
                  'INDIAN RAILWAYS',
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            // Center Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Dynamic preview will close in',
                      style: TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Glowing 5-Minute Countdown
                    Text(
                      _formatTimer(_secondsRemaining),
                      style: const TextStyle(
                        color: Color(0xFFFF453A),
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Color(0xAAFF453A),
                            blurRadius: 16,
                          ),
                          Shadow(
                            color: Color(0x66FF453A),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    const Text(
                      'Ticket Booking Date & Time',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Orange Booking Date & Time
                    Text(
                      widget.ticket.formattedOrangeDate,
                      style: const TextStyle(
                        color: Color(0xFFFF9F0A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),

                    Text(
                      widget.ticket.bookingRefCode,
                      style: const TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),

                    const Text(
                      'Ticket is Non-Transferable',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Rail: भारतीय रेल (Vertical)
            Container(
              width: 32,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Color(0x33FFFFFF),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: const Text(
                  'भारतीय रेल',
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonTicketCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFECEFF2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Season Ticket + ACTIVE Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Season Ticket',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.ticket.seasonTicketCode,
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 1: Source & Destination
          _buildTwoColRow(
            leftLabel: 'Source',
            leftValue: widget.ticket.source.name,
            rightLabel: 'Destination',
            rightValue: widget.ticket.destination.name,
          ),

          const SizedBox(height: 12),

          // Row 2: Distance & Booked on
          _buildTwoColRow(
            leftLabel: 'Distance',
            leftValue: '${widget.ticket.distanceKm} km',
            rightLabel: 'Booked on',
            rightValue: widget.ticket.formattedBookingTime,
          ),

          const SizedBox(height: 12),

          // Row 3: Ticket Type & Train Types
          _buildTwoColRow(
            leftLabel: 'Ticket Type',
            leftValue: widget.ticket.ticketType,
            rightLabel: 'Train Types',
            rightValue: widget.ticket.trainType,
          ),

          const SizedBox(height: 12),

          // Row 4: Class & Fare
          _buildTwoColRow(
            leftLabel: 'Class',
            leftValue: widget.ticket.travelClass,
            rightLabel: 'Fare',
            rightValue: widget.ticket.fareAmount.toStringAsFixed(2),
          ),

          const SizedBox(height: 12),

          // Row 5: Valid From & Valid Upto (Exact 30 Days from current date)
          _buildTwoColRow(
            leftLabel: 'Valid From',
            leftValue: widget.ticket.formattedValidFrom,
            rightLabel: 'Valid Upto',
            rightValue: widget.ticket.formattedValidUpto,
          ),

          const SizedBox(height: 8),

          // Row 6: Route Info (Via: DDC)
          Row(
            children: [
              const Icon(Icons.fork_right, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                'Via: ${widget.ticket.viaRoute}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Row 7: Passenger Name & Age
          _buildTwoColRow(
            leftLabel: 'Name',
            leftValue: widget.ticket.passengerName,
            rightLabel: 'Age',
            rightValue: widget.ticket.passengerAge,
          ),

          const SizedBox(height: 12),

          // Row 8: ID Type* & ID Number
          _buildTwoColRow(
            leftLabel: 'ID Type*',
            leftValue: widget.ticket.idType,
            rightLabel: 'ID Number',
            rightValue: widget.ticket.idNumber,
            valueColor: const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColRow({
    required String leftLabel,
    required String leftValue,
    required String rightLabel,
    required String rightValue,
    Color valueColor = const Color(0xFF1E293B),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftLabel,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                leftValue,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rightLabel,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                rightValue,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
