// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/ui/utils/day_change_notifire.dart';
import 'package:mashtoz_flutter/ui/utils/utils_date.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TableComplexExample extends StatefulWidget {
  final int day;

  const TableComplexExample({Key? key, this.day = 0 }) : super(key: key);
  @override
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class _TableComplexExampleState extends State<TableComplexExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  final bookDataProvider = BookDataProvider();

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.enforced;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? formattedDate;
  @override
  void initState() {
    super.initState();
    if(widget.day>0){

     _selectedDays.add(context.read<FocuseDay>().myDate);
    }
    // _selectedDays.add(_focusedDay.value);


    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();

    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime>? days) {
    return [
      for (final d in days!) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
 var day = DateTime.now();
      setState(() {

          if(focusedDay.isBefore(day)){

            if (_selectedDays.contains(selectedDay)) {
            _selectedDays.remove(selectedDay);
            Navigator.of(context).pop();
          } else {
            _selectedDays.add(selectedDay);
            Navigator.of(context).pop();
          }
            _focusedDay.value = focusedDay;
            var now = new DateTime(_focusedDay.value.year, _focusedDay.value.month,
                _focusedDay.value.day);
            ;
            // var formatter = new DateFormat('yyyy-MM-dd');
            var formatter = "${now.year}-${now.month}-${now.day}";
            print("Im hereeeeeee date $formatter");
            formattedDate = formatter;

            context.read<FocuseDay>().setWordsDate(formattedDate);

            context.read<FocuseDay>().setDays(_focusedDay.value.day.toInt(),focusedDay);
            _focusedDay.value = focusedDay;
            // HomePageState.wordsOfDayFuture =
            //     context.read<FocuseDay>().getDataByDate();

            _rangeStart = null;

            _rangeEnd = null;

            _rangeSelectionMode = RangeSelectionMode.toggledOff;            _selectedEvents.value = _getEventsForDays(_selectedDays);
          }
          _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });





  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().day);
    return Material(
      child: TableCalendar<Event>(
          locale: 'hy_AM',
          firstDay: kFirstDay,
          lastDay: kLastDay,
          availableGestures:AvailableGestures.none ,
          focusedDay: _focusedDay.value,
          selectedDayPredicate: (day) =>   _selectedDays.contains(day),
          rangeStartDay: _rangeStart,
          rangeEndDay: DateTime.now(),
          rangeSelectionMode: _rangeSelectionMode,
          daysOfWeekVisible: false,
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
          headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextFormatter: (date, _locale) =>
                  DateFormat.yMMMMd(_locale).format(date),
              leftChevronMargin: EdgeInsets.only(left: 50.0),
              rightChevronMargin: EdgeInsets.only(right: 50.0)),
          calendarStyle: const CalendarStyle(

            disabledDecoration: BoxDecoration(color: Palette.whenTapedButton),
            markerDecoration: BoxDecoration(color: Palette.whenTapedButton),
            selectedDecoration: BoxDecoration(color: Palette.whenTapedButton),
            todayDecoration: BoxDecoration(color: Palette.disable),
          )),
    );
  }
}
