//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

public struct BinderEnvironment<AScope, Context> {
    let scope: AScope
}

public func contexted<Context>(_: Context.Type = Context.self) -> BinderEnvironment<Void, Context> {
    BinderEnvironment(scope: ())
}

public func scoped<AScope>(_ scope: AScope) -> BinderEnvironment<AScope, AScope.Context> where AScope: Scope {
    BinderEnvironment(scope: scope)
}

public extension BinderEnvironment where AScope == Void {
    func provider<Type>(_ builder: @escaping (Resolver3, Context) throws -> Type) -> SimpleBinding.Builder<Type, Context, Void> {
        .init { r, c, _ in try builder(r, c) }
    }

    func factory<Type, Arg1>(_ builder: @escaping (Resolver3, Context, Arg1) throws -> Type) -> SimpleBinding.Builder<Type, Context, Arg1> {
        .init(builder)
    }
}

public extension BinderEnvironment where AScope == Void {
    func factory<Type, Arg1, Arg2>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2) throws -> Type) -> SimpleBinding.Builder<Type, Context, (Arg1, Arg2)> {
        .init { try builder($0, $1, $2.0, $2.1) }
    }

    func factory<Type, Arg1, Arg2, Arg3>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2, Arg3) throws -> Type) -> SimpleBinding.Builder<Type, Context, (Arg1, Arg2, Arg3)> {
        .init { try builder($0, $1, $2.0, $2.1, $2.2) }
    }

    func factory<Type, Arg1, Arg2, Arg3, Arg4>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2, Arg3, Arg4) throws -> Type) -> SimpleBinding.Builder<Type, Context, (Arg1, Arg2, Arg3, Arg4)> {
        .init { try builder($0, $1, $2.0, $2.1, $2.2, $2.3) }
    }

    func factory<Type, Arg1, Arg2, Arg3, Arg4, Arg5>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Type) -> SimpleBinding.Builder<Type, Context, (Arg1, Arg2, Arg3, Arg4, Arg5)> {
        .init { try builder($0, $1, $2.0, $2.1, $2.2, $2.3, $2.4) }
    }
}

public extension BinderEnvironment where AScope: Scope, Context == AScope.Context {
    func singleton<Type>(_ builder: @escaping () throws -> Type) -> ScopedBinding.Builder<Type, AScope, Void> {
        .init(scope) { _, _, _ in try builder() }
    }

    func singleton<Type>(_ builder: @escaping (Resolver3) throws -> Type) -> ScopedBinding.Builder<Type, AScope, Void> {
        .init(scope) { r, _, _ in try builder(r) }
    }

    func singleton<Type>(_ builder: @escaping (Resolver3, Context) throws -> Type) -> ScopedBinding.Builder<Type, AScope, Void> {
        .init(scope) { r, c, _ in try builder(r, c) }
    }
}

public extension BinderEnvironment where AScope: Scope, Context == AScope.Context {
    func multiton<Type, Arg1>(_ builder: @escaping (Resolver3, Context, Arg1) throws -> Type) -> ScopedBinding.Builder<Type, AScope, Arg1> {
        .init(scope, builder)
    }

    func multiton<Type, Arg1, Arg2>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2) throws -> Type) -> ScopedBinding.Builder<Type, AScope, (Arg1, Arg2)> {
        .init(scope) { try builder($0, $1, $2.0, $2.1) }
    }

    func multiton<Type, Arg1, Arg2, Arg3>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2, Arg3) throws -> Type) -> ScopedBinding.Builder<Type, AScope, (Arg1, Arg2, Arg3)> {
        .init(scope) { try builder($0, $1, $2.0, $2.1, $2.2) }
    }

    func multiton<Type, Arg1, Arg2, Arg3, Arg4>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2, Arg3, Arg4) throws -> Type) -> ScopedBinding.Builder<Type, AScope, (Arg1, Arg2, Arg3, Arg4)> {
        .init(scope) { try builder($0, $1, $2.0, $2.1, $2.2, $2.3) }
    }

    func multiton<Type, Arg1, Arg2, Arg3, Arg4, Arg5>(_ builder: @escaping (Resolver3, Context, Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Type) -> ScopedBinding.Builder<Type, AScope, (Arg1, Arg2, Arg3, Arg4, Arg5)> {
        .init(scope) { try builder($0, $1, $2.0, $2.1, $2.2, $2.3, $2.4) }
    }
}

public func instance<Type>(_ instance: Type) -> SimpleBinding.Builder<Type, Any, Void> {
    .init { _, _, _ in instance }
}

public func provider<Type>(_ builder: @escaping () throws -> Type) -> SimpleBinding.Builder<Type, Any, Void> {
    .init { _, _, _ in try builder() }
}

public func provider<Type>(_ builder: @escaping (Resolver3) throws -> Type) -> SimpleBinding.Builder<Type, Any, Void> {
    .init { r, _, _ in try builder(r) }
}

public func factory<Type, Arg1>(_ builder: @escaping (Resolver3, Arg1) throws -> Type) -> SimpleBinding.Builder<Type, Any, Arg1> {
    .init { try builder($0, $2) }
}

public func factory<Type, Arg1, Arg2>(_ builder: @escaping (Resolver3, Arg1, Arg2) throws -> Type) -> SimpleBinding.Builder<Type, Any, (Arg1, Arg2)> {
    .init { try builder($0, $2.0, $2.1) }
}

public func factory<Type, Arg1, Arg2, Arg3>(_ builder: @escaping (Resolver3, Arg1, Arg2, Arg3) throws -> Type) -> SimpleBinding.Builder<Type, Any, (Arg1, Arg2, Arg3)> {
    .init { try builder($0, $2.0, $2.1, $2.2) }
}

public func factory<Type, Arg1, Arg2, Arg3, Arg4>(_ builder: @escaping (Resolver3, Arg1, Arg2, Arg3, Arg4) throws -> Type) -> SimpleBinding.Builder<Type, Any, (Arg1, Arg2, Arg3, Arg4)> {
    SimpleBinding.Builder { try builder($0, $2.0, $2.1, $2.2, $2.3) }
}

public func factory<Type, Arg1, Arg2, Arg3, Arg4, Arg5>(_ builder: @escaping (Resolver3, Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Type) -> SimpleBinding.Builder<Type, Any, (Arg1, Arg2, Arg3, Arg4, Arg5)> {
    SimpleBinding.Builder { try builder($0, $2.0, $2.1, $2.2, $2.3, $2.4) }
}

public func singleton<Type>(_ builder: @escaping () throws -> Type) -> ScopedBinding.Builder<Type, UnboundScope, Void> {
    .init(.root) { _, _, _ in try builder() }
}

public func singleton<Type>(_ builder: @escaping (Resolver3) throws -> Type) -> ScopedBinding.Builder<Type, UnboundScope, Void> {
    .init(.root) { r, _, _ in try builder(r) }
}

public func multiton<Type, Arg1>(_ builder: @escaping (Resolver3, Arg1) throws -> Type) -> ScopedBinding.Builder<Type, UnboundScope, Arg1> {
    .init(.root) { try builder($0, $2) }
}

public func multiton<Type, Arg1, Arg2>(_ builder: @escaping (Resolver3, Arg1, Arg2) throws -> Type) -> ScopedBinding.Builder<Type, UnboundScope, (Arg1, Arg2)> {
    .init(.root) { try builder($0, $2.0, $2.1) }
}

public func multiton<Type, Arg1, Arg2, Arg3>(_ builder: @escaping (Resolver3, Arg1, Arg2, Arg3) throws -> Type) -> ScopedBinding.Builder<Type, UnboundScope, (Arg1, Arg2, Arg3)> {
    .init(.root) { try builder($0, $2.0, $2.1, $2.2) }
}

public func multiton<Type, Arg1, Arg2, Arg3, Arg4>(_ builder: @escaping (Resolver3, Arg1, Arg2, Arg3, Arg4) throws -> Type) -> ScopedBinding.Builder<Type, UnboundScope, (Arg1, Arg2, Arg3, Arg4)> {
    .init(.root) { try builder($0, $2.0, $2.1, $2.2, $2.3) }
}

public func multiton<Type, Arg1, Arg2, Arg3, Arg4, Arg5>(_ builder: @escaping (Resolver3, Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Type) -> ScopedBinding.Builder<Type, UnboundScope, (Arg1, Arg2, Arg3, Arg4, Arg5)> {
    .init(.root) { try builder($0, $2.0, $2.1, $2.2, $2.3, $2.4) }
}
