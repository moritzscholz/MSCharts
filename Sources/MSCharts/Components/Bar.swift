//
//  Bar.swift
//
//
//  Created by Moritz Scholz on 09.01.22.
//

import SwiftUI

struct Bar<Fill: ShapeStyle>: View {
    var width: CGFloat
    var fill: Fill

    var body: some View {
        RoundedRectangle(cornerRadius: 6.0)
            .fill(fill)
            .frame(width: width)
    }
}
