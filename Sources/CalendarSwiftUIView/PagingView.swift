//
//  PagingView.swift
//  iOSFootball2AM
//
//  Created by P.Nam on 28/06/2023.
//

import SwiftUI

@available(iOS 14.0, *)
internal struct PagingView<Content>: View where Content: View {
    @StateObject private var controller: PagingController
    @Binding private var index: Int
    private let count: Int
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false
    private let content: (_ index: Int) -> Content
    @State private var currentIndex = 0
    var getScrollProxy: ((ScrollViewProxy) -> Void)?
    
    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .center, spacing: 0) {
                        ForEach(0..<count, id: \.self) { index in
                            content(index)
                                .frame(width: proxy.size.width, height: nil)
                                .id(index)
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
                        if (0..<count).contains(index) {
                            currentIndex = count - index - 1
                        }
                    }
                }
                .onAppear {
                    controller.reset = {
                        index = currentIndex
                        scrollViewProxy.scrollTo(1)
                    }
                    scrollViewProxy.scrollTo(index)
                    getScrollProxy?(scrollViewProxy)
                    UIScrollView.appearance().isPagingEnabled = true
                    UIScrollView.appearance().delegate = controller
                }
            }
        }
    }
}

@available(iOS 14.0, *)
internal extension PagingView {
    init(index: Binding<Int>, count: Int, @ViewBuilder content: @escaping (_ index: Int) -> Content) {
        self.init(controller: PagingController(completion: nil), index: index, count: count, content: content, getScrollProxy: nil)
        currentIndex = index.wrappedValue
    }
    
    func getScrollProxy(perform getScrollProxy: ((ScrollViewProxy) -> Void)? = nil) -> Self {
        .init(controller: controller, index: _index, count: count, content: content, getScrollProxy: getScrollProxy)
    }
}

@available(iOS 13.0, *)
private final class PagingController: NSObject, ObservableObject {
    private let completion: (() -> Void)?
    var reset: (() -> Void)?
    
    init(completion: (() -> Void)?) {
        self.completion = completion
    }
}

@available(iOS 13.0, *)
extension PagingController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reset?()
    }
}
