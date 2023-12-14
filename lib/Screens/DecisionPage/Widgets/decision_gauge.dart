import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../Model/decision.dart';
import '../../../Providers/settings_provider.dart';

class DecisionGauge extends StatefulWidget {
  const DecisionGauge({
    Key? key,
    required this.decision,
  }) : super(key: key);

  final Decision decision;

  @override
  State<DecisionGauge> createState() => _DecisionGaugeState();
}

class _DecisionGaugeState extends State<DecisionGauge> {
  double? negativeScore;
  double? positiveScore;
  double? neutralScore;

  Widget _buildGauge(double score, double negativeScore, double positiveScore) {
    double oldRange = positiveScore - negativeScore;
    double newValue =
        (score == 0) ? 50 : (score - negativeScore) * 100 / oldRange;
    return SfRadialGauge(axes: [
      RadialAxis(minimum: 0, maximum: 100, ranges: [
        GaugeRange(startValue: 0, endValue: 50, color: Colors.red),
        GaugeRange(startValue: 50, endValue: 66.666, color: Colors.orange),
        GaugeRange(startValue: 66.666, endValue: 100, color: Colors.green),
      ], pointers: [
        NeedlePointer(
          value: newValue,
        ),
      ])
    ], enableLoadingAnimation: true);
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    double? negativeScore = widget.decision.negativeScore;
    double? weightedNegativeScore = widget.decision.weightedNegativeScore;
    double? positiveScore = widget.decision.positiveScore;
    double? neutralScore = widget.decision.score;
    if (settings.isShowingSums) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
              color: Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(5000)),
            ),
            child: Text((negativeScore!).toString()),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildGauge(neutralScore!, negativeScore, positiveScore!),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
              ),
              color: Colors.green,
              borderRadius: const BorderRadius.all(Radius.circular(5000)),
            ),
            child: Text(positiveScore.toString()),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: _buildGauge(neutralScore!, negativeScore!, positiveScore!),
      );
    }
  }
}
