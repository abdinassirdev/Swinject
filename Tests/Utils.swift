//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import func Swinject.bind
import struct Swinject.ProviderBinding
import struct Swinject.TypeBinder
import protocol Swinject.TypeDescriptor

// Original Swinject functions conflict with QuickSpec's instance methods
func bbind<Type>(_: Type.Type) -> TypeBinder<Type> {
    Swinject.bind(Type.self)
}

func bbind<Type, Tag>(_: Type.Type, tagged tag: Tag) -> TypeBinder<Type> where Tag: Equatable {
    Swinject.bind(Type.self, tagged: tag)
}

func bbind<Descriptor>(_ descriptor: Descriptor) -> TypeBinder<Descriptor.BaseType> where Descriptor: TypeDescriptor {
    Swinject.bind(descriptor)
}
