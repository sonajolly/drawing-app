//
//  Messages.swift
//  DrawingAppDemo
//
//  Created by Sona Maria Jolly on 07/01/22.
//

import Foundation
import SwiftUI

struct UpsertStrokeMessage: Codable {
    let id: UUID
    let color: Stroke.Color
    let point: CGPoint
}
