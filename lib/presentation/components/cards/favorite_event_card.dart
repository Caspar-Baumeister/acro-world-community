// import 'package:acroworld/data/models/class_event.dart';
// import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
// import 'package:acroworld/routing/route_names.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class FavoriteEventCard extends StatelessWidget {
//   final ClassEvent event;
//   final bool isPastEvent;

//   const FavoriteEventCard({
//     super.key,
//     required this.event,
//     this.isPastEvent = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final classModel = event.classModel;

//     if (classModel == null) return const SizedBox.shrink();

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: colorScheme.outline.withOpacity(0.1),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: colorScheme.shadow.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             context.pushNamed(
//               singleEventWrapperRoute,
//               pathParameters: {"urlSlug": classModel.urlSlug ?? ''},
//               queryParameters: {"event": event.id ?? ''},
//             );
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Event Image
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: colorScheme.surfaceContainerHighest,
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: classModel.imageUrl != null
//                         ? CachedNetworkImage(
//                             imageUrl: classModel.imageUrl!,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => Container(
//                               color: colorScheme.surfaceContainerHighest,
//                               child: Icon(
//                                 Icons.fitness_center,
//                                 color: colorScheme.onSurfaceVariant,
//                                 size: 32,
//                               ),
//                             ),
//                             errorWidget: (context, url, error) => Container(
//                               color: colorScheme.surfaceContainerHighest,
//                               child: Icon(
//                                 Icons.fitness_center,
//                                 color: colorScheme.onSurfaceVariant,
//                                 size: 32,
//                               ),
//                             ),
//                           )
//                         : Icon(
//                             Icons.fitness_center,
//                             color: colorScheme.onSurfaceVariant,
//                             size: 32,
//                           ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
                
//                 // Event Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Class Name
//                       Text(
//                         classModel.name ?? 'Unnamed Class',
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
                      
//                       // Date and Time
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today,
//                             size: 16,
//                             color: colorScheme.primary,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               _formatEventDateTime(),
//                               style: theme.textTheme.bodyMedium?.copyWith(
//                                 color: colorScheme.primary,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
                      
//                       // Location
//                       if (classModel.locationName != null) ...[
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               size: 16,
//                               color: colorScheme.onSurfaceVariant,
//                             ),
//                             const SizedBox(width: 4),
//                             Expanded(
//                               child: Text(
//                                 classModel.locationName!,
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: colorScheme.onSurfaceVariant,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
                      
//                       // Teachers
//                       if (classModel.classTeachers != null && classModel.classTeachers!.isNotEmpty) ...[
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.person,
//                               size: 16,
//                               color: colorScheme.onSurfaceVariant,
//                             ),
//                             const SizedBox(width: 4),
//                             Expanded(
//                               child: Text(
//                                 classModel.classTeachers!
//                                     .map((ct) => ct.teacher?.name ?? 'Unknown')
//                                     .join(', '),
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: colorScheme.onSurfaceVariant,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
                
//                 // Past Event Indicator
//                 if (isPastEvent)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: colorScheme.surfaceContainerHighest,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       'Past',
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: colorScheme.onSurfaceVariant,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatEventDateTime() {
//     if (event.startDate == null) return 'Date TBD';
    
//     try {
//       return DateTimeService.getDateString(
//         event.startDate!,
//         event.endDate,
//       );
//     } catch (e) {
//       // Fallback to simple date formatting
//       final start = DateTime.parse(event.startDate!);
//       final end = event.endDate != null ? DateTime.parse(event.endDate!) : null;
      
//       if (end != null && start.day != end.day) {
//         // Multi-day event
//         return '${start.day}. ${_getMonthName(start.month)} - ${end.day}. ${_getMonthName(end.month)}';
//       } else {
//         // Single day event
//         return '${start.day}. ${_getMonthName(start.month)} • ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
//       }
//     }
//   }

//   String _getMonthName(int month) {
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return months[month - 1];
//   }
// }
