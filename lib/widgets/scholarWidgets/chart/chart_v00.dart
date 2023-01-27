import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  //put scholar hours here
  double renderedHours = 69;
  double requiredHours = 90;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.secondary,
      child: Column(
        children: [
          const SizedBox(height: 25,),
          Center(
            child: SfRadialGauge(
                axes:<RadialAxis>[RadialAxis(
                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.1,
                      thicknessUnit: GaugeSizeUnit.factor,
                      color: Color(0xffa38b00),
                    ),
                    minimum: 0, maximum: requiredHours,
                    interval: 10,
                    radiusFactor: 0.85,
                    startAngle: 114, endAngle: 67,
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        positionFactor: 1, angle: 90,
                          widget: Column(children: <Widget>[
                            Text(
                              renderedHours.toString(),
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 32,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              requiredHours.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 65),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StarBorder.polygon(
                                  sides: 5,
                                  rotation: 180,
                                  squash: 0.20,
                                  pointRounding: 0.15,
                                ),
                                padding: const EdgeInsets.fromLTRB(110, 20, 110, 20),
                                elevation: 5,
                              ),
                                onPressed: () {  },
                                child: const Text(
                                    'Print',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontFamily: 'Frank Ruhl Libre',
                                      letterSpacing: 3,
                                    ),
                                ),
                            ),
                      ],))
                    ],
                    pointers: <GaugePointer>[RangePointer(
                      enableAnimation: true,
                      value: renderedHours, width: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      gradient: const SweepGradient(
                          colors: <Color>[Color(0xffffd700), Color(0xffffe23d)],
                          stops: <double>[0.3, 0.9]),
                    )],
                ),
            ]),
          ),
          const SizedBox(height: 10),
          const Text('Hello'),
        ],
      ),
    );
  }
}