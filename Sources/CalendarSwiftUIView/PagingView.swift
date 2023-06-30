//
//  PagingView.swift
//  CalendarSwiftUIView
//
//  Created by P.Nam on 28/06/2023.
//

import SwiftUI

@available(iOS 14.0, *)
internal struct PagingView<Content>: View where Content: View {
    @Binding private var index: Int
    private let count: Int
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false
    private let content: (_ index: Int) -> Content
    @State private var currentIndex: Int
    var getScrollProxy: ((ScrollViewProxy) -> Void)?
    
    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(0..<count, id: \.self) { index in
                            content(index)
                                .frame(width: proxy.size.width, height: nil)
                                .id(index)
                        }
                        .onAppear {
                            scrollViewProxy.scrollTo(Int(count / 2), anchor: .center)
                        }
                    }
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("ScrollView")).origin)
                        }
                    )
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    let offsetX = -offset.x
                    if offsetX != 0 {
                        let index = Int(proxy.size.width / offsetX)
                        if (0..<count).contains(index), currentIndex != count - index - 1 {
                            currentIndex = count - index - 1
                            withAnimation(.linear(duration: 0.3)) {
                                scrollViewProxy.scrollTo(currentIndex)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.index = currentIndex
                                scrollViewProxy.scrollTo(1)
                            }
                        }
                    }
                }
                .onAppear {
                    getScrollProxy?(scrollViewProxy)
                }
            }
        }
    }
}

@available(iOS 14.0, *)
extension PagingView {
    init(index: Binding<Int>, count: Int, @ViewBuilder content: @escaping (_ index: Int) -> Content) {
        self.init(index: index, count: count, content: content, currentIndex: index.wrappedValue, getScrollProxy: nil)
    }
    
    func getScrollProxy(perform getScrollProxy: ((ScrollViewProxy) -> Void)? = nil) -> Self {
        .init(index: _index, count: count, content: content, currentIndex: currentIndex, getScrollProxy: getScrollProxy)
    }
}
