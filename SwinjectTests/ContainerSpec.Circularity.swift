//
//  ContainerSpec.Circularity.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 7/29/15.
//  Copyright © 2015 DevSwinject. All rights reserved.
//

import Quick
import Nimble
@testable import Swinject

class ContainerSpec_Circularity: QuickSpec {
    override func spec() {
        var container: Container!
        beforeEach {
            container = Container()
        }
        
        describe("Two objects") {
            it("resolves circular dependency on each property.") {
                let runInObjectScope: ObjectScope -> Void = { scope in
                    container.register(ParentType.self) { _ in Mother() }
                        .initCompleted { (c, i) in
                            let mother = i as! Mother
                            mother.child = c.resolve(ChildType.self)
                        }
                        .inObjectScope(scope)
                    container.register(ChildType.self) { _ in Daughter() }
                        .initCompleted { (c, i) in
                            let daughter = i as! Daughter
                            daughter.parent = c.resolve(ParentType.self)!
                        }
                        .inObjectScope(scope)
                    
                    let mother = container.resolve(ParentType.self) as! Mother
                    let daughter = mother.child as! Daughter
                    expect(daughter.parent as? Mother) === mother
                }
                
                runInObjectScope(.Graph)
                runInObjectScope(.Container)
                runInObjectScope(.Hierarchy)
            }
            it("resolves circular dependency on the initializer and property.") {
                let runInObjectScope: ObjectScope -> Void = { scope in
                    container.register(ParentType.self) { c in Mother(child: c.resolve(ChildType.self)!) }
                        .inObjectScope(scope)
                    container.register(ChildType.self) { _ in Daughter() }
                        .initCompleted { (c, i) in
                            let daughter = i as! Daughter
                            daughter.parent = c.resolve(ParentType.self)
                        }
                        .inObjectScope(scope)
                    
                    let mother = container.resolve(ParentType.self) as! Mother
                    let daughter = mother.child as! Daughter
                    expect(daughter.parent as? Mother) === mother
                }
                
                runInObjectScope(.Graph)
                runInObjectScope(.Container)
                runInObjectScope(.Hierarchy)
            }
        }
        describe("More than two objects") {
            it("resolves circular dependency on properties.") {
                container.register(AType.self) { _ in ADependingOnB() }
                    .initCompleted {
                        let a = $1 as! ADependingOnB
                        a.b = $0.resolve(BType.self)
                    }
                container.register(BType.self) { _ in BDependingOnC() }
                    .initCompleted {
                        let b = $1 as! BDependingOnC
                        b.c = $0.resolve(CType.self)
                    }
                container.register(CType.self) { _ in CDependingOnAD() }
                    .initCompleted {
                        let c = $1 as! CDependingOnAD
                        c.a = $0.resolve(AType.self)
                        c.d = $0.resolve(DType.self)
                    }
                container.register(DType.self) { _ in DDependingOnBC() }
                    .initCompleted {
                        let d = $1 as! DDependingOnBC
                        d.b = $0.resolve(BType.self)
                        d.c = $0.resolve(CType.self)
                    }
                
                let a = container.resolve(AType.self) as! ADependingOnB
                let b = a.b as! BDependingOnC
                let c = b.c as! CDependingOnAD
                let d = c.d as! DDependingOnBC
                expect(c.a as? ADependingOnB) === a
                expect(d.b as? BDependingOnC) === b
                expect(d.c as? CDependingOnAD) === c
            }
            it("resolves circular dependency on initializers and properties.") {
                container.register(AType.self) { cnt in ADependingOnB(b: cnt.resolve(BType.self)!) }
                container.register(BType.self) { cnt in BDependingOnC(c: cnt.resolve(CType.self)!) }
                container.register(CType.self) { cnt in CDependingOnAD(d: cnt.resolve(DType.self)!) }
                    .initCompleted {
                        let c = $1 as! CDependingOnAD
                        c.a = $0.resolve(AType.self)
                    }
                container.register(DType.self) { _ in DDependingOnBC() }
                    .initCompleted {
                        let d = $1 as! DDependingOnBC
                        d.b = $0.resolve(BType.self)
                        d.c = $0.resolve(CType.self)
                    }
                
                let a = container.resolve(AType.self) as! ADependingOnB
                let b = a.b as! BDependingOnC
                let c = b.c as! CDependingOnAD
                let d = c.d as! DDependingOnBC
                expect(c.a as? ADependingOnB) === a
                expect(d.b as? BDependingOnC) === b
                expect(d.c as? CDependingOnAD) === c
            }
        }
    }
}
