//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import func Swinject.bind
import struct Swinject.SomeTypeDescriptor
import struct Swinject.TypeBinder
import protocol Swinject.TypeDescriptor

// Original Swinject functions conflict with QuickSpec's instance methods
func bbind<Type>(_: Type.Type) -> TypeBinder<SomeTypeDescriptor<Type>> {
    bind(Type.self)
}

func bbind<Type, Tag>(_: Type.Type, tagged tag: Tag) -> TypeBinder<SomeTypeDescriptor<Type>> where Tag: Hashable {
    bind(Type.self, tagged: tag)
}

func bbind<Descriptor>(descriptor: Descriptor) -> TypeBinder<Descriptor> where Descriptor: TypeDescriptor {
    bind(descriptor: descriptor)
}
