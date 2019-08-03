//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

public struct BindingKey: Hashable {
    let descriptor: TypeDescriptor
    let contextType: Any.Type
    let argumentType: Any.Type

    public func hash(into hasher: inout Hasher) {
        descriptor.hash(into: &hasher)
        ObjectIdentifier(contextType).hash(into: &hasher)
        ObjectIdentifier(argumentType).hash(into: &hasher)
    }

    public static func == (lhs: BindingKey, rhs: BindingKey) -> Bool {
        return lhs.descriptor.isEqual(to: rhs.descriptor)
            && lhs.contextType == rhs.contextType
            && lhs.argumentType == rhs.argumentType
    }
}

public protocol Binding: SwinjectEntry {
    var key: BindingKey { get }
    var properties: BindingProperties { get }
    func instance(arg: Any, context: Any, resolver: Resolver) throws -> Any
}

public protocol BindingBuilder {
    associatedtype BoundType
    func makeBinding(with properties: BindingProperties) -> Binding
}

public struct SomeBindingBuilder<BoundType>: BindingBuilder, AnyOpaque {
    let anyActual: Any
    fileprivate let _makeBinding: (BindingProperties) -> Binding

    public func makeBinding(with properties: BindingProperties) -> Binding {
        return _makeBinding(properties)
    }
}

public extension BindingBuilder {
    var opaque: SomeBindingBuilder<BoundType> {
        return SomeBindingBuilder(anyActual: self) { self.makeBinding(with: $0) }
    }
}
