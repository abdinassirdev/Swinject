//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

import Nimble
import Quick
import Swinject

class ScopesSpec: QuickSpec { override func spec() { #if swift(>=5.1)
    it("can bind singleton on a scope without context") {
        let scope = UnboundScope()
        let swinject = Swinject {
            registerSingle(in: scope).factory { Human() }
        }
        let first = try? swinject.instance(of: Human.self)
        let second = try? swinject.instance(of: Human.self)
        expect(first) === second
    }
    it("can bind singleton on a scope with context") {
        let scope = SessionScope()
        let session = Session()
        let swinject = Swinject {
            registerSingle(in: scope).factory { Human() }
        }
        let first = try? swinject.on(session).instance(of: Human.self)
        let second = try? swinject.on(session).instance(of: Human.self)
        expect(first) === second
    }
    it("throws if injecting scoped singleton without context") {
        let scope = SessionScope()
        let swinject = Swinject {
            registerSingle(in: scope).factory { Human() }
        }
        expect { try swinject.instance(of: Human.self) }.to(throwError())
    }
    it("injects different intances on different contexts") {
        let scope = SessionScope()
        let swinject = Swinject {
            registerSingle(in: scope).factory { Human() }
        }
        let first = try? swinject.on(Session()).instance(of: Human.self)
        let second = try? swinject.on(Session()).instance(of: Human.self)
        expect(first) !== second
    }
    describe("closable") {
        it("can close (some) scopes") {
            let scope = UnboundScope()
            let swinject = Swinject {
                registerSingle(in: scope).factory { Human() }
            }

            let first = try? swinject.instance(of: Human.self)
            scope.close()
            let second = try? swinject.instance(of: Human.self)

            expect(first) !== second
        }
        it("notifies instances when scope is closed") {
            let scope = UnboundScope()
            let swinject = Swinject {
                registerSingle(in: scope).factory { Door() }
            }
            let door = try? swinject.instance() as Door

            scope.close()

            expect(door?.isClosed) == true
        }
        it("closes scoped instances when context expires") {
            let scope = SessionScope()
            var session = Session() as Session?
            let swinject = Swinject {
                registerSingle(in: scope).factory { Door() }
            }
            let door = try? swinject.on(session!).instance(of: Door.self)

            session = nil

            expect(door?.isClosed) == true
        }
        it("releases scoped instances when context expires") {
            let scope = SessionScope()
            var session = Session() as Session?
            let swinject = Swinject {
                registerSingle(in: scope).factory { Human() }
            }
            weak var instance = try? swinject.on(session!).instance(of: Human.self)

            session = nil

            expect(instance).to(beNil())
        }
    }
    #endif
} }

class Session {
    let registry = StandardScopeRegistry()
}

struct SessionScope: Scope {
    func registry(for session: Session) -> ScopeRegistry {
        return session.registry
    }
}
