import Testing
@testable import Recap

@Suite("RecapScreenAccessibility Tests")
struct RecapScreenAccessibilityTests {
    @Test("Default mapping is release pages only")
    func defaultReleasePagesOnly() {
        let pages = RecapScreenAccessibility.default.pages(
            includeLeading: false,
            releaseTitles: ["Launch", "Fixes"],
            includeTrailing: false
        )

        #expect(pages.map(\.identifier) == [
            "recap.page.release0",
            "recap.page.release1"
        ])
        #expect(pages.map(\.title) == ["Launch", "Fixes"])
    }

    @Test("Configured leading and trailing wrap releases in display order")
    func configuredLeadingAndTrailing() {
        let accessibility = RecapScreenAccessibility(
            leadingPage: .init(title: "Roadmap", identifier: "recap.page.ratings"),
            trailingPage: .init(title: "Support", identifier: "recap.page.spotlight")
        )
        let pages = accessibility.pages(
            includeLeading: true,
            releaseTitles: ["1.2 Features", "1.1 Fixes"],
            includeTrailing: true
        )

        #expect(pages.map(\.identifier) == [
            "recap.page.ratings",
            "recap.page.release0",
            "recap.page.release1",
            "recap.page.spotlight"
        ])
        #expect(pages.map(\.title) == [
            "Roadmap",
            "1.2 Features",
            "1.1 Fixes",
            "Support"
        ])
    }

    @Test("Unconfigured leading and trailing use package default identifiers")
    func unconfiguredLeadingAndTrailingDefaults() {
        let pages = RecapScreenAccessibility.default.pages(
            includeLeading: true,
            releaseTitles: ["Launch"],
            includeTrailing: true
        )

        #expect(pages.map(\.identifier) == [
            RecapScreenAccessibility.defaultLeadingIdentifier,
            "recap.page.release0",
            RecapScreenAccessibility.defaultTrailingIdentifier
        ])
        #expect(pages[0].title.isEmpty)
        #expect(pages[1].title == "Launch")
        #expect(pages[2].title.isEmpty)
    }

    @Test("Omitting the leading page keeps release identifiers at zero")
    func omittedLeadingKeepsReleaseIndex() {
        let pages = RecapScreenAccessibility(
            trailingPage: .init(title: "Support", identifier: "recap.page.spotlight")
        ).pages(
            includeLeading: false,
            releaseTitles: ["Launch"],
            includeTrailing: true
        )

        #expect(pages.map(\.identifier) == [
            "recap.page.release0",
            "recap.page.spotlight"
        ])
        #expect(pages.map(\.title) == ["Launch", "Support"])
    }

    @Test("Custom release identifier prefix")
    func customReleaseIdentifierPrefix() {
        let accessibility = RecapScreenAccessibility(releaseIdentifierPrefix: "whatsnew.page.")

        #expect(accessibility.releaseIdentifier(at: 0) == "whatsnew.page.0")
        #expect(accessibility.releaseIdentifier(at: 3) == "whatsnew.page.3")
        #expect(
            accessibility.resolvedRelease(title: "Launch", index: 2)
            == RecapScreenPageAccessibility(title: "Launch", identifier: "whatsnew.page.2")
        )
    }

    @Test("Absent leading or trailing views resolve to nil")
    func absentPagesAreNil() {
        let accessibility = RecapScreenAccessibility(
            leadingPage: .init(title: "Roadmap", identifier: "recap.page.leading"),
            trailingPage: .init(title: "Support", identifier: "recap.page.trailing")
        )

        #expect(accessibility.resolvedLeading(isPresent: false) == nil)
        #expect(accessibility.resolvedTrailing(isPresent: false) == nil)
        #expect(accessibility.pages(includeLeading: false, releaseTitles: [], includeTrailing: false).isEmpty)
    }
}
