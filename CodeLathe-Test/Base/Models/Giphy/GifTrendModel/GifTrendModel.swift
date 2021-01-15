//
//  GifTrendModel.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

class GifTrendModel: Codable {
    var data: [DataModel]?
    var meta: MetaModel?
    var pagination: PaginationModel?
}
