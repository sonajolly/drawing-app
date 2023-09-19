//
//  DrawTogether.swift
//  DrawingAppDemo
//
//  Created by Sona Maria Jolly on 07/01/22.
//

import Foundation
import GroupActivities

struct DrawTogether: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = NSLocalizedString("Draw Together", comment: "Title of group Activity")
        metadata.type = .generic
        return metadata
    }
}
