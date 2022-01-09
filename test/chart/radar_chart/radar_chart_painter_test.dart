import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'radar_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('RadarChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final RadarChartData data = RadarChartData(dataSets: [
        RadarDataSet(),
      ]);

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);
      expect(radarChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(728, 728));
    });
  });

  group('drawTicks()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(_mockUtils);

      MockBuildContext _mockContext = MockBuildContext();

      List<Map<String, dynamic>> drawCircleResults = [];
      when(_mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawTicks(_mockContext, _mockCanvasWrapper, holder);

      expect(drawCircleResults.length, 3);

      // Background circle
      expect(drawCircleResults[0]['offset'], const Offset(200, 150));
      expect(drawCircleResults[0]['radius'], 120);
      expect(drawCircleResults[0]['paint_color'], MockData.color2);
      expect(drawCircleResults[0]['paint_style'], PaintingStyle.fill);

      // Border circle
      expect(drawCircleResults[1]['offset'], const Offset(200, 150));
      expect(drawCircleResults[1]['radius'], 120);
      expect(drawCircleResults[1]['paint_color'], MockData.color6);
      expect(drawCircleResults[1]['paint_stroke'], 33);
      expect(drawCircleResults[1]['paint_style'], PaintingStyle.stroke);

      // First Tick
      expect(drawCircleResults[2]['offset'], const Offset(200, 150));
      expect(drawCircleResults[2]['radius'], 60);
      expect(drawCircleResults[2]['paint_color'], MockData.color5);
      expect(drawCircleResults[2]['paint_stroke'], 55);
      expect(drawCircleResults[2]['paint_style'], PaintingStyle.stroke);

      final result =
          verify(_mockCanvasWrapper.drawText(captureAny, captureAny));
      expect(result.callCount, 1);
      final tp = result.captured[0] as TextPainter;
      expect((tp.text as TextSpan).text, '1.0');
      expect((tp.text as TextSpan).style, MockData.textStyle1);
      expect(result.captured[1] as Offset, const Offset(205, 76));
    });
  });

  group('drawGrids()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(_mockUtils);

      List<Map<String, dynamic>> drawLineResults = [];
      when(_mockCanvasWrapper.drawLine(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawLineResults.add({
          'offset_from': inv.positionalArguments[0] as Offset,
          'offset_to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawGrids(_mockCanvasWrapper, holder);
      expect(drawLineResults.length, 3);

      expect(drawLineResults[0]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[0]['offset_to'], const Offset(200, 30));
      expect(drawLineResults[0]['paint_color'], MockData.color3);
      expect(drawLineResults[0]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[0]['paint_stroke'], 3);

      expect(drawLineResults[1]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[1]['offset_to'],
          const Offset(303.92304845413264, 209.99999999999997));
      expect(drawLineResults[1]['paint_color'], MockData.color3);
      expect(drawLineResults[1]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[1]['paint_stroke'], 3);

      expect(drawLineResults[2]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[2]['offset_to'],
          const Offset(96.07695154586739, 210.00000000000006));
      expect(drawLineResults[2]['paint_color'], MockData.color3);
      expect(drawLineResults[2]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[2]['paint_stroke'], 3);
    });
  });
}
