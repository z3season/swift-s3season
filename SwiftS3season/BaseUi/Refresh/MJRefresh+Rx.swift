//
//  MJRefresh+Rx.swift
//  SwiftS3season
//
//  Created by season on 2021/7/26.
//

import Foundation
import RxSwift
import MJRefresh
import RxCocoa;

class Target: NSObject, Disposable {
    private var retainSelf: Target?

    override init() {
        super.init()
        self.retainSelf = self
    }

    func dispose() {
        self.retainSelf = nil
    }
}

private final
class MJRefreshTarget<Component: MJRefreshComponent>: Target {
    // 组件
    weak var component: Component?
    // 回调
    let refreshingBlock: MJRefreshComponentAction

    init(_ component: Component , refreshingBlock: @escaping MJRefreshComponentAction) {
        self.refreshingBlock = refreshingBlock
        self.component = component
        super.init()
        component.setRefreshingTarget(self, refreshingAction: #selector(onRefeshing))
    }

    @objc func onRefeshing() {
        refreshingBlock()
    }
    
    override func dispose() {
        super.dispose()
        self.component?.refreshingBlock = nil
    }

}

extension Reactive where Base: MJRefreshComponent {
    var refresh: ControlProperty<MJRefreshState> {
        let source: Observable<MJRefreshState> = Observable.create { [weak component = self.base] observer  in
            MainScheduler.ensureExecutingOnScheduler()
            guard let component = component else {
                observer.on(.completed)
                return Disposables.create()
            }

            observer.on(.next(component.state))

            let observer = MJRefreshTarget(component) {
                observer.on(.next(component.state))
            }
            return observer
        }.take(until: deallocated)
        let bindingObserver = Binder<MJRefreshState>(self.base) { (component, state) in
            component.state = state
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
