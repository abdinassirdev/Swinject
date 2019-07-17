//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

public struct TypeBinder<Descriptor> where Descriptor: TypeDescriptor {
    let descriptor: Descriptor
}

public func bind<Type>(_: Type.Type) -> TypeBinder<Tagged<Type, NoTag>> {
    bind(plain(Type.self))
}

public func bind<Type, Tag>(_: Type.Type, tagged tag: Tag) -> TypeBinder<Tagged<Type, Tag>> where Tag: Equatable {
    bind(tagged(Type.self, with: tag))
}

public func bind<Descriptor>(_ descriptor: Descriptor) -> TypeBinder<Descriptor> where Descriptor: TypeDescriptor {
    TypeBinder(descriptor: descriptor)
}

public extension TypeBinder {
    func with<SomeMaker>(_ maker: SomeMaker) -> MakerEntry<Descriptor.BaseType> where SomeMaker: InstanceMaker, SomeMaker.MadeType == Descriptor.BaseType {
        MakerEntry(key: MakerKey<Descriptor, SomeMaker.Context, SomeMaker.Argument>(descriptor: descriptor), maker: maker)
    }

    func with(_ anInstance: Descriptor.BaseType) -> MakerEntry<Descriptor.BaseType> {
        with(instance(anInstance))
    }
}

public func & <Descriptor, SomeMaker>(lhs: TypeBinder<Descriptor>, rhs: SomeMaker) -> MakerEntry<Descriptor.BaseType> where SomeMaker: InstanceMaker, SomeMaker.MadeType == Descriptor.BaseType {
    lhs.with(rhs)
}

public func & <Descriptor>(lhs: TypeBinder<Descriptor>, rhs: Descriptor.BaseType) -> MakerEntry<Descriptor.BaseType> {
    lhs.with(rhs)
}
