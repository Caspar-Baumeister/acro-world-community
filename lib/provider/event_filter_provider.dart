import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventFilterProvider extends ChangeNotifier {
  List<String> eventPoster = [];

  List<EventModel> initialEvents = [];
  List<EventModel> activeEvents = [];

  List<String> initialCategories = [];
  List<String> initialCountries = [];
  List<DateTime> initialDates = [];

  List<String> activeCategories = [];
  List<String> activeCountries = [];
  List<DateTime> activeDates = [];

  bool onlyHighlighted = false;

  bool initialized = false;

  // there are allInitalFilter, activeFilter and possibleFilters

  // the inital filter parameters are set after loading the data
  // and everytime the provider is restarted
  EventFilterProvider() {
    // getInitialData();
  }

  setInitialData(List events) {
    // get the events
    initialEvents = events
        .map((event) => EventModel.fromJson(event))
        .where((element) =>
            DateTime.parse(element.startDate!)
                .difference(DateTime.now())
                .inDays >
            0)
        .toList();

    initialCategories = [];
    initialCountries = [];
    initialDates = [];
    activeEvents = initialEvents;

    // set the initialFilter
    for (EventModel event in initialEvents) {
      if (event.eventType != null &&
          !initialCategories.contains(event.eventType)) {
        initialCategories.add(event.eventType!);
      }

      if (event.locationCountry != null &&
          !initialCountries.contains(event.locationCountry)) {
        initialCountries.add(event.locationCountry!);
      }

      try {
        if (event.startDate != null) {
          final newDate = DateTime.parse(event.startDate!);
          bool isInInitialDates =
              isDateMonthAndYearInList(initialDates, newDate);
          if (!isInInitialDates) {
            initialDates.add(newDate);
          }
        }
      } catch (e) {
        print("parsing date in init of filter went wrong");
        print(e.toString());
      }
    }
    initialEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    // TODO INCLUDE YEAR FOR DATES
    initialized = true;
    notifyListeners();
  }
  // when a filter parameter is set to active, all other possibleFilter are recalculated
  // There needs to be a hirachy categories -> location -> time (categorie and location could change)

  // to replace the active categories completly
  setActiveCategory(List<String> newActiveCategories) {
    activeCategories = newActiveCategories;
    // also reset dates
    activeDates = [];
    resetActiveEventsFromFilter();
  }

  changeActiveEventDates(DateTime changeDate) {
    if (isDateMonthAndYearInList(activeDates, changeDate)) {
      activeDates.removeWhere((date) =>
          date.month == changeDate.month && date.year == changeDate.year);
    } else {
      activeDates.add(changeDate);
    }
    resetActiveEventsFromFilter();
  }

  tryAddingActiveEventDates(DateTime addDate) {
    if (!isDateMonthAndYearInList(activeDates, addDate)) {
      activeDates.add(addDate);
    }
    resetActiveEventsFromFilter();
  }

  changeActiveCategory(String changeCategory) {
    if (activeCategories.contains(changeCategory)) {
      activeCategories.remove(changeCategory);
    } else {
      activeCategories.add(changeCategory);
    }
    resetActiveEventsFromFilter();
  }

  changeActiveCountry(String changeCountry) {
    if (activeCountries.contains(changeCountry)) {
      activeCountries.remove(changeCountry);
    } else {
      activeCountries.add(changeCountry);
    }
    resetActiveEventsFromFilter();
  }

  changeHighlighted() {
    onlyHighlighted = !onlyHighlighted;
    resetActiveEventsFromFilter();
  }

  bool resetFilter() {
    activeCategories = [];
    activeCountries = [];
    activeDates = [];
    activeEvents = initialEvents;
    onlyHighlighted = false;
    notifyListeners();
    return true;
  }

  String filterString() {
    String fString = "";

    // Case 1: no filter active
    if (activeCategories.isEmpty &&
        activeDates.isEmpty &&
        activeCountries.isEmpty &&
        !onlyHighlighted) {
      fString = "Set filters";
      return fString;
    }

    // Trainings ...
    if (activeCategories.length == 1) {
      fString += " ${activeCategories[0]},";
    } else if (activeCategories.length > 1) {
      fString += " ${activeCategories[0]} + ${activeCategories.length - 1},";
    }

    // ... Jul ...
    if (activeDates.length == 1) {
      fString += " ${DateFormat.MMM().format(activeDates[0])},";
    } else if (activeDates.length > 1) {
      fString +=
          " ${DateFormat.MMM().format(activeDates[0])} + ${activeDates.length - 1},";
    }

    // ... Germany
    if (activeCountries.length == 1) {
      fString += " ${activeCountries[0]},";
    } else if (activeCountries.length > 1) {
      fString += " ${activeCountries[0]} + ${activeCountries.length - 1},";
    }

    // ... highlights
    if (onlyHighlighted) {
      fString += " highlights,";
    }

    if (fString.isNotEmpty) {
      fString.trim();
    }

    return fString.substring(0, fString.length - 1);
  }

  bool isFilterActive() {
    return activeCategories.isNotEmpty ||
        activeDates.isNotEmpty ||
        activeCountries.isNotEmpty ||
        onlyHighlighted;
  }

  resetActiveEventsFromFilter() {
    List<EventModel> returnEvents = initialEvents;

    if (onlyHighlighted) {
      returnEvents = returnEvents
          .where((EventModel event) => event.isHighlighted == true)
          .toList();
    }

    if (activeCountries.isNotEmpty) {
      returnEvents = returnEvents
          .where((EventModel event) =>
              activeCountries.contains(event.locationCountry))
          .toList();
    }

    if (activeCategories.isNotEmpty) {
      returnEvents = returnEvents
          .where(
              (EventModel event) => activeCategories.contains(event.eventType))
          .toList();
    }
    if (activeDates.isNotEmpty) {
      returnEvents = returnEvents
          .where((EventModel event) =>
              isDateMonthAndYearInList(
                  activeDates, DateTime.parse(event.startDate!)) ||
              isDateMonthAndYearInList(
                  activeDates, DateTime.parse(event.endDate!)))
          // activeDates.contains(event.startDate!).month) ||
          // activeDates.contains(DateTime.parse(event.endDate!).month))
          .toList();
    }

    activeEvents = returnEvents;
    notifyListeners();
  }
}

List testEvents = [
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Pitch Catch Circus',
    'description': '',
    'start_date': '2023-03-13 00:00:00+00:00',
    'end_date': '2023-04-14 00:00:00+00:00',
    'event_type': 'Training',
    'host': '',
    'location_name': 'Asheville',
    'created_at': 'Erstellt: 29.11.2022 13:56:57 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://safeacrobatics.com/en/'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'SAFE Festival SPRING edition',
    'description': '',
    'start_date': '2023-03-24 00:00:00+00:00',
    'end_date': '2023-03-26 00:00:00+00:00',
    'main_image_url':
        'https://safeacrobatics.com/static/cropped-SAFE_logo3-192x192.png',
    'event_type': 'Festivals und Cons',
    'host': 'Safe acrobatics',
    'location_name': 'Športno društvo GIB, Ljubjana, Slovenia',
    'created_at': 'Erstellt: 26.11.2022 10:48:46 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Encuentro Acroyoga Valencia',
    'description': '',
    'start_date': '2023-03-24 00:00:00+00:00',
    'end_date': '2023-03-26 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Valencia',
    'created_at': 'Erstellt: 28.11.2022 04:00:49 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro-Weekend Wiesbaden',
    'description': 'Anmeldung via Link',
    'start_date': '2023-03-25 00:00:00+00:00',
    'end_date': '2023-03-26 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Acro_Simon',
    'location_name': 'Wiesbaden',
    'created_at': 'Erstellt: 18.03.2023 14:28:02 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://www.flowmotionstudio.de/berlin-acro-mini-convention-2022/'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Berlin Acro Mini Convention',
    'description': '',
    'start_date': '2023-04-01 00:00:00+00:00',
    'end_date': '2023-04-02 00:00:00+00:00',
    'main_image_url':
        'https://www.flowmotionstudio.de/wp-content/uploads/2021/04/FMS_Logo_FULL_color-web.png',
    'event_type': 'Festivals und Cons',
    'host': 'Flow motion',
    'location_name': 'Berlin',
    'created_at': 'Erstellt: 19.03.2023 07:30:01 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acronyx',
    'description': '',
    'start_date': '2023-04-02 00:00:00+00:00',
    'end_date': '2023-04-13 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Würzburg',
    'created_at': 'Erstellt: 06.02.2023 07:15:41 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://instagram.com/easter.acro?igshid=YmMyMTA2M2Y='],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Easter Acro',
    'description': '',
    'start_date': '2023-04-07 00:00:00+00:00',
    'end_date': '2023-04-09 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Belgium',
    'created_at': 'Erstellt: 10.01.2023 07:27:38 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://www.leaptoprague.com/'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'LEAP 2023',
    'description': 'Little European Acrobatic Programm',
    'start_date': '2023-04-10 00:00:00+00:00',
    'end_date': '2023-05-12 00:00:00+00:00',
    'event_type': 'Training',
    'host': '',
    'location_name': 'Nahe Prag',
    'created_at': 'Erstellt: 19.10.2022 11:38:36 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Israel Acro Convention',
    'description': 'https://acroisrael.co.il/en/acro-conventions/',
    'start_date': '2023-04-13 00:00:00+00:00',
    'end_date': '2023-04-16 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Metzoke Dragot',
    'created_at': 'Erstellt: 03.11.2022 09:37:56 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://akrobatik.kleinkunst-ka.de'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Karlsruher Akrobatik Convention',
    'description': '',
    'start_date': '2023-04-13 00:00:00+00:00',
    'end_date': '2023-04-16 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': '',
    'created_at': 'Erstellt: 26.11.2022 10:43:25 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://m.facebook.com/events/724828319081681'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Sud Est Acro Fest',
    'description': '',
    'start_date': '2023-04-21 00:00:00+00:00',
    'end_date': '2023-04-23 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Puglia, Italy',
    'created_at': 'Erstellt: 10.02.2023 14:03:38 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://dutchacroyogafestival.com/dutch-acroyoga-festival-spring/',
      'https://www.instagram.com/acronia_festival/'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Dutch AcroYoga Festival Spring 2023',
    'description': '',
    'start_date': '2023-04-28 00:00:00+00:00',
    'end_date': '2023-05-07 00:00:00+00:00',
    'main_image_url':
        'https://dutchacroyogafestival.com/wp-content/uploads/2020/02/website_logo_solid_background.png',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': '',
    'created_at': 'Erstellt: 26.11.2022 10:51:12 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://www.timeout-acro.de/timeout-acro-spring-edition-2023-prices'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Timeout Spring',
    'description': '',
    'start_date': '2023-04-28 00:00:00+00:00',
    'end_date': '2023-05-01 00:00:00+00:00',
    'main_image_url':
        'https://static.wixstatic.com/media/035244_459654b5e750462cb9b69d98c0d050e8~mv2.png/v1/fill/w_62,h_62,al_c,q_85,usm_0.66_1.00_0.01,blur_3,enc_auto/035244_459654b5e750462cb9b69d98c0d050e8~mv2.png',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Gemünd Eiffel',
    'created_at': 'Erstellt: 29.11.2022 14:12:57 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro Mayfest France',
    'description': '',
    'start_date': '2023-05-06 00:00:00+00:00',
    'end_date': '2023-05-13 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'France, Saint Julien de la Nef',
    'created_at': 'Erstellt: 29.11.2022 14:35:19 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro-Weekend Braunschweig',
    'description': 'Anmeldung unter cdippner@yahoo.de',
    'start_date': '2023-05-06 00:00:00+00:00',
    'end_date': '2023-05-07 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Acro_simon',
    'location_name': 'Braunschweig',
    'created_at': 'Erstellt: 18.03.2023 14:35:51 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro Spring Slovenia',
    'description': 'https://safeacrobatics.com/en/events/',
    'start_date': '2023-05-08 00:00:00+00:00',
    'end_date': '2023-05-14 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'nice old farm 40 min car drive from Ljubljana, Slovenia',
    'created_at': 'Erstellt: 26.11.2022 10:53:01 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://docs.google.com/forms/d/e/1FAIpQLSdiye58fJAr6WwnO9L_E8WdRfuHKY7U77DOWpLWirKOq2P1EQ/viewform'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'AcroCat',
    'description': '',
    'start_date': '2023-05-11 00:00:00+00:00',
    'end_date': '2023-05-14 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Costa Brava, Barcelona',
    'created_at': 'Erstellt: 29.11.2022 04:23:48 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Dutch Weekend intensive',
    'description': '',
    'start_date': '2023-05-20 00:00:00+00:00',
    'end_date': '2023-05-21 00:00:00+00:00',
    'event_type': 'Training',
    'host': '',
    'location_name': 'Close to Nijmegen, Netherlands',
    'created_at': 'Erstellt: 26.11.2022 10:55:33 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Spring Acroyoga Retreat',
    'description': '',
    'start_date': '2023-05-20 00:00:00+00:00',
    'end_date': '2023-05-26 00:00:00+00:00',
    'event_type': 'Retreats',
    'host': 'Barefootyoga',
    'location_name': 'Croatia, Istra',
    'created_at': 'Erstellt: 29.11.2022 14:33:30 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://forms.gle/ZjhPiT3AuQnFRuo97'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro-Weekend Kiel',
    'description': '',
    'start_date': '2023-05-20 00:00:00+00:00',
    'end_date': '2023-05-21 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Acro_simon',
    'location_name': 'Uni Kiel',
    'created_at': 'Erstellt: 18.03.2023 14:34:13 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://pre-convention.com'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Dutch Preconvention',
    'description': '',
    'start_date': '2023-05-21 00:00:00+00:00',
    'end_date': '2023-05-26 00:00:00+00:00',
    'main_image_url':
        'https://preconvention.files.wordpress.com/2019/12/cropped-colourfull-logo-big.png',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'close to NIjmegen, Netherlands',
    'created_at': 'Erstellt: 26.11.2022 10:54:30 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Dutch Acrobatic Convention',
    'description': '',
    'start_date': '2023-05-26 00:00:00+00:00',
    'end_date': '2023-05-29 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Arnhem',
    'created_at': 'Erstellt: 29.11.2022 14:17:48 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://docs.google.com/forms/d/e/1FAIpQLScYZB9yh4sVDEfth5E08ptsXpl0uSCbOAJ7uZtE_5UP6XGTlw/viewform',
      'https://m.facebook.com/events/1099149584025211/'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'SAC Spring Edition',
    'description': '',
    'start_date': '2023-06-01 00:00:00+00:00',
    'end_date': '2023-06-05 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Sicily',
    'created_at': 'Erstellt: 29.01.2023 08:59:58 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro-Weekend Kassel',
    'description': 'With Simon Weißwange',
    'start_date': '2023-06-03 00:00:00+00:00',
    'end_date': '2023-06-04 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Acroyoga.kassel',
    'location_name': 'Kassel, Zirkus Rambazotti',
    'created_at': 'Erstellt: 27.01.2023 09:50:35 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro Fever Retreat',
    'description': '',
    'start_date': '2023-06-19 00:00:00+00:00',
    'end_date': '2023-06-25 00:00:00+00:00',
    'event_type': 'Retreats',
    'host': '',
    'location_name': 'Poland, Ocypel',
    'created_at': 'Erstellt: 29.11.2022 14:26:41 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['www.theicarianconvention.com'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'The Icarian Convention',
    'description': '',
    'start_date': '2023-06-21 00:00:00+00:00',
    'end_date': '2023-06-25 00:00:00+00:00',
    'main_image_url':
        'https://static.wixstatic.com/media/a4359c_712f22dd842c469ca95b51ca91a1bae1~mv2.png/v1/fill/w_632,h_544,al_c,lg_1,q_85,enc_auto/LOGO%20SOLO.png',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Barcelona, Spain',
    'created_at': 'Erstellt: 26.11.2022 10:57:30 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Airtime',
    'description': '',
    'start_date': '2023-06-23 00:00:00+00:00',
    'end_date': '2023-06-29 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Tom the acrobat',
    'location_name': 'Germany, Brunnenhaus',
    'created_at': 'Erstellt: 30.11.2022 06:38:54 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://docs.google.com/forms/d/e/1FAIpQLScxXbF8Ih_UVUzhOr5n9N4ArH2MBKfwRQc56oT_XmTZk1G27Q/viewform',
      'https://fb.me/e/3aaPwl3qd'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Midsummer Acroyoga Festival',
    'description': 'Tickets via Link',
    'start_date': '2023-06-23 00:00:00+00:00',
    'end_date': '2023-06-25 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name':
        'Stiftelsen Stjärnsund - Fridhem\nBruksallén 16, 77674 Stjärnsund, Sweden',
    'created_at': 'Erstellt: 20.12.2022 03:59:49 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Spanish Acro Convention',
    'description': '',
    'start_date': '2023-06-28 00:00:00+00:00',
    'end_date': '2023-07-02 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Barcelona',
    'created_at': 'Erstellt: 28.11.2022 03:59:25 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://www.nordicacro.com/'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Nordic Acroyoga Festival',
    'description': '',
    'start_date': '2023-06-29 00:00:00+00:00',
    'end_date': '2023-07-02 00:00:00+00:00',
    'main_image_url':
        'https://static.wixstatic.com/media/0fdef751204647a3bbd7eaa2827ed4f9.png/v1/fill/w_54,h_54,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/0fdef751204647a3bbd7eaa2827ed4f9.png',
    'event_type': 'Festivals und Cons',
    'host': 'Acrobhakty',
    'location_name': 'Mundekulla Retreatcenter\n\n361 95 Långasjö, Sweden',
    'created_at': 'Erstellt: 29.11.2022 14:36:35 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://facebook.com/events/s/french-acrobatics-convention-2/706004254055520/'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'French Acrobatic Convention',
    'description': 'https://frenchacro.wordpress.com',
    'start_date': '2023-07-03 00:00:00+00:00',
    'end_date': '2023-07-14 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Sainte-Eulalie-en-Born, Frankreich',
    'created_at': 'Erstellt: 03.01.2023 09:56:19 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://instagram.com/danishacroyogafestival?igshid=YmMyMTA2M2Y='
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Danish Acroyoga Summer Festival',
    'description': '',
    'start_date': '2023-07-10 00:00:00+00:00',
    'end_date': '2023-07-15 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': 'Iris and Emil',
    'location_name': '',
    'created_at': 'Erstellt: 06.12.2022 06:32:09 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Germankula Celebration',
    'description': '',
    'start_date': '2023-07-13 00:00:00+00:00',
    'end_date': '2023-07-16 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': '',
    'created_at': 'Erstellt: 26.10.2022 06:39:05 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acroyoga Vacation',
    'description': '',
    'start_date': '2023-07-13 00:00:00+00:00',
    'end_date': '2023-07-16 00:00:00+00:00',
    'event_type': 'Retreats',
    'host': 'Feel the flow',
    'location_name': 'Brunnenhaus',
    'created_at': 'Erstellt: 03.11.2022 09:26:48 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://docs.google.com/forms/d/e/1FAIpQLScTHZzby05sdmeNEnCmGtOLaOwP-yBcs3Okd-Xrj3D-dY4JHw/viewform'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Sicily Pre-Con',
    'description': '',
    'start_date': '2023-07-19 00:00:00+00:00',
    'end_date': '2023-07-22 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Sicily',
    'created_at': 'Erstellt: 24.11.2022 17:08:46 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'ACROMANIA Intro',
    'description': '',
    'start_date': '2023-07-19 00:00:00+00:00',
    'end_date': '2023-07-23 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Tom.the.acrobat',
    'location_name': 'Brunnenhaus, Wermelskirchen, Germany',
    'created_at': 'Erstellt: 28.11.2022 04:16:20 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acroatia',
    'description': '',
    'start_date': '2023-07-21 00:00:00+00:00',
    'end_date': '2023-08-11 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': '',
    'created_at': 'Erstellt: 01.11.2022 10:14:07 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://docs.google.com/forms/d/e/1FAIpQLScTHZzby05sdmeNEnCmGtOLaOwP-yBcs3Okd-Xrj3D-dY4JHw/viewform'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Sicily Acro Convention',
    'description': '',
    'start_date': '2023-07-22 00:00:00+00:00',
    'end_date': '2023-07-28 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': '',
    'created_at': 'Erstellt: 24.11.2022 17:06:47 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'ACROMANIA Intermediate',
    'description': '',
    'start_date': '2023-07-25 00:00:00+00:00',
    'end_date': '2023-07-30 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Tom.the.acrobat',
    'location_name': 'Brunnenhaus, Wermelskirchen, Germany',
    'created_at': 'Erstellt: 28.11.2022 04:18:57 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://docs.google.com/forms/d/e/1FAIpQLScTHZzby05sdmeNEnCmGtOLaOwP-yBcs3Okd-Xrj3D-dY4JHw/viewform'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Sicily Post-Con',
    'description': '',
    'start_date': '2023-07-30 00:00:00+00:00',
    'end_date': '2023-08-03 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Sicily',
    'created_at': 'Erstellt: 24.11.2022 17:07:42 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://forms.gle/sHUqwH2Nrm6GWkC48',
      'https://safeacrobatics.com/en/events/'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'SAFE Acrobatics Teacher Training',
    'description': '',
    'start_date': '2023-07-31 00:00:00+00:00',
    'end_date': '2023-08-27 00:00:00+00:00',
    'event_type': 'Training',
    'host': '',
    'location_name': 'Vinharje 10, Slovenia',
    'created_at': 'Erstellt: 26.11.2022 10:59:43 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'ACROMANIA Advanced',
    'description': '',
    'start_date': '2023-08-01 00:00:00+00:00',
    'end_date': '2023-08-06 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Tom.the.acrobat',
    'location_name': 'Brunnenhaus, Wermelskirchen, Germany',
    'created_at': 'Erstellt: 28.11.2022 04:17:41 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'The Acro Way Teacher Training',
    'description': '',
    'start_date': '2023-08-04 00:00:00+00:00',
    'end_date': '2023-08-04 00:00:00+00:00',
    'event_type': 'Training',
    'host': '',
    'location_name': 'Schweden, Stjärnsund',
    'created_at': 'Erstellt: 29.11.2022 14:30:50 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://acronia.de',
      'https://www.instagram.com/acronia_festival/'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acronia',
    'description': '',
    'start_date': '2023-08-11 00:00:00+00:00',
    'end_date': '2023-08-20 00:00:00+00:00',
    'main_image_url':
        'https://acronia.de/wp-content/uploads/2023/01/ACRONIA_Logo_white_240.png',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Auerstedt, close to Leipzig',
    'created_at': 'Erstellt: 26.11.2022 11:01:56 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://acrofalva.wordpress.com/hungarian-acro-convention/'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': '7th Hungarian Acro Convention',
    'description': '',
    'start_date': '2023-08-11 00:00:00+00:00',
    'end_date': '2023-08-18 00:00:00+00:00',
    'main_image_url':
        'https://acrofalva.files.wordpress.com/2017/07/logo-acrofalva.png?w=192',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': '',
    'created_at': 'Erstellt: 15.03.2023 13:56:14 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://www.tickettailor.com/events/tomtheacrobat/816671'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Summercamp',
    'description':
        'Eine Woche Spiel, Spaß und Acro pur und das Mitten in der Natur.',
    'start_date': '2023-08-21 00:00:00+00:00',
    'end_date': '2023-08-27 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': 'Jordis Troost',
    'location_name': 'Brunnenhaus',
    'created_at': 'Erstellt: 29.11.2022 14:12:00 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://www.3punkt.at/acroyoga-camps-2023'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acroyoga Base- & SpaceCamp',
    'description': '21.-25.08. BaseCamp und 25.-27.08 SpaceCamp',
    'start_date': '2023-08-21 00:00:00+00:00',
    'end_date': '2023-08-27 00:00:00+00:00',
    'main_image_url':
        'https://image.jimcdn.com/app/cms/image/transf/dimension=214x10000:format=png/path/s3d96b20481837467/image/if1a96211fab6e068/version/1617954237/image.png',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Dornbit/Ebnit (Österreich)',
    'created_at': 'Erstellt: 07.02.2023 03:39:47 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Akrobatik Weekend Thalexweiler',
    'description': '',
    'start_date': '2023-09-01 00:00:00+00:00',
    'end_date': '2023-09-03 00:00:00+00:00',
    'event_type': 'Training',
    'host': '',
    'location_name': 'Thalexweiler',
    'created_at': 'Erstellt: 29.11.2022 14:25:31 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'DAP',
    'description': 'Dynamic Acrobatics Programm',
    'start_date': '2023-09-02 00:00:00+00:00',
    'end_date': '2023-09-15 00:00:00+00:00',
    'event_type': 'Training',
    'host': '',
    'location_name': 'Belgium',
    'created_at': 'Erstellt: 29.11.2022 14:16:25 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Riviera Acro Festival',
    'description': '',
    'start_date': '2023-09-02 00:00:00+00:00',
    'end_date': '2023-09-09 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': 'Safe acrobatics',
    'location_name': 'Riviera, Italy',
    'created_at': 'Erstellt: 29.11.2022 14:23:46 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'London Acro Convention',
    'description': '',
    'start_date': '2023-09-08 00:00:00+00:00',
    'end_date': '2023-09-10 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'London',
    'created_at': 'Erstellt: 02.03.2023 10:32:21 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro Indian Summer France',
    'description': '',
    'start_date': '2023-09-10 00:00:00+00:00',
    'end_date': '2023-09-17 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'France, Saint julien de la Nef',
    'created_at': 'Erstellt: 29.11.2022 14:21:19 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://instagram.com/italian.acro.convention?igshid=YmMyMTA2M2Y='
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Italien Acro Convention',
    'description': 'More Info coming up',
    'start_date': '2023-09-14 00:00:00+00:00',
    'end_date': '2023-09-17 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': '',
    'created_at': 'Erstellt: 11.12.2022 01:25:19 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'SAFE Pre-con',
    'description': '',
    'start_date': '2023-09-18 00:00:00+00:00',
    'end_date': '2023-09-22 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': 'Safe acrobatics',
    'location_name': 'Slovenia',
    'created_at': 'Erstellt: 29.11.2022 14:24:18 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'SAFE Festival',
    'description': '',
    'start_date': '2023-09-22 00:00:00+00:00',
    'end_date': '2023-09-24 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': 'Safe acrobatics',
    'location_name': 'Slovenia',
    'created_at': 'Erstellt: 29.11.2022 14:24:44 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Airtime Acrobatics Programm',
    'description': 'Intensive',
    'start_date': '2023-10-02 00:00:00+00:00',
    'end_date': '2023-10-27 00:00:00+00:00',
    'event_type': 'Training',
    'host': 'Tom the acrobat',
    'location_name': 'Mannheim',
    'created_at': 'Erstellt: 30.11.2022 06:42:21 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['http://www.acrofest.eu'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Swiss AcroFest',
    'description': '',
    'start_date': '2023-10-05 00:00:00+00:00',
    'end_date': '2023-10-08 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Schönried, Switzerland',
    'created_at': 'Erstellt: 21.10.2022 01:03:41 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://acro-sense.de/'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Acro Sense Festival',
    'description': '',
    'start_date': '2023-10-06 00:00:00+00:00',
    'end_date': '2023-10-08 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name':
        'Jugendburg und Sportbildungsstätte Sensenstein, Nieste, Germany',
    'created_at': 'Erstellt: 26.11.2022 11:03:15 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://www.egyptacroconvention.com/?fbclid=PAAaYexRHERP8ZJPBNC3hCUS6KSSdxW6yQhQnaZAOLcyqKmGhzV1JU8w_Cr0w'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Egypt Acro Convention',
    'description': '',
    'start_date': '2023-10-22 00:00:00+00:00',
    'end_date': '2023-10-28 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Egypt',
    'created_at': 'Erstellt: 23.12.2022 11:05:41 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': ['https://www.akrobatik-wremen.de/'],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Akrobatik Wremen',
    'description':
        'Das weltweit zweite Treffen internationaler Akrobaten in Wremen anne Nordsee',
    'start_date': '2023-10-26 00:00:00+00:00',
    'end_date': '2023-10-29 00:00:00+00:00',
    'main_image_url':
        'https://www.akrobatik-wremen.de/rw_common/plugins/stacks/osm/images/marker-shadow.png',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Wremer Str. 99, 27639 Wurster Nordseeküste I Wremen',
    'created_at': 'Erstellt: 15.02.2023 06:12:47 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Timeout Autumn',
    'description': '',
    'start_date': '2023-11-02 00:00:00+00:00',
    'end_date': '2023-11-05 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Gemünd in der Eifel',
    'created_at': 'Erstellt: 29.11.2022 14:13:40 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'European Acro Festival (not annouced yet)',
    'description': '',
    'start_date': '2023-11-27 00:00:00+00:00',
    'end_date': '2023-12-04 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': 'Sunshine acrobatics',
    'location_name': 'Belgium, Erperheide',
    'created_at': 'Erstellt: 03.12.2022 09:41:16 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  },
  {
    'links': [
      'https://facebook.com/events/s/acrobatic-christmas-new-year-2/361766176167409/'
    ],
    'source': 'kalender.digital/9290ecc26f6f5a51ddc5',
    'is_highlight': false,
    'name': 'Akrobatic Christmas / New Year',
    'description': '',
    'start_date': '2023-12-24 00:00:00+00:00',
    'end_date': '2024-01-02 00:00:00+00:00',
    'event_type': 'Festivals und Cons',
    'host': '',
    'location_name': 'Wageningen',
    'created_at': 'Erstellt: 26.11.2022 11:04:13 von Acroyoga.kassel',
    'created_by': 'von Acroyoga.kassel'
  }
];
