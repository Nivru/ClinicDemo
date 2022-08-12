//
//  SettingModel.swift
//  ClinicDemo
//
//  Created by Nivrutti on 12/08/22.
//

import Foundation

// MARK: - SettingModel
struct SettingModel: Decodable {
    let settings: Settings
}

// MARK: - Settings
struct Settings: Decodable {
    let isChatEnabled, isCallEnabled: Bool
    let workHours: String
}
