//
//  JAvatar.swift
//  Jyanik
//
//  Avatar with async image loading and initials fallback.
//  Supports circle and squircle (rounded rectangle) shapes.
//

import SwiftUI

struct JAvatar: View {
    let url: URL?
    let initials: String
    let size: Size
    let shape: Shape

    enum Size: CGFloat {
        case small = 32
        case medium = 48
        case large = 64
        case xl = 96

        var fontSize: Font {
            switch self {
            case .small: return JFont.caption2
            case .medium: return JFont.subheadline
            case .large: return JFont.title3
            case .xl: return JFont.title
            }
        }

        /// Corner radius for squircle shape (~22% of size)
        var squircleRadius: CGFloat {
            rawValue * 0.22
        }
    }

    enum Shape {
        case circle
        case squircle
    }

    init(url: URL? = nil, initials: String = "", size: Size = .medium, shape: Shape = .circle) {
        self.url = url
        self.initials = initials
        self.size = size
        self.shape = shape
    }

    init(urlString: String?, initials: String = "", size: Size = .medium, shape: Shape = .circle) {
        if let urlString, let parsed = URL(string: urlString) {
            self.url = parsed
        } else {
            self.url = nil
        }
        self.initials = initials
        self.size = size
        self.shape = shape
    }

    var body: some View {
        imageContent
            .frame(width: size.rawValue, height: size.rawValue)
            .modifier(AvatarClipModifier(avatarShape: shape, radius: size.squircleRadius))
    }

    @ViewBuilder
    private var imageContent: some View {
        if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    initialsView
                case .empty:
                    ProgressView()
                        .tint(JColor.textTertiary)
                @unknown default:
                    initialsView
                }
            }
        } else {
            initialsView
        }
    }

    @ViewBuilder
    private var initialsView: some View {
        ZStack {
            if shape == .squircle {
                RoundedRectangle(cornerRadius: size.squircleRadius, style: .continuous)
                    .fill(JColor.primary.opacity(0.15))
            } else {
                Circle()
                    .fill(JColor.primary.opacity(0.15))
            }

            Text(initials.isEmpty ? "?" : String(initials.prefix(2)).uppercased())
                .font(size.fontSize)
                .fontWeight(.semibold)
                .foregroundStyle(JColor.primary)
        }
    }
}

// MARK: - Clip Modifier

private struct AvatarClipModifier: ViewModifier {
    let avatarShape: JAvatar.Shape
    let radius: CGFloat

    func body(content: Content) -> some View {
        switch avatarShape {
        case .circle:
            content.clipShape(Circle())
        case .squircle:
            content.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
    }
}

// MARK: - Previews

#Preview("Avatar Sizes") {
    HStack(spacing: JSpacing.md) {
        JAvatar(initials: "EM", size: .small)
        JAvatar(initials: "EM", size: .medium)
        JAvatar(initials: "EM", size: .large)
        JAvatar(initials: "EM", size: .xl)
    }
    .padding()
}

#Preview("Avatar with URL") {
    JAvatar(
        url: URL(string: "https://i.pravatar.cc/150"),
        initials: "JD",
        size: .large
    )
    .padding()
}

#Preview("Avatar Fallback") {
    JAvatar(initials: "", size: .medium)
        .padding()
}

#Preview("Avatar Squircle") {
    HStack(spacing: JSpacing.md) {
        JAvatar(initials: "EM", size: .small, shape: .squircle)
        JAvatar(initials: "EM", size: .medium, shape: .squircle)
        JAvatar(initials: "EM", size: .large, shape: .squircle)
        JAvatar(initials: "EM", size: .xl, shape: .squircle)
    }
    .padding()
}
