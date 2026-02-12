//
//  JFont.swift
//  Jyanik
//
//  Typography scale using system fonts with Dynamic Type support
//

import SwiftUI

enum JFont {

    /// 34pt bold - Hero headings
    static let largeTitle: Font = .system(.largeTitle, design: .rounded, weight: .bold)

    /// 28pt bold - Section headings
    static let title: Font = .system(.title, design: .rounded, weight: .bold)

    /// 22pt semibold - Sub-section headings
    static let title2: Font = .system(.title2, design: .rounded, weight: .semibold)

    /// 20pt semibold - Card titles
    static let title3: Font = .system(.title3, design: .rounded, weight: .semibold)

    /// 17pt semibold - Emphasized body text
    static let headline: Font = .system(.headline, design: .default, weight: .semibold)

    /// 17pt regular - Primary body text
    static let body: Font = .system(.body, design: .default, weight: .regular)

    /// 16pt regular - Supporting text
    static let callout: Font = .system(.callout, design: .default, weight: .regular)

    /// 15pt regular - Secondary content
    static let subheadline: Font = .system(.subheadline, design: .default, weight: .regular)

    /// 13pt regular - Metadata, timestamps
    static let footnote: Font = .system(.footnote, design: .default, weight: .regular)

    /// 12pt regular - Fine print, labels
    static let caption: Font = .system(.caption, design: .default, weight: .regular)

    /// 11pt regular - Badges, tags
    static let caption2: Font = .system(.caption2, design: .default, weight: .regular)

    // MARK: - Monospaced (for prices / numbers)

    /// 17pt monospaced medium - Prices
    static let price: Font = .system(.body, design: .monospaced, weight: .medium)

    /// 22pt monospaced bold - Large price display
    static let priceLarge: Font = .system(.title2, design: .monospaced, weight: .bold)

    /// 13pt monospaced regular - Small numeric data
    static let priceSmall: Font = .system(.footnote, design: .monospaced, weight: .regular)

    // MARK: - Weighted Variants

    /// Bold variant of body text
    static let bodyBold: Font = .system(.body, design: .default, weight: .bold)

    /// Medium variant of callout
    static let calloutMedium: Font = .system(.callout, design: .default, weight: .medium)

    /// Medium variant of subheadline
    static let subheadlineMedium: Font = .system(.subheadline, design: .default, weight: .medium)

    /// Semibold variant of footnote
    static let footnoteSemibold: Font = .system(.footnote, design: .default, weight: .semibold)

    /// Medium variant of caption
    static let captionMedium: Font = .system(.caption, design: .default, weight: .medium)
}
