import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "My Tickets",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      child: const TicketsBody(),
    );
  }
}

class TicketsBody extends StatelessWidget {
  const TicketsBody({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from provider
    final hasTickets = false; // This should come from a provider
    final tickets = <TicketModel>[]; // This should come from a provider

    // For now, always show empty state since we don't have real data
    return _buildEmptyState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.confirmation_number_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Tickets Yet",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "When you book a class, your tickets will appear here",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to discovery page
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.explore),
              label: const Text("Explore Classes"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, TicketModel ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Navigate to ticket details
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status and date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(ticket.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ticket.status.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(ticket.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      ticket.date,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Event details
                Text(
                  ticket.eventName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  ticket.teacherName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Time and location
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ticket.time,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ticket.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Ticket ID and actions
                Row(
                  children: [
                    Text(
                      "Ticket #${ticket.id}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Spacer(),
                    if (ticket.status == 'confirmed')
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Show QR code or ticket details
                        },
                        icon: const Icon(Icons.qr_code),
                        label: const Text("View QR"),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// TODO: Move this to a proper model file
class TicketModel {
  final String id;
  final String eventName;
  final String teacherName;
  final String date;
  final String time;
  final String location;
  final String status;

  TicketModel({
    required this.id,
    required this.eventName,
    required this.teacherName,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
  });
}
