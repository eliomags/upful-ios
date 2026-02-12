//
//  JSpacing.swift
//  Jyanik
//
//  Spacing and corner radius design tokens
//

import SwiftUI

// MARK: - Spacing Scale

enum JSpacing {
    /// 2pt
    static let xxxs: CGFloat = 2

    /// 4pt
    static let xxs: CGFloat = 4

    /// 8pt
    static let xs: CGFloat = 8

    /// 12pt
    static let sm: CGFloat = 12

    /// 16pt
    static let md: CGFloat = 16

    /// 24pt
    static let lg: CGFloat = 24

    /// 32pt
    static let xl: CGFloat = 32

    /// 48pt
    static let xxl: CGFloat = 48

    /// 64pt
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius Scale

enum JRadius {
    /// 8pt - Buttons, small cards
    static let small: CGFloat = 8

    /// 12pt - Cards, inputs
    static let medium: CGFloat = 12

    /// 16pt - Large cards, modals
    static let large: CGFloat = 16

    /// 20pt - Bottom sheets
    static let xl: CGFloat = 20

    /// 999pt - Pill shapes, badges
    static let pill: CGFloat = 999
}
