import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/screens/users/user_list_screen.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:acroworld/shared/widgets/open_google_maps.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleClassBody extends StatelessWidget {
  const SingleClassBody(
      {Key? key, required this.classEvents, required this.classe})
      : super(key: key);

  final List<ClassEvent> classEvents;
  final ClassModel classe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        classe.imageUrl != null
            ? SizedBox(
                height: 200.0,
                width: double.infinity,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        classe.imageUrl!,
                      )),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SpacedColumn(
            space: 10,
            children: [
              const SizedBox(height: 20),
              ReadMoreText(
                classe.description,
                trimLines: 2,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: const TextStyle(color: PRIMARY_COLOR),
                lessStyle: const TextStyle(color: PRIMARY_COLOR),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  classe.requirements != null
                      ? Container(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Requirements",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(classe.requirements!)
                            ],
                          ),
                        )
                      : Container(),
                  classe.pricing != null
                      ? Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Prices",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                classe.pricing!,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  classe.uscUrl != null
                      ? LinkButton(text: "Urban Sport", link: classe.uscUrl!)
                      : Container(),
                  classe.classPassUrl != null
                      ? LinkButton(
                          text: "Class Pass", link: classe.classPassUrl!)
                      : Container(),
                  classe.websiteUrl != null
                      ? LinkButton(text: "Website", link: classe.websiteUrl!)
                      : Container(),
                ],
              ),
              const Divider(),
              classe.latitude != null && classe.longitude != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Avenue",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            OpenGoogleMaps(
                              latitude: classe.latitude!,
                              longitude: classe.longitude!,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: MapWidget(
                            zoom: 15.0,
                            center: LatLng(classe.latitude!, classe.longitude!),
                            markerLocation:
                                LatLng(classe.latitude!, classe.longitude!),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              classe.latitude != null && classe.longitude != null
                  ? const Divider()
                  : Container(),
              SizedBox(
                child:
                    ClassEventCalendar(kEvents: classEventToHash(classEvents)),
              ),
              const SizedBox(height: 40)
            ],
          ),
        ),
      ],
    ));
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({Key? key, required this.link, required this.text})
      : super(key: key);

  final String link;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () async {
        Uri _url = Uri.parse(link);
        if (!await launchUrl(_url)) {
          throw 'Could not launch $_url';
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ClassEventCalendar extends StatefulWidget {
  const ClassEventCalendar({required this.kEvents, Key? key}) : super(key: key);

  final Map<DateTime, List<ClassEvent>> kEvents;

  @override
  _ClassEventCalendarState createState() => _ClassEventCalendarState();
}

class _ClassEventCalendarState extends State<ClassEventCalendar> {
  late ValueNotifier<List<ClassEvent>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<ClassEvent> _getEventsForDay(DateTime day) {
    // Implementation

    return widget.kEvents[day] ?? [];
  }

  List<ClassEvent> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableCalendar<ClassEvent>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode:
              RangeSelectionMode.disabled, //_rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableCalendarFormats: const {CalendarFormat.week: 'Week'},
          calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                  color: Colors.grey[400]!, shape: BoxShape.circle),
              selectedDecoration: const BoxDecoration(
                  color: PRIMARY_COLOR, shape: BoxShape.circle)),
          onDaySelected: _onDaySelected,
          //onRangeSelected: _onRangeSelected,
          // onFormatChanged: (format) {
          //   if (_calendarFormat != format) {
          //     setState(() {
          //       _calendarFormat = format;
          //     });
          //   }
          // },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        ValueListenableBuilder<List<ClassEvent>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: value.length,
              itemBuilder: (context, index) {
                return ClassEventParticipantQuery(
                  classEvent: value[index],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class ClassEventParticipantQuery extends StatelessWidget {
  const ClassEventParticipantQuery({Key? key, required this.classEvent})
      : super(key: key);
  final ClassEvent classEvent;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Query(
      options: QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: Queries.getClassEventCommunity,
        variables: {
          'class_event_id': classEvent.id,
        },
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return Container();
        }

        VoidCallback runRefetch = (() {
          refetch!();
        });

        List<User> participantsWithMe = List<User>.from(result
            .data!["class_events_participants"]
            .map((u) => User(id: u["user"]["id"], name: u["user"]["name"])));

        List<User> participants = [];
        bool isParticipate = false;
        participantsWithMe.forEach(((element) {
          if (element.id == userProvider.activeUser!.id) {
            isParticipate = true;
          } else {
            participants.add(element);
          }
        }));

        return RefreshIndicator(
          onRefresh: (() async => runRefetch()),
          child: ClassEventTile(
            classEvent: classEvent,
            isParticipate:
                isParticipate, //contains(userProvider.activeUser!.id),
            participants: participants,
          ),
        );
      },
    );
  }
}

class ClassEventTile extends StatefulWidget {
  const ClassEventTile(
      {Key? key,
      required this.classEvent,
      required this.isParticipate,
      required this.participants})
      : super(key: key);

  final ClassEvent classEvent;
  final bool isParticipate;
  final List<User> participants;

  @override
  State<ClassEventTile> createState() => _ClassEventTileState();
}

class _ClassEventTileState extends State<ClassEventTile> {
  late bool isParticipateState;

  @override
  void initState() {
    super.initState();
    isParticipateState = widget.isParticipate;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Mutation(
        options: MutationOptions(
            document: isParticipateState
                ? Mutations.leaveParticipateClass
                : Mutations.participateToClass),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          if (result != null && result.hasException) {
            print(result.exception);
          }
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpacedColumn(
                space: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${DateFormat('EEE, H:mm').format(widget.classEvent.date)} - ${DateFormat('Hm').format(widget.classEvent.endDate)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QueryUserListScreen(
                            query: Queries.getClassParticipants,
                            variables: {'class_event_id': widget.classEvent.id},
                            title: 'Participants',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Participants: ${isParticipateState ? "You" : ""}${isParticipateState && widget.participants.isNotEmpty ? ", " : ""}${widget.participants.map((e) => "${e.name}").toList().join(", ")}",
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              isParticipateState ? Colors.grey : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          isParticipateState
                              ? runMutation({
                                  'class_event_id': widget.classEvent.id,
                                  'user_id': userProvider.activeUser!.id!
                                })
                              : runMutation({
                                  'class_event_id': widget.classEvent.id,
                                });
                          Future.delayed(const Duration(milliseconds: 200), () {
                            setState(() {
                              isParticipateState = !isParticipateState;
                            });
                          });
                        },
                        child: const Text(
                          "Participate",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
