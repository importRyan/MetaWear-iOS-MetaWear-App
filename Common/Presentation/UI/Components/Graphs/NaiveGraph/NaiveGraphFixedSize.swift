//  Created by Ryan Ferrell on 8/8/21.
//  Copyright © 2021 MbientLab. All rights reserved.
//

import SwiftUI

// MARK: - iOS 14- version

struct NaiveGraphFixedSize: View {

    @StateObject var controller: NaiveGraphController

    let width: CGFloat
    let height: CGFloat = .detailsGraphHeight

    var body: some View {
        ZStack(alignment: .leading) {
            graph
        }
        .offset(x: -width/2)
        .frame(width: width, height: height)
        .drawingGroup(opaque: true, colorMode: .nonLinear)
        .animation(.none)
        .animation(nil)
        .background(Labels(min: controller.yMin, max: controller.yMax))
        .frame(width: width, height: height)
        .accessibility(value: Text(makeAccessibilityValue()))
        .padding(.vertical, 8)
    }

    var graph: some View {
        ForEach(controller.displayedPoints) { timepoint in
            ForEach(timepoint.heights.indices) { seriesIndex in
                Dot(color: controller.seriesColors[seriesIndex])
                    .offset(y: timepoint.heights[seriesIndex] / controller.rangeY * -height)
            }
            .offset(x: timepoint.x / controller.displayablePointCount * width)
        }
    }

    func makeAccessibilityValue() -> String {
        let point = controller.displayedPoints.last ?? .init(x: 0, heights: [0])
        return zip(point.heights, controller.seriesNames).map {
            "\($1) \(String(format: "%1.1f", $0))"
        }.joined(separator: ", ")
    }

    struct Dot: View {

        let color: Color

        var body: some View {
            Circle()
                .fill(color)
                .frame(width: 3, height: 3)
        }
    }

    struct Labels: View {

        @ScaledMetric(relativeTo: .caption) private var fontSize = MWVerySmall.fontSize
        let min: Double
        let max: Double

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Divider().foregroundColor(.secondary)
                Spacer()
                Divider()
                Spacer()

                Divider().foregroundColor(.secondary)

                Divider()
                Spacer()
                Divider()
                Spacer()
                Divider().foregroundColor(.secondary)
            }
            .overlay(text)
        }

        var text: some View {
            VStack(alignment: .leading, spacing: 0) {
                TextLabel(value: max).offset(y: -fontSize / 2)
                Spacer()
                TextLabel(value: min).offset(y: fontSize / 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        struct TextLabel: View {

            var value: Double

            var body: some View {
                Text(String(format: "%1.f", value))
                    .padding(.trailing, 5)
                    .background(Color.blockPlatterFill)
                    .foregroundColor(.secondary)
                    .fontVerySmall()
            }
        }
    }
}

// MARK: - iOS 15+ Canvas Version

#if swift(>=5.5)
@available(iOS 15.0, *)
@available(macOS 12.0, *)
struct CanvasGraph: View {

    @StateObject var controller: NaiveGraphController

    let width: CGFloat
    let height: CGFloat = .detailsGraphHeight
    let pointSize = CGSize(width: 3, height: 3)

    var body: some View {
        ZStack(alignment: .topLeading) {
            graph
                .frame(width: width, height: height)
        }
        .background(NaiveGraphFixedSize.Labels(min: controller.yMin, max: controller.yMax))
        .accessibility(value: Text(makeAccessibilityValue()))
        .accessibilityAddTraits(.updatesFrequently)
    }

    var graph: some View {
        Canvas(opaque: true, colorMode: .nonLinear, rendersAsynchronously: true) { context, size in

            controller.displayedPoints.forEach { timepoint in
                timepoint.heights.indices.forEach { seriesIndex in

                    let x = timepoint.x / controller.displayablePointCount * width
                    let y = (timepoint.heights[seriesIndex] / controller.rangeY * height) + (height / 2) - 1.5

                    let path = makePoint(x: x, y: y)
                    context.fill(path, with: .color(controller.seriesColors[seriesIndex]))
                }
            }

        }
    }

    func makePoint(x: CGFloat, y: CGFloat) -> Path {
        Path(ellipseIn: .init(origin: CGPoint(x: x, y: y),
                              size: pointSize))
    }

    func makeAccessibilityValue() -> String {
        let point = controller.displayedPoints.last ?? .init(x: 0, heights: [0])
        return zip(point.heights, controller.seriesNames).map {
            "\($1) \(String(format: "%1.1f", $0))"
        }.joined(separator: ", ")
    }
}
#endif
