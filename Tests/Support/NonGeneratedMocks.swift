//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

@testable import Swinject

class DummyResolver: Resolver {
    func resolve<Descriptor, Argument>(_ _: BindingRequest<Descriptor, Argument>) throws -> Descriptor.BaseType where Descriptor: TypeDescriptor {
        fatalError()
    }

    func provider<Descriptor, Argument>(for _: BindingRequest<Descriptor, Argument>) throws -> () throws -> Descriptor.BaseType where Descriptor: TypeDescriptor {
        fatalError()
    }
}

extension AnyTypeDescriptorMock: TypeDescriptor {
    typealias BaseType = Any
}

extension AnyBindingMock: Binding {
    typealias Argument = Any
}

class DummyBinding<Argument>: Binding {
    func instance(arg _: Argument, context: Void, resolver _: Resolver) throws -> Any {
        fatalError()
    }
}
