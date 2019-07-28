//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

protocol Mammal {}

class Human: Mammal {
    var age = 0
    var height = 0.0
    var name = ""
}

struct Pet {
    let name: String
    let owner: Human

    init(name: String = "", owner: Human) {
        self.name = name
        self.owner = owner
    }
}

class Building {
    let floors: Int

    init(floors: Int) {
        self.floors = floors
    }
}

struct TestError: Error, Equatable {}
