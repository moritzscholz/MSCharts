//
//  ChartStyle.swift
//
//
//  Created by Moritz Scholz on 09.01.22.
//

import SwiftUI

public struct ChartStyle {
    public init(horizontalSpacing: CGFloat = 3.0,
                verticalSpacing: CGFloat = 3.0,
                labelAlignment: Alignment = .trailing,
                shouldAnimateOnAppearance: Bool = true,
                dataLabelFont: Font = .caption,
                dataLabelColor: Color = .gray,
                barThickness: CGFloat = 15) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.labelAlignment = labelAlignment
        self.shouldAnimateOnAppearance = shouldAnimateOnAppearance
        self.dataLabelFont = dataLabelFont
        self.dataLabelColor = dataLabelColor
        self.barThickness = barThickness
    }

    public static var defaultStyle: ChartStyle = .init()

    public var horizontalSpacing: CGFloat = 3.0
    public var verticalSpacing: CGFloat = 3.0

    public var labelAlignment: Alignment = .trailing

    public var shouldAnimateOnAppearance: Bool = true

    public var dataLabelFont: Font = .caption
    public var dataLabelColor: Color = .gray

    public var barThickness: CGFloat = 15
}

public enum ChartElementShapeStyle<Item, Style> where Style: ShapeStyle {
    /// All chart elements are filled in the same style.
    case uniform(Style)
    /// Fill style for each chart element is provided by the given closure.
    case provided(by: (Item) -> Style)
}
