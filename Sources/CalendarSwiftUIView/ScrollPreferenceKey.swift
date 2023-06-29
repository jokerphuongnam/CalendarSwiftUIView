//
//  ScrollPreferenceKey.swift
//  CalendarSwiftUIView
//
//  Created by P.Nam on 12/06/2023.
//

import SwiftUI

internal struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    private init() {}
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}
