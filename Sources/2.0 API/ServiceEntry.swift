//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

/// The `ServiceEntry<Service>` class represents an entry of a registered service type.
/// As a returned instance from a `register` method of a `Container`, some configurations can be added.
public struct ServiceEntry<Service> {
    private let builder: (Resolver, Any, Any) -> Service
    private var key: AnyBindingKey
    private var scope: AnyScope?
    private var initCompleted = [(Resolver, Any) -> Void]()

    var objectScope: ObjectScope? { return nil }

    init<Argument>(
        name: String?,
        scope: AnyScope?,
        builder: @escaping (Resolver, Any, Argument) -> Service
    ) {
        self.builder = { builder($0, $1, $2 as! Argument) }
        if let name = name {
            self.key = BindingKey<Tagged<Service, String>, Any, Argument>(descriptor: tagged(Service.self, with: name))
        } else {
            self.key = BindingKey<Tagged<Service, NoTag>, Any, Argument>(descriptor: plain(Service.self))
        }
        self.scope = scope
    }

    /// Specifies the object scope to resolve the service.
    ///
    /// - Parameter scope: The `ObjectScopeProtocol` value.
    ///
    /// - Returns: `self` to add another configuration fluently.
    @discardableResult
    public func inObjectScope<ObjectScope>(_ scope: ObjectScope) -> Self where ObjectScope: Scope {
        return self
    }

    /// Specifies the object scope to resolve the service.
    /// Performs the same functionality as `inObjectScope(_: ObjectScopeProtocol) -> Self`,
    /// but provides more convenient usage syntax.
    ///
    /// - Parameter scope: The `ObjectScope` value.
    ///
    /// - Returns: `self` to add another configuration fluently.
    @discardableResult
    public func inObjectScope(_ objectScope: ObjectScope) -> Self {
        return self
    }

    /// Adds the callback to setup the instance after its `init` completes.
    /// *Property or method injections* can be performed in the callback.
    /// To resolve *circular dependencies*, `initCompleted` must be used.
    ///
    /// - Parameter completed: The closure to be called after the instantiation of the registered service.
    ///
    /// - Returns: `self` to add another configuration fluently.
    @discardableResult
    public func initCompleted(_ completed: @escaping (Resolver, Service) -> Void) -> Self {
        return self
    }
}

extension ServiceEntry: Binding {
    public func matches(_ key: AnyBindingKey) -> Bool {
        self.key.matches(key)
    }

    public func instance(arg: Any, context: Any, resolver: Resolver) throws -> Any {
        if let scope = scope {
            return scope.registry(for: context).instance(
                for: ScopeRegistryKey(descriptor: key.descriptor, argument: arg),
                builder: { builder(resolver, context, arg) },
                finalizer: { instance in initCompleted.forEach { $0(resolver, instance) } }
            )
        } else {
            return builder(resolver, context, arg)
        }
    }
}
