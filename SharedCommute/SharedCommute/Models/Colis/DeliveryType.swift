//
//  DeliveryType.swift
//  project
//
//  Created by Apple Esprit on 28/11/2023.
//

import Foundation

enum DeliveryType: Int, CaseIterable, Identifiable{
    case express
    case normal
    
    var id: Int {return rawValue}
    
    var description: String {
        switch self{
        case .normal: return "Normal Delivery"
        case .express: return "express Delivery"
        }
    }
    
    var imaageName: String{
        switch self{
        case .normal: return "normal delivery"
        case .express: return "express delivery"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .express: return 2
        case .normal: return 1
        }
    }
    func computePrice(for distanceInMeters: Double) -> Double {
        switch self {
        case .normal: return distanceInMeters * 1.5 + baseFare
        case .express: return distanceInMeters * 1.75 + baseFare

        }
    }
}
