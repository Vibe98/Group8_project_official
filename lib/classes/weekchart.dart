import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart' as element;


class WeekStepChart{
  
  WeekStepChart(this.x, this.indexe, this.y, this.barColor);
  final DateTime? x;
  final int indexe;
  final double? y;
  final Color barColor;
}

class WeekStepChartGraph extends StatelessWidget {
  final List<WeekStepChart> data;
  final String category;

  WeekStepChartGraph({required this.data, required this.category});
  @override
  Widget build(BuildContext context) {
    List<Series<WeekStepChart, String>> series = [
      Series(
        id: category,
        data: data,
        domainFn: (WeekStepChart series, _) => '${series.x!.day.toString()}/${series.x!.month.toString()}',
        measureFn: (WeekStepChart series, _) => series.y,
        colorFn: (WeekStepChart series, _) => series.barColor,
        
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
              Text(
                category,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                child: BarChart(series, 
                
              animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WeekMinChartGraph extends StatelessWidget {
  final List<WeekStepChart> data1;
  final List<WeekStepChart> data2;
  final String category1;
  final String category2;

  WeekMinChartGraph({required this.data1, required this.data2, required this.category1, required this.category2});
  @override
  Widget build(BuildContext context) {
    List<Series<WeekStepChart, String>> series = [
      Series(
        id: category1,
        data: data1,
        domainFn: (WeekStepChart series, _) => '${series.x!.day.toString()}/${series.x!.month.toString()}',
        measureFn: (WeekStepChart series, _) => series.y,
        colorFn: (WeekStepChart series, _) => series.barColor,
        
      ),
      Series(
        id: category2,
        data: data2,
        domainFn: (WeekStepChart series, _) => '${series.x!.day.toString()}/${series.x!.month.toString()}',
        measureFn: (WeekStepChart series, _) => series.y,
        colorFn: (WeekStepChart series, _) => series.barColor,
        
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
              Text(
                'Minutes of activity',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                child: BarChart(series, 
                barGroupingType: BarGroupingType.stacked,
              animate: true,
              behaviors: [
        SeriesLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: BehaviorPosition.end,
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
        
      ],
      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int>? dashPattern, Color? fillColor, FillPatternType? fillPattern, Color? strokeColor, double? strokeWidthPx})  {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
      Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10, bounds.height + 10),
      fill: Color.white
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText( element.TextElement('1'),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }
}