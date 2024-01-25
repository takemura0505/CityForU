//
//  Prefecture.swift
//  CityForU
//
//  Created by 竹村はるうみ on 2024/01/25.
//

import UIKit

struct Prefecture: Codable {
    var name: String
    var capital: String
    var citizenDay: CitizenDay?
    var hasCoastLine: Bool
    var logoUrl: String
    var brief: String

    enum CodingKeys: String, CodingKey {
        case name, capital, citizenDay, hasCoastLine, logoUrl, brief
    }

    struct CitizenDay: Codable {
        var month: Int
        var day: Int
    }
}
