//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

public protocol SwinjectEntry {}

public struct SwinjectTree {
    let bindings: [Binding]
    let includeEntries: [ModuleIncludeEntry]
    let translators: [AnyContextTranslator]
}

@_functionBuilder
public enum SwinjectTreeBuilder {
    public static func buildBlock() {}

    public static func buildBlock(_ input: SwinjectEntry ...) -> [SwinjectEntry] {
        input.flatMap(unpack)
    }

    public static func buildIf(_ input: [SwinjectEntry]?) -> SwinjectEntry {
        Composed(parts: input ?? [])
    }

    public static func buildEither(first input: [SwinjectEntry]) -> SwinjectEntry {
        Composed(parts: input)
    }

    public static func buildEither(second input: [SwinjectEntry]) -> SwinjectEntry {
        Composed(parts: input)
    }

    // This is not used by compiler implicitly yet
    public static func buildFunction(_ input: [SwinjectEntry]) -> SwinjectTree {
        let entries = input.flatMap(unpack)
        return SwinjectTree(
            bindings: entries.compactMap { $0 as? Binding },
            includeEntries: entries.compactMap { $0 as? ModuleIncludeEntry },
            translators: entries.compactMap { $0 as? AnyContextTranslator }
        )
        // TODO: Validate
    }
}

extension SwinjectTreeBuilder {
    private struct Composed: SwinjectEntry {
        let parts: [SwinjectEntry]
    }

    private static func unpack(entry: SwinjectEntry) -> [SwinjectEntry] {
        if let entry = entry as? Composed { return entry.parts } else { return [entry] }
    }
}
