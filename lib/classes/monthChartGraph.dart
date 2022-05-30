import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart' as element;

import 'myMonthData.dart';
import '../database/entities/mydata.dart';

class MonthChartGraph extends StatelessWidget{
  final List<myMonthData> data;
  final int month;
  final String category;

  MonthChartGraph({required this.data, required this.month, required this.category});

  @override 
  static List selectedDatum = [];
  Widget build(BuildContext context){
    List<Series<myMonthData, String>> series = [
      Series(
        id: category,
        data: data,
        domainFn: (myMonthData series, _) => series.day,
        measureFn: (myMonthData series,_) => series.value,
        colorFn: (myMonthData series,_) => series.barColor,
      )
    ];

    return Container(
      height: 290,
      padding: EdgeInsets.all(25),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(children: <Widget>[
            Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        category,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.directions_walk)
                    ],
                  ),
                  color: Colors.green),
            Expanded(
              child: BarChart(series,
              animate: true,
              domainAxis: const OrdinalAxisSpec(
                    tickProviderSpec: StaticOrdinalTickProviderSpec(
                    [
                      TickSpec('5'),
                      TickSpec('10'),
                      TickSpec('15'),
                      TickSpec('20'),
                      TickSpec('25'),
                      
                    ]
              )),
              behaviors: [
                  SelectNearest(eventTrigger: SelectionTrigger.tapAndDrag),
                  LinePointHighlighter(
                    symbolRenderer: CustomCircleSymbolRenderer2(),
                  )
                ],
                selectionModels: [
                  SelectionModelConfig(changedListener: (SelectionModel model) {
                    if (model.hasDatumSelection) {
                      selectedDatum = [];
                      model.selectedDatum.forEach((SeriesDatum datumPair) {
                        selectedDatum.add({
                          'color': datumPair.series.colorFn!(0),
                          'text': '${datumPair.datum.value}'
                        });
                      });
                      print(selectedDatum);
                    } else {
                      selectedDatum = [];
                    }
                  })
                ],),
              )
          ],)
        )
      )
    );
  }
}

class MonthMinChartGraph extends StatelessWidget {
  final List<myMonthData> data1;
  final List<myMonthData> data2;
  final String category1;
  final String category2;

  MonthMinChartGraph(
      {required this.data1,
      required this.data2,
      required this.category1,
      required this.category2});
  @override
  static List selectedDatum = [];
  Widget build(BuildContext context) {
    List<Series<myMonthData, String>> series = [
      Series(
        id: category1,
        data: data1,
        domainFn: (myMonthData series, _) => series.day,
        measureFn: (myMonthData series, _) => series.value,
        colorFn: (myMonthData series, _) => series.barColor,
      ),
      Series(
        id: category2,
        data: data2,
        domainFn: (myMonthData series, _) => series.day,
        measureFn: (myMonthData series, _) => series.value,
        colorFn: (myMonthData series, _) => series.barColor,
      )
    ];

    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        'Minutes of activity',
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.directions_walk)
                    ],
                  ),
                  color: Colors.green),
              Expanded(
                  child: BarChart(
                series,
                barGroupingType: BarGroupingType.stacked,
                animate: true,
                domainAxis: const OrdinalAxisSpec(
                    tickProviderSpec: StaticOrdinalTickProviderSpec(
                    [
                      TickSpec('5'),
                      TickSpec('10'),
                      TickSpec('15'),
                      TickSpec('20'),
                      TickSpec('25'),
                      
                    ]
              )),
                behaviors: [
                  SeriesLegend(
                    // Positions for "start" and "end" will be left and right respectively
                    // for widgets with a build context that has directionality ltr.
                    // For rtl, "start" and "end" will be right and left respectively.
                    // Since this example has directionality of ltr, the legend is
                    // positioned on the right side of the chart.
                    position: BehaviorPosition.bottom,
                    // For a legend that is positioned on the left or right of the chart,
                    // setting the justification for [endDrawArea] is aligned to the
                    // bottom of the chart draw area.
                    outsideJustification: OutsideJustification.endDrawArea,
                    // By default, if the position of the chart is on the left or right of
                    // the chart, [horizontalFirst] is set to false. This means that the
                    // legend entries will grow as new rows first instead of a new column.
                    horizontalFirst: false,
                    // By setting this value to 2, the legend entries will grow up to two
                    // rows before adding a new column.
                    desiredMaxRows: 2,
                    // This defines the padding around each legend entry.
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    // Render the legend entry text with custom styles.
                    entryTextStyle: TextStyleSpec(
                        color: Color(r: 127, g: 63, b: 191),
                        fontFamily: 'Georgia',
                        fontSize: 11),
                  ),
                  SelectNearest(eventTrigger: SelectionTrigger.tapAndDrag),
                  LinePointHighlighter(
                    symbolRenderer: CustomCircleSymbolRenderer(),
                  )
                ],
                selectionModels: [
                  SelectionModelConfig(changedListener: (SelectionModel model) {
                    if (model.hasDatumSelection) {
                      selectedDatum = [];
                      model.selectedDatum.forEach((SeriesDatum datumPair) {
                        selectedDatum.add({
                          'color': datumPair.series.colorFn!(0),
                          'text': '${datumPair.datum.value}'
                        });
                      });
                      print(selectedDatum);
                    } else {
                      selectedDatum = [];
                    }
                  })
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  CustomCircleSymbolRenderer(
      {this.marginBottom = 8, this.padding = const EdgeInsets.all(8)});

  final double marginBottom;
  final EdgeInsets padding;

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    style.TextStyle textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;

    List tooltips = MonthMinChartGraph.selectedDatum;
    // String unit = _DashboardState.unit;
    if (tooltips != null && tooltips.length > 0) {
      num tipTextLen = (tooltips[0]['text']).length;
      num rectWidth = bounds.width + tipTextLen * 12;
      num rectHeight = bounds.height + 20 + (tooltips.length - 1) * 18;
      num left = bounds.left - rectWidth;

      canvas.drawRect(
        Rectangle(left, 0, rectWidth, rectHeight),
        fill: Color.fromHex(code: '#666666'),
      );

      for (int i = 0; i < tooltips.length; i++) {
        canvas.drawPoint(
          point: Point(left.round() + 8, (i + 1) * 15),
          radius: 3,
          fill: tooltips[i]['color'],
          stroke: Color.white,
          strokeWidthPx: 1,
        );
        style.TextStyle textStyle = style.TextStyle();
        textStyle.color = Color.white;
        textStyle.fontSize = 13;
        canvas.drawText(element.TextElement(tooltips[i]['text']),
            left.round() + 15, i * 15 + 8);
      }
    }
  }
}

class CustomCircleSymbolRenderer2 extends CircleSymbolRenderer {
  CustomCircleSymbolRenderer2(
      {this.marginBottom = 8, this.padding = const EdgeInsets.all(8)});

  final double marginBottom;
  final EdgeInsets padding;

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    style.TextStyle textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;

    List tooltips = MonthChartGraph.selectedDatum;
    // String unit = _DashboardState.unit;
    if (tooltips != null && tooltips.length > 0) {
      num tipTextLen = (tooltips[0]['text']).length;
      num rectWidth = bounds.width + tipTextLen * 12;
      num rectHeight = bounds.height + 20 + (tooltips.length - 1) * 18;
      num left = bounds.left - rectWidth;

      canvas.drawRect(
        Rectangle(left, 0, rectWidth, rectHeight),
        fill: Color.fromHex(code: '#666666'),
      );

      for (int i = 0; i < tooltips.length; i++) {
        canvas.drawPoint(
          point: Point(left.round() + 8, (i + 1) * 15),
          radius: 3,
          fill: tooltips[i]['color'],
          stroke: Color.white,
          strokeWidthPx: 1,
        );
        style.TextStyle textStyle = style.TextStyle();
        textStyle.color = Color.white;
        textStyle.fontSize = 13;
        canvas.drawText(element.TextElement(tooltips[i]['text']),
            left.round() + 15, i * 15 + 8);
      }
    }
  }
}
