//
//  BarChart.swift
//
//
//  Created by Moritz Scholz on 09.01.22.
//

import SwiftUI

/// Draws a horizontal bar chart
///
public struct BarChart<Items, ElementLabel, ElementFill>: View
where Items: RandomAccessCollection, Items.Element: Identifiable, ElementLabel: View, ElementFill: ShapeStyle {
    public let items: Items
    public let style: ChartStyle
    public let fill: ChartElementShapeStyle<Items.Element, ElementFill>
    public let label: (Items.Element) -> ElementLabel
    public let data: (Items.Element) -> Double
    public let dataLabel: ((Items.Element) -> String)?

    public init(items: Items,
                style: ChartStyle = .defaultStyle,
                fill: ChartElementShapeStyle<Items.Element, ElementFill>,
                label: @escaping (Items.Element) -> ElementLabel,
                data: @escaping (Items.Element) -> Double,
                dataLabel: ((Items.Element) -> String)? = nil) {
        self.items = items
        self.style = style
        self.fill = fill
        self.label = label
        self.data = data
        self.dataLabel = dataLabel
    }

    public init(items: Items,
                fillStyle: ElementFill,
                label: @escaping (Items.Element) -> ElementLabel,
                data: @escaping (Items.Element) -> Double) {
        self.init(items: items, fill: .uniform(fillStyle), label: label, data: data)
    }

    @State private var totalViewWidth: CGFloat = .zero
    @State private var maxLabelWidth: CGFloat = .zero
    @State private var maxDataLabelWidth: CGFloat = .zero

    @State private var isVisible: Bool = false

    public var body: some View {
        ZStack {
            Color.clear.frame(height: 1)
                .readSize { totalViewWidth = $0.width }

            VStack(alignment: .leading, spacing: style.verticalSpacing) {
                ForEach(items) { item in
                    HStack(spacing: style.horizontalSpacing) {
                        label(item)
                            .fixedSize()
                            .readSize { maxLabelWidth = max(maxLabelWidth, $0.width) }
                            .frame(width: maxLabelWidth, alignment: style.labelAlignment)

                        Bar(width: barWidth(value: data(item), maxValue: maxValue,
                            availableWidth: availableBarWidth),
                            fill: elementFill(item: item))
                            .frame(height: style.barThickness)
                            .scaleEffect(x: isVisible ? 1 : 0, anchor: .leading)

                        if let dataLabel = dataLabel {
                            Text(dataLabel(item))
                                .font(style.dataLabelFont)
                                .foregroundColor(style.dataLabelColor)
                                .lineLimit(1)
                                .fixedSize()
                                .readSize { maxDataLabelWidth = max(maxDataLabelWidth, $0.width) }
                                .opacity(isVisible ? 1.0 : 0.0)
                        }

                        Spacer(minLength: 1.0)
                    }
                }
            }
        }
        .onAppear {
            if style.shouldAnimateOnAppearance {
                withAnimation(.spring(dampingFraction: 0.5)) {
                    isVisible = true
                }
            } else {
                isVisible = true
            }
        }
    }

    func barWidth(value: Double, maxValue: Double, availableWidth: CGFloat) -> CGFloat {
        guard value > 0, maxValue > 0, availableWidth > 0 else { return 0 }

        return availableWidth / CGFloat(maxValue) * CGFloat(value)
    }

    // TODO: Move this out to protocol extension
    func elementFill(item: Items.Element) -> ElementFill {
        switch fill {
        case .uniform(let style):
            return style
        case .provided(by: let styleProvider):
            return styleProvider(item)
        }
    }

    var availableBarWidth: CGFloat {
        totalViewWidth
        // For bar labels
        - maxLabelWidth - style.horizontalSpacing
        // For Spacer()
        - style.horizontalSpacing - 1.0
        // For data labels
        - (dataLabel != nil ? (maxDataLabelWidth + style.horizontalSpacing) : 0)
    }

    private var maxValue: Double {
        items.map(data).max() ?? .infinity
    }

}

extension BarChart where ElementFill == Color {
    public init(items: Items,
                fillColor: Color,
                label: @escaping (Items.Element) -> ElementLabel,
                data: @escaping (Items.Element) -> Double) {
        self.init(items: items, fillStyle: fillColor, label: label, data: data)
    }
}
