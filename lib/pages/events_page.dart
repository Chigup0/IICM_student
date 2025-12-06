import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../config/api_config.dart';
import '../constants/colors.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<dynamic>> _eventsFuture;
  String _selectedDay = 'Day 1';

  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
  }

  Future<List<dynamic>> _fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/events'));
      if (response.statusCode == 200) {
        final List<dynamic> events = json.decode(response.body);
        // Sort events by date
        events.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB);
        });
        return events;
      }
      throw Exception('Failed to load events');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: FutureBuilder<List<dynamic>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryAccent,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No events available',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            );
          }

          // Group events by date
          final groupedEvents = <String, List<dynamic>>{};
          final startDate = DateTime.parse('2025-12-20');

          for (final event in snapshot.data!) {
            final eventDate = DateTime.parse(event['date']);
            final dayDifference = eventDate.difference(startDate).inDays + 1;
            final key = 'Day $dayDifference';

            if (!groupedEvents.containsKey(key)) {
              groupedEvents[key] = [];
            }
            groupedEvents[key]!.add(event);
          }

          final dayKeys = groupedEvents.keys.toList();
          final selectedEvents = groupedEvents[_selectedDay] ?? [];

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),

                /// 🔹 Day Toggle Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: dayKeys.map((dayKey) {
                        final isSelected = _selectedDay == dayKey;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDay = dayKey;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isSelected
                                    ? AppColors.primaryAccent
                                    : AppColors.secondaryBackground,
                                border: Border.all(
                                  color: AppColors.primaryAccent.withOpacity(
                                    isSelected ? 0 : 0.4,
                                  ),
                                  width: 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryAccent
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                dayKey,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryText,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 Events List for Selected Day
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...selectedEvents
                          .map((event) => _EventCard(event: event))
                          .toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventCard({required this.event});

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatTime(String timeString, BuildContext context) {
    try {
      final time = timeString.split(':');
      final hour = int.parse(time[0]);
      final minute = int.parse(time[1]);
      final timeOfDay = TimeOfDay(hour: hour, minute: minute);
      return timeOfDay.format(context);
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryAccent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEventDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event name as title
                Text(
                  event['name'] ?? 'Unknown Event',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryAccent,
                  ),
                ),
                const SizedBox(height: 12),
                // Description/Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Event details
                _buildDetailRow(
                  Icons.calendar_today_rounded,
                  _formatDate(event['date']),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.access_time_rounded,
                  '${_formatTime(event['start_time'], context)} - ${_formatTime(event['end_time'], context)}',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.location_on_rounded,
                  event['venue'] ?? 'N/A',
                ),
                const SizedBox(height: 12),
                // Tap to view more indicator
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Tap for details →',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryAccent.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showEventDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Event name
              Text(
                event['name'] ?? 'Unknown Event',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryAccent,
                ),
              ),
              const SizedBox(height: 12),
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  event['description'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Details section
              _DetailSection(
                icon: Icons.calendar_today_rounded,
                title: 'Date',
                value: _formatDate(event['date']),
              ),
              const SizedBox(height: 20),
              _DetailSection(
                icon: Icons.access_time_rounded,
                title: 'Time',
                value:
                    '${_formatTime(event['start_time'], context)} - ${_formatTime(event['end_time'], context)}',
              ),
              const SizedBox(height: 20),
              _DetailSection(
                icon: Icons.location_on_rounded,
                title: 'Venue',
                value: event['venue'] ?? 'N/A',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryAccent, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
