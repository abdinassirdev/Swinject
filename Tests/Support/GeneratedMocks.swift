//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

// swiftlint:disable line_length
// swiftlint:disable variable_name

@testable import Swinject

class AnyBindingMock: AnyBinding {
    var argumentType: Any.Type {
        get { return underlyingArgumentType }
        set(value) { underlyingArgumentType = value }
    }

    var underlyingArgumentType: Any.Type!

    // MARK: - instance

    var instanceUsingThrowableError: Error?
    var instanceUsingCallsCount = 0
    var instanceUsingCalled: Bool {
        return instanceUsingCallsCount > 0
    }

    var instanceUsingReceivedInjector: Injector?
    var instanceUsingReceivedInvocations: [Injector] = []
    var instanceUsingReturnValue: Any!
    var instanceUsingClosure: ((Injector) throws -> Any)?

    func instance(using injector: Injector) throws -> Any {
        if let error = instanceUsingThrowableError {
            throw error
        }
        instanceUsingCallsCount += 1
        instanceUsingReceivedInjector = injector
        instanceUsingReceivedInvocations.append(injector)
        return try instanceUsingClosure.map { try $0(injector) } ?? instanceUsingReturnValue
    }
}

class AnyBindingEntryMock: AnyBindingEntry {
    var key: BindingKey {
        get { return underlyingKey }
        set(value) { underlyingKey = value }
    }

    var underlyingKey: BindingKey!
    var binding: AnyBinding {
        get { return underlyingBinding }
        set(value) { underlyingBinding = value }
    }

    var underlyingBinding: AnyBinding!
}

class AnyTypeDescriptorMock: AnyTypeDescriptor {
    // MARK: - matches

    var matchesCallsCount = 0
    var matchesCalled: Bool {
        return matchesCallsCount > 0
    }

    var matchesReceivedOther: AnyTypeDescriptor?
    var matchesReceivedInvocations: [AnyTypeDescriptor] = []
    var matchesReturnValue: Bool!
    var matchesClosure: ((AnyTypeDescriptor) -> Bool)?

    func matches(_ other: AnyTypeDescriptor) -> Bool {
        matchesCallsCount += 1
        matchesReceivedOther = other
        matchesReceivedInvocations.append(other)
        return matchesClosure.map { $0(other) } ?? matchesReturnValue
    }
}

class ModuleIncludeEntryMock: ModuleIncludeEntry {}
