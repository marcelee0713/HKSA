import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/scholarWidgets/chart/chart_v00.dart';
import 'package:hksa/widgets/scholarWidgets/chart/logs.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: ColorPalette.secondary,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ScholarHoursRadialChart(),
              const SizedBox(height: 5),
              const LogsListView(),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        "This is where your DTR logs are recorded that can be also printed and your total hours.",
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
