//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

// sourcery: AutoMockable
public protocol Scope {
    associatedtype Context

    var lock: Lock { get }
    func registry(for context: Context) -> ScopeRegistry
}

public protocol Lock {}

public protocol ScopeRegistry {
    func register<Type>(_ instance: Type, for key: ScopeRegistryKey)
    func instance<Type>(for key: ScopeRegistryKey) -> Type?
}

public struct ScopeRegistryKey {}

public class ImplicitScope: Scope {
    public typealias Context = Any

    public var lock: Lock { fatalError() }

    public func registry(for _: Any) -> ScopeRegistry {
        fatalError()
    }
}

extension ImplicitScope {
    static let implicit = ImplicitScope()
}
