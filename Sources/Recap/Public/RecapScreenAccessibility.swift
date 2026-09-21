import Foundation

/// Accessibility title and identifier for one `RecapScreen` pager page.
public struct RecapScreenPageAccessibility: Equatable, Sendable {
    /// Spoken label for the page container. An empty title omits `accessibilityLabel`
    /// so VoiceOver can still enter and read the page's own content.
    public var title: String
    /// Accessibility identifier for the page container.
    public var identifier: String

    public init(title: String, identifier: String) {
        self.title = title
        self.identifier = identifier
    }
}

/// App-supplied titles and identifiers for `RecapScreen` pager pages.
///
/// Release pages always use `Release.title` and `releaseIdentifierPrefix` + index
/// (`recap.page.release0`, `recap.page.release1`, …). Leading and trailing pages
/// are optional so the package stays app-agnostic.
public struct RecapScreenAccessibility: Equatable, Sendable {
    public static let defaultLeadingIdentifier = "recap.page.leading"
    public static let defaultTrailingIdentifier = "recap.page.trailing"
    public static let defaultReleaseIdentifierPrefix = "recap.page.release"

    public static let `default` = RecapScreenAccessibility()

    public var leadingPage: RecapScreenPageAccessibility?
    public var trailingPage: RecapScreenPageAccessibility?
    public var releaseIdentifierPrefix: String

    public init(
        leadingPage: RecapScreenPageAccessibility? = nil,
        trailingPage: RecapScreenPageAccessibility? = nil,
        releaseIdentifierPrefix: String = RecapScreenAccessibility.defaultReleaseIdentifierPrefix
    ) {
        self.leadingPage = leadingPage
        self.trailingPage = trailingPage
        self.releaseIdentifierPrefix = releaseIdentifierPrefix
    }

    public func releaseIdentifier(at index: Int) -> String {
        "\(releaseIdentifierPrefix)\(index)"
    }

    /// Pages in display order: optional leading, each release, optional trailing.
    public func pages(
        includeLeading: Bool,
        releaseTitles: [String],
        includeTrailing: Bool
    ) -> [RecapScreenPageAccessibility] {
        var result: [RecapScreenPageAccessibility] = []
        if let leading = resolvedLeading(isPresent: includeLeading) {
            result.append(leading)
        }
        for (index, title) in releaseTitles.enumerated() {
            result.append(resolvedRelease(title: title, index: index))
        }
        if let trailing = resolvedTrailing(isPresent: includeTrailing) {
            result.append(trailing)
        }
        return result
    }

    public func resolvedLeading(isPresent: Bool) -> RecapScreenPageAccessibility? {
        guard isPresent else { return nil }
        return leadingPage ?? RecapScreenPageAccessibility(
            title: "",
            identifier: Self.defaultLeadingIdentifier
        )
    }

    public func resolvedTrailing(isPresent: Bool) -> RecapScreenPageAccessibility? {
        guard isPresent else { return nil }
        return trailingPage ?? RecapScreenPageAccessibility(
            title: "",
            identifier: Self.defaultTrailingIdentifier
        )
    }

    public func resolvedRelease(title: String, index: Int) -> RecapScreenPageAccessibility {
        RecapScreenPageAccessibility(title: title, identifier: releaseIdentifier(at: index))
    }
}
