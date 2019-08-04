//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import Nimble
import Quick
import Swinject

class InjectionSpec: QuickSpec { override func spec() { #if swift(>=5.1)
    describe("instance") {
        it("throws if bound type has missing dependency") {
            let swinject = Swinject {
                bbind(Pet.self) & provider { Pet(owner: try $0.instance()) }
            }
            expect { try swinject.instance(of: Pet.self) }.to(throwError())
        }
        it("injects instance if all dependencies are bound") {
            let john = Human()
            let swinject = Swinject {
                bbind(Pet.self) & provider { Pet(owner: try $0.instance()) }
                bbind(Human.self) & instance(john)
            }
            expect { try swinject.instance(of: Pet.self).owner } === john
        }
        it("throws if type's binding requires different arguments") {
            let swinject = Swinject {
                bbind(Int.self) & factory { (_, string: String) in Int(string)! }
            }
            expect { try swinject.instance() as Int }.to(throwError())
            expect { try swinject.instance(arg: 42.0) as Int }.to(throwError())
        }
    }
    describe("provider") {
        it("can inject instance provider") {
            let swinject = Swinject {
                bbind(Int.self) & 42
            }
            let intProvider = swinject.provider(of: Int.self)
            expect { try intProvider() } == 42
        }
        it("throws if provided type is not bound") {
            let swinject = Swinject {}
            let intProvider = swinject.provider(of: Int.self)
            expect { try intProvider() }.to(throwError())
        }
        it("throws if provided type has missing dependency") {
            let swinject = Swinject {
                bbind(Pet.self) & provider { Pet(owner: try $0.instance()) }
            }
            let petProvider = swinject.provider(of: Pet.self)
            expect { try petProvider() }.to(throwError())
        }
        it("throws if provided type's binding requires different arguments") {
            let swinject = Swinject {
                bbind(Int.self) & factory { (_, string: String) in Int(string)! }
            }
            expect { try swinject.provider(of: Int.self)() }.to(throwError())
            expect { try swinject.provider(of: Int.self, arg: 42.0)() }.to(throwError())
        }
    }
    describe("factory") {
        it("can inject instance factory") {
            let john = Human()
            let swinject = Swinject {
                bbind(Pet.self) & factory { try Pet(name: $1, owner: $0.instance()) }
                bbind(Human.self) & john
            }

            let petFactory = swinject.factory() as (String) throws -> Pet
            let pet = try? petFactory("mimi")

            expect(pet?.owner) === john
            expect(pet?.name) == "mimi"
        }
        it("throws if created type is not bound") {
            let swinject = Swinject {}
            let petFactory = swinject.factory() as (String) throws -> Pet
            expect { try petFactory("mimi") }.to(throwError())
        }
        it("throws if created type has missing dependency") {
            let swinject = Swinject {
                bbind(Pet.self) & factory { try Pet(name: $1, owner: $0.instance()) }
            }
            let petFactory = swinject.factory() as (String) throws -> Pet
            expect { try petFactory("mimi") }.to(throwError())
        }
        it("throws if created type's binding requires different arguments") {
            let swinject = Swinject {
                bbind(Pet.self) & factory { try Pet(name: $1, owner: $0.instance()) }
                bbind(Human.self) & provider { Human() }
            }
            let petFactory = swinject.factory() as (Int) throws -> Pet
            expect { try petFactory(42) }.to(throwError())
        }
        it("can curry factory arguments") {
            let swinject = Swinject {
                bbind(Int.self) & factory {
                    Int($1 as Int) + Int($2 as Double) + Int($3 as String)!
                }
            }
            expect { try swinject.factory()(11, 14.0, "17") as Int } == 42
            expect { try swinject.factory(arg: 11)(14.0, "17") as Int } == 42
            expect { try swinject.factory(arg: 11, 14.0)("17") as Int } == 42
            expect { try swinject.provider(arg: 11, 14.0, "17")() as Int } == 42
            expect { try swinject.instance(arg: 11, 14.0, "17") as Int } == 42
        }
    }
    describe("function call") {
        it("can inject parameter to the function") {
            func echo(int: Int) -> Int {
                return int
            }
            let swinject = Swinject {
                bbind(Int.self) & 42
            }
            expect { try swinject.call1(echo) } == 42
        }
        it("can inject multiple parameters to the function") {
            func sum(int: Int, double: Double, string: String) -> Int {
                return int + Int(double) + Int(string)!
            }
            let swinject = Swinject {
                bbind(Int.self) & 17
                bbind(Double.self) & 14.0
                bbind(String.self) & "11"
            }
            expect { try swinject.call(sum) } == 42
        }
        it("can call initializer when declaring bindings") {
            let john = Human()
            let swinject = Swinject {
                bbind(String.self) & "mimi"
                bbind(Human.self) & john
                bbind(Pet.self) & provider { try $0.call(Pet.init) }
            }
            let pet = try? swinject.instance(of: Pet.self)
            expect(pet?.name) == "mimi"
            expect(pet?.owner) === john
        }
        it("can be used for property injection") {
            let swinject = Swinject {
                bbind(Int.self) & 42
                bbind(Double.self) & 124
                bbind(String.self) & "john"
            }
            let john = Human()
            try? swinject.call(john.injectProperties)
            expect(john.age) == 42
            expect(john.height) == 124
            expect(john.name) == "john"
        }
    }
    #endif
} }
