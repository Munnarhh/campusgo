import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:campusgo/features/home/presentation/pages/home2.dart';
import 'package:campusgo/features/home/presentation/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/constants.dart';

class SelectDatePage extends StatefulWidget {
  static String routeName = 'SelectDatePage';
  const SelectDatePage({super.key});

  @override
  State<SelectDatePage> createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_selectedDate.year, 1, 1);
    final lastDay = DateTime(_selectedDate.year, 12, 31);
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 3,
        backgroundColor: const Color(kBackgroundColor),
        centerTitle: true,
        title: Text(
          'Book Date',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.black,
                fontSize: 22.sp,
              ),
        ),
        actions: [SvgPicture.asset(kCalendar)],
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDate,
            firstDay: firstDay,
            lastDay: lastDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDate = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black),
              weekendTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black),
              selectedDecoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(kPrimaryColor),
              ),
              selectedTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp),
              todayDecoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              todayTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
              markersAlignment: Alignment.bottomCenter,
              outsideTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: kWeekStyle),
            ),
            daysOfWeekHeight: 50,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: kWeekStyle, fontSize: 14.sp),
              weekendStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: kWeekStyle, fontSize: 14.sp),
            ),
            headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black, fontSize: 33.5.sp),
                formatButtonVisible: false,
                headerPadding: EdgeInsets.symmetric(vertical: 16.h),
                leftChevronVisible: true),
            availableGestures: AvailableGestures.horizontalSwipe,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: PrimaryButton(
                text: 'Select Date',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(
                        'Confirm Date',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black, fontSize: 20.sp),
                      ),
                      content: Text(
                        'Date: ${_formatSelectedDate()}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                      actions: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  kPrimaryColor2)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            const ProgressDialog(message: 'Setting up trip');
                            Future.delayed(Duration(milliseconds: 5), () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, Homee.routeName);
                            });
                          },
                          child: Text(
                            'Proceed',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  String _formatSelectedDate() {
    final day = _selectedDate.day;
    final suffix = _getDaySuffix(day);
    final month = DateFormat('MMMM').format(_selectedDate);
    final year = _selectedDate.year;
    return '$day$suffix $month $year';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
