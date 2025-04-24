import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  final String title;
  final bool showTitle;
  final bool showLabels;
  final List<String> labels;
  final List<num> values;
  final List<Color> colors;
  final double size;
  final double pieChartShowPercentageSliceSizeCutoff;
  final TextAlign titleTextAlign;
  final double textSizeRatio;

  const PieChartWidget({
    super.key,
    required this.title,
    required this.labels,
    required this.values,
    required this.colors,
    this.showTitle = true,
    this.showLabels = true,
    this.size = 200,
    this.pieChartShowPercentageSliceSizeCutoff = 0.1,
    this.titleTextAlign = TextAlign.center,
    this.textSizeRatio = 0.10,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.labels.length != widget.colors.length) {
      throw Exception(
          "Pie chart '${widget.title}' observed a length mismatch between the number of labels, values, and colors supplied.\n"
          "Number of labels: ${widget.labels.length}\n"
          "Number of values: ${widget.values.length}\n"
          "Number of colors: ${widget.colors.length}");
    }

    final labels = widget.labels;
    final values = widget.values;
    final colors = widget.colors;
    final num chartSliceCutoff = values.reduce((a, b) => a + b) *
        widget.pieChartShowPercentageSliceSizeCutoff;
    final bool isAllZero = values.every((v) => v == 0);
    final bool isEmpty = values.isEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.size,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showTitle)
                    SizedBox(
                      width: widget.size,
                      height: widget.size * 0.4,
                      child: Center(
                        child: Text(
                          widget.title,
                          textAlign: widget.titleTextAlign,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.textSizeRatio * widget.size,
                          ),
                        ),
                      ),
                    ),
                  if (isEmpty || isAllZero)
                    SizedBox(
                      width: widget.size,
                      height: widget.size * 1.3,
                      child: Center(
                        child: Text(
                          "N/A",
                          style: TextStyle(
                            fontSize: widget.size * 0.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: widget.size,
                      height: widget.size * 1.3,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response?.touchedSection == null) {
                                  touchedIndex = -1;
                                } else {
                                  touchedIndex = response!
                                      .touchedSection!.touchedSectionIndex;
                                }
                              });
                            },
                          ),
                          sections: showingSections(
                              labels, values, colors, chartSliceCutoff),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: widget.size * 0.15,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.showLabels) ...[
              SizedBox(width: widget.size * 0.4),
              SizedBox(
                width: 170,
                height: widget.size * 1.3,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: labels.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Indicator(
                          color: colors[index],
                          text: labels[index],
                          isSquare: true,
                          size: widget.size,
                          colorBoxSizeRatio: 0.07,
                          textSizeRatio: widget.textSizeRatio,
                          scrollController: null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(List<String> labels,
      List<num> values, List<Color> colors, num chartSliceCutoff) {
    return List.generate(values.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? widget.size * 0.099 : widget.size * 0.09;
      final radius = isTouched ? widget.size * 0.33 : widget.size * 0.3;
      return PieChartSectionData(
        color: colors[index],
        value: values[index].toDouble(),
        title: "${values[index]}",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color:
              (values[index] >= chartSliceCutoff) ? Colors.white : Colors.black,
        ),
        showTitle: (values[index] >= chartSliceCutoff)
            ? true
            : (index == touchedIndex),
        titlePositionPercentageOffset:
            (values[index] >= chartSliceCutoff) ? 0.5 : 1.4,
      );
    });
  }
}

class Indicator extends StatefulWidget {
  final Color color;
  final String text;
  final double size;
  final bool isSquare;
  final double colorBoxSizeRatio;
  final double textSizeRatio;
  final ScrollController? scrollController;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = false,
    required this.size,
    required this.colorBoxSizeRatio,
    required this.textSizeRatio,
    this.scrollController,
  });

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  late final ScrollController _controller;
  Timer? _hoverScrollTimer;
  bool _usingExternalController = false;

  @override
  void initState() {
    super.initState();
    _usingExternalController = widget.scrollController != null;
    _controller = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    _hoverScrollTimer?.cancel();
    if (!_usingExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _startScroll() {
    _hoverScrollTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (_controller.hasClients) {
        final max = _controller.position.maxScrollExtent;
        final current = _controller.offset;
        final next = (current + 1).clamp(0, max);
        _controller.jumpTo((next >= max ? 0 : next).toDouble());
      }
    });
  }

  void _stopScroll() {
    _hoverScrollTimer?.cancel();
    _hoverScrollTimer = null;
    if (_controller.hasClients) {
      _controller.jumpTo(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: widget.size * widget.colorBoxSizeRatio,
          height: widget.size * widget.colorBoxSizeRatio,
          decoration: BoxDecoration(
            shape: widget.isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: widget.color,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: MouseRegion(
            onEnter: (_) => _startScroll(),
            onExit: (_) => _stopScroll(),
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.size * widget.textSizeRatio,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
