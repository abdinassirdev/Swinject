//
//  ServiceKeySpec.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 7/23/15.
//  Copyright © 2015 DevSwinject. All rights reserved.
//

import Quick
import Nimble
@testable import Swinject

class ServiceKeySpec: QuickSpec {
    override func spec() {
        describe("Without name") {
            it("equals with the same factory type.") {
                typealias FactoryType0 = Container -> FooType
                let key1 = ServiceKey(factoryType: FactoryType0.self)
                let key2 = ServiceKey(factoryType: FactoryType0.self)
                expect(key1) == key2
                expect(key1.hashValue) == key2.hashValue
                
                typealias FactoryType2 = (Container, String, Int) -> FooType
                let key3 = ServiceKey(factoryType: FactoryType2.self)
                let key4 = ServiceKey(factoryType: FactoryType2.self)
                expect(key3) == key4
                expect(key3.hashValue) == key4.hashValue
            }
            it("does not equal with different service types in factory types.") {
                typealias FactoryType0F = Container -> FooType
                typealias FactoryType0B = Container -> BarType
                let key1 = ServiceKey(factoryType: FactoryType0F.self)
                let key2 = ServiceKey(factoryType: FactoryType0B.self)
                expect(key1) != key2
                expect(key1.hashValue) != key2.hashValue
            }
            it("does not equal with different arg types in factory types.") {
                typealias FactoryType1 = (Container, String) -> FooType
                typealias FactoryType2 = (Container, String, Int) -> FooType
                let key1 = ServiceKey(factoryType: FactoryType1.self)
                let key2 = ServiceKey(factoryType: FactoryType2.self)
                expect(key1) != key2
                expect(key1.hashValue) != key2.hashValue
                
                typealias FactoryType2SI = (Container, String, Int) -> FooType
                typealias FactoryType2SB = (Container, String, Bool) -> FooType
                let key3 = ServiceKey(factoryType: FactoryType2SI.self)
                let key4 = ServiceKey(factoryType: FactoryType2SB.self)
                expect(key3) != key4
                expect(key3.hashValue) != key4.hashValue
            }
        }
        describe("With name") {
            it("equals with the same name.") {
                typealias FactoryType0 = Container -> FooType
                let key1 = ServiceKey(factoryType: FactoryType0.self, name: "my factory")
                let key2 = ServiceKey(factoryType: FactoryType0.self, name: "my factory")
                expect(key1) == key2
                expect(key1.hashValue) == key2.hashValue
                
                typealias FactoryType2 = (Container, String, Int) -> FooType
                let key3 = ServiceKey(factoryType: FactoryType2.self, name: "my factory")
                let key4 = ServiceKey(factoryType: FactoryType2.self, name: "my factory")
                expect(key3) == key4
                expect(key3.hashValue) == key4.hashValue
            }
            it("does not equal with different names.") {
                typealias FactoryType0 = Container -> FooType
                let key1 = ServiceKey(factoryType: FactoryType0.self, name: "my factory")
                let key2 = ServiceKey(factoryType: FactoryType0.self, name: "your factory")
                expect(key1) != key2
                expect(key1.hashValue) != key2.hashValue
                
                typealias FactoryType2 = (Container, String, Int) -> FooType
                let key3 = ServiceKey(factoryType: FactoryType2.self, name: "my factory")
                let key4 = ServiceKey(factoryType: FactoryType2.self, name: "your factory")
                expect(key3) != key4
                expect(key3.hashValue) != key4.hashValue
            }
        }
    }
}
