//
//  DeviceEndpoints.swift
//  Jyanik
//
//  Device registration API endpoints for push notifications
//

import Foundation

enum DeviceEndpoints {

    static func registerDevice(token: String, platform: DevicePlatform = .ios) -> APIEndpoint {
        APIEndpoint(
            path: "/devices",
            method: .post,
            body: RegisterDeviceBody(token: token, platform: platform)
        )
    }

    static func unregisterDevice(token: String) -> APIEndpoint {
        APIEndpoint(
            path: "/devices",
            method: .delete,
            body: UnregisterDeviceBody(token: token)
        )
    }
}

// MARK: - Device Platform

enum DevicePlatform: String, Encodable {
    case ios
    case android
}

// MARK: - Request Bodies

private struct RegisterDeviceBody: Encodable {
    let token: String
    let platform: DevicePlatform
}

private struct UnregisterDeviceBody: Encodable {
    let token: String
}
