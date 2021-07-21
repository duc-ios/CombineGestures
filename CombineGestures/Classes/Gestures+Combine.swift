//
//  Gestures+Combine.swift
//
//  Created by Duc on 22/7/2021.
//

import UIKit
import Combine

public class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {
    private var subscriber: S?
    private var gestureType: GestureType
    private var view: UIView
    init(subscriber: S, view: UIView, gestureType: GestureType) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType
        configureGesture(gestureType)
    }
    private func configureGesture(_ gestureType: GestureType) {
        let gesture = gestureType.gesture
        gesture.addTarget(self, action: #selector(handler))
        view.addGestureRecognizer(gesture)
    }
    public func request(_ demand: Subscribers.Demand) { }
    public func cancel() {
        subscriber = nil
    }
    @objc
    private func handler() {
        _ = subscriber?.receive(gestureType)
    }
}

public struct GesturePublisher: Publisher {
    public typealias Output = GestureType
    public typealias Failure = Never
    private let view: UIView
    private let gestureType: GestureType
    init(view: UIView, gestureType: GestureType) {
        self.view = view
        self.gestureType = gestureType
    }
    public func receive<S>(subscriber: S) where S : Subscriber,
                                         GesturePublisher.Failure == S.Failure,
                                         GesturePublisher.Output == S.Input {
        let subscription = GestureSubscription(
            subscriber: subscriber,
            view: view,
            gestureType: gestureType
        )
        subscriber.receive(subscription: subscription)
    }
    public func when(_ state: UIGestureRecognizer.State) -> Publishers.Filter<GesturePublisher> {
        filter { $0.state == .recognized }
    }
}

public enum GestureType {
    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())
    case edge(UIScreenEdgePanGestureRecognizer = .init())
    var gesture: UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture):
            return tapGesture
        case let .swipe(swipeGesture):
            return swipeGesture
        case let .longPress(longPressGesture):
            return longPressGesture
        case let .pan(panGesture):
            return panGesture
        case let .pinch(pinchGesture):
            return pinchGesture
        case let .edge(edgePanGesture):
            return edgePanGesture
        }
    }
    var state: UIGestureRecognizer.State {
        gesture.state
    }
}

public extension UIView {
    func tap(_ recognizer: UITapGestureRecognizer = .init()) -> GesturePublisher { gesture(.tap(recognizer)) }
    func swipe(_ recognizer: UISwipeGestureRecognizer = .init()) -> GesturePublisher { gesture(.swipe(recognizer)) }
    func longPress(_ recognizer: UILongPressGestureRecognizer = .init()) -> GesturePublisher { gesture(.longPress(recognizer)) }
    func pan(_ recognizer: UIPanGestureRecognizer = .init()) -> GesturePublisher { gesture(.pan(recognizer)) }
    func pinch(_ recognizer: UIPinchGestureRecognizer = .init()) -> GesturePublisher { gesture(.pinch(recognizer)) }
    func edge(_ recognizer: UIScreenEdgePanGestureRecognizer = .init()) -> GesturePublisher { gesture(.edge(recognizer)) }
    private func gesture(_ gestureType: GestureType = .tap()) -> GesturePublisher { .init(view: self, gestureType: gestureType) }
}
