//
//  JAvatar.swift
//  Jyanik
//
//  Circular avatar with async image loading and initials fallback
//

import SwiftUI

struct JAvatar: View {
    let url: URL?
    let initials: String
    let size: Size

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
    }

    init(url: URL? = nil, initials: String = "", size: Size = .medium) {
        self.url = url
        self.initials = initials
        self.size = size
    }

    init(urlString: String?, initials: String = "", size: Size = .medium) {
        if let urlString, let parsed = URL(string: urlString) {
            self.url = parsed
        } else {
            self.url = nil
        }
        self.initials = initials
        self.size = size
    }

    var body: some View {
        Group {
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
        .frame(width: size.rawValue, height: size.rawValue)
        .clipShape(Circle())
    }

    private var initialsView: some View {
        ZStack {
            Circle()
                .fill(JColor.primary.opacity(0.15))

            Text(initials.isEmpty ? "?" : String(initials.prefix(2)).uppercased())
                .font(size.fontSize)
                .fontWeight(.semibold)
                .foregroundStyle(JColor.primary)
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
