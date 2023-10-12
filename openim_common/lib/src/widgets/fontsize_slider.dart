import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FontSizeSlider extends StatelessWidget {
  const FontSizeSlider({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);
  final double value;
  final Function(dynamic value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.c_FFFFFF,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: Column(
        children: [
          _buildIndicatorLabel(),
          SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 1,
              inactiveTrackHeight: 1,
              activeTrackColor: Styles.c_8E9AB0_opacity30,
              inactiveTrackColor: Styles.c_8E9AB0_opacity30,
              activeTickColor: Styles.c_8E9AB0_opacity30,
              inactiveTickColor: Styles.c_8E9AB0_opacity30,
              activeMinorTickColor: Styles.c_8E9AB0_opacity30,
              inactiveMinorTickColor: Styles.c_8E9AB0_opacity30,
              thumbColor: Styles.c_FFFFFF,
              tickOffset: Offset(0, -10.h),
            ),
            child: SfSlider(
              min: 0,
              max: 2,
              value: value,
              interval: 1,
              showTicks: true,
              showLabels: false,
              labelFormatterCallback: (actualValue, formattedText) {
                return '打';
              },
              minorTicksPerInterval: 1,
              labelPlacement: LabelPlacement.onTicks,
              edgeLabelPlacement: EdgeLabelPlacement.inside,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorLabel() => Stack(
        children: [
          StrRes.little.toText
            ..style = Styles.ts_0C1C33_12sp
            ..onTap = () => onChanged?.call(.0),
          Align(
            alignment: Alignment.center,
            child: StrRes.standard.toText
              ..style = Styles.ts_0C1C33_17sp
              ..onTap = () => onChanged?.call(1.0),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: StrRes.big.toText
              ..style = Styles.ts_0C1C33_20sp
              ..onTap = () => onChanged?.call(2.0),
          ),
        ],
      );
}
