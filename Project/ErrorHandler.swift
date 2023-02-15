//
//  ErrorHandler.swift
//  Project
//
//  Created by geotech on 07/07/2021.
//

import Foundation
enum DataError: Error {
    case failToUnwrapItems
    case invalidArrItems
}

enum ReadError: Error{
    case invalidURL
}
