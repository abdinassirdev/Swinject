//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

public struct Swinject {
    let tree: SwinjectTree

    init(tree: SwinjectTree) {
        self.tree = tree
    }
}

public extension Swinject {
    init(@SwinjectTreeBuilder builder: () -> [SwinjectEntry]) {
        self.init(tree: SwinjectTreeBuilder.buildFunction(builder()))
    }

    init(@SwinjectTreeBuilder builder: () -> SwinjectEntry) {
        self.init(tree: SwinjectTreeBuilder.buildFunction([builder()]))
    }

    init(@SwinjectTreeBuilder _: () -> Void) {
        self.init(tree: SwinjectTreeBuilder.buildFunction([]))
    }
}

extension Swinject: Injector {
    public func instance<Descriptor, Argument>(for request: BindingRequest<Descriptor, Argument>) throws -> Descriptor.BaseType where Descriptor: TypeDescriptor {
        try instance(from: findBinding(for: request.key), arg: request.argument)
    }

    public func provider<Descriptor, Argument>(for request: BindingRequest<Descriptor, Argument>) throws -> () throws -> Descriptor.BaseType where Descriptor: TypeDescriptor {
        let binding = try findBinding(for: request.key)
        return { try self.instance(from: binding, arg: request.argument) }
    }

    private func findBinding(for key: AnyBindingKey) throws -> AnyBinding {
        let entries = tree.bindingEntries.filter { $0.key.matches(key) }
        guard entries.count == 1 else { throw SwinjectError() }
        return entries[0].binding
    }

    private func instance<Type, Argument>(from binding: AnyBinding, arg: Argument) throws -> Type {
        try binding.instance(arg: arg, injector: self) as? Type ?? { throw SwinjectError() }()
    }
}
