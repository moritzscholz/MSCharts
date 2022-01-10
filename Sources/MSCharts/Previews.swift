//
//  Previews.swift
//  
//
//  Created by Moritz Scholz on 09.01.22.
//

import SwiftUI

public struct ChartInteractivePreview: View {
    @State private var people: [Person] = faces.map {
        Person(emoji: $0, age: (1...100).randomElement()!)
    }

    public init() {}

    public var body: some View {
        VStack {
            HStack {
                Button("Add") {
                    withAnimation {
                        people.append(Person(emoji: faces.randomElement()!,
                                             age: (1...100).randomElement()!))
                    }
                }

                Button("Shuffle") {
                    withAnimation {
                        people.shuffle()
                    }
                }

            }

            VStack {
                BarChart(items: people, fill: .uniform(.pink)) {
                    Text(verbatim: $0.emoji)
                } data: {
                    Double($0.age)
                }

                BarChart(items: people,
                         fill: .provided(by: { _ in
                    LinearGradient(colors: [colors.randomElement()!, colors.randomElement()!],
                                   startPoint: .bottomLeading, endPoint: .topTrailing)
                })) {
                    Text(verbatim: $0.emoji)
                } data: {
                    Double($0.age)
                } dataLabel: {
                    String($0.age)
                }

                Spacer()
            }
        }
    }
}

struct Chart_Previews: PreviewProvider {
    static var previews: some View {
        ChartInteractivePreview()
    }
}

private struct Person: Identifiable {
    var emoji: String
    var age: Int

    var id: String { "\(emoji)\(age)" }
}

private let faces: [String] = [
    "🥸", "🙂", "🥰", "🎅🏻"
]

private let colors: [Color] = [.pink, .blue, .purple, .green]
