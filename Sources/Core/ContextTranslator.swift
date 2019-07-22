//
//  Created by Jakub Vaňo on 22/07/2019.
//

// sourcery: AutoMockable
protocol AnyContextTranslator: SwinjectEntry {
    var sourceType: Any.Type { get }
    var targetType: Any.Type { get }
    func translate(_ context: Any) throws -> Any
}

struct ContextTranslator<Source, Target>: AnyContextTranslator {
    let sourceType: Any.Type = Source.self
    let targetType: Any.Type = Target.self
    let translation: (Source) -> Target

    func translate(_ context: Any) throws -> Any {
        guard let context = context as? Source else { throw SwinjectError() }
        return translation(context)
    }
}

struct IdentityTranslator: AnyContextTranslator {
    let sourceType: Any.Type
    let targetType: Any.Type

    init(for contextType: Any.Type) {
        sourceType = contextType
        targetType = contextType
    }

    func translate(_ context: Any) throws -> Any { context }
}
