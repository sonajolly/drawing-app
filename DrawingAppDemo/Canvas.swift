//
//  Canvas.swift
//  DrawingAppDemo
//
//  Created by Sona Maria Jolly on 07/01/22.
//

import Foundation
import Combine
import SwiftUI
import GroupActivities

class Canvas: ObservableObject {
    @Published var strokes = [Stroke]()
    @Published var activeStroke: Stroke?
    let strokeColor = Stroke.Color.random()
    
    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task.Handle<Void, Never>>()
    
    func addPointToActiveStroke(_ point: CGPoint) {
        let stroke: Stroke
        if let activeStroke = activeStroke {
            stroke = activeStroke
        } else {
            stroke = Stroke(color: strokeColor)
            activeStroke = stroke
        }
        stroke.points.append(point)
        
        if let messenger = messenger {
            async {
                do {
                    try await messenger.send(UpsertStrokeMessage(id: stroke.id, color: stroke.color, point: point))
                } catch {
                    
                }
            }
        }
    }
    
    func finishStrojer() {
        guard let activeStroke = activeStroke else {return}
        strokes.append(activeStroke)
        self.activeStroke = nil
    }
    
    func reset() {
        strokes = []
    }
    
    var pointCount: Int {
        return strokes.reduce(0) { $0 + $1.points.count}
    }
    
    @Published var groupSession: GroupSession<DrawTogether>?
    var messenger: GroupSessionMessenger?
    
    func configureGroupSession(_ groupSession: GroupSession<DrawTogether>) {
        reset()
        
        self.groupSession = groupSession
        let messenger = GroupSessionMessenger(session: groupSession)
        self.messenger = messenger
        
        let strokeTask = detach { [weak self] in
            for await (message, _) in messenger.messages(of: UpsertStrokeMessage.self) {
                await self?.handle(message)
            }
        }
        tasks.insert(strokeTask)
        
        groupSession.join()
    }
    
    func handle(_ message: UpsertStrokeMessage) {
        if let stroke = strokes.first(where: {$0.id == message.id}) {
            stroke.points.append(message.point)
        } else {
            let stroke = Stroke(id: message.is, color: message.color)
            stroke.points.append(message.point)
            strokes.append(stroke)
        }
    }
}

import SwiftUI
struct ControlBar: View {
    @ObservedObject var canvas: Canvas
    
    var body: some View {
        HStack {
            CapsuleButton {
                DrawTogether().activate()
            } label: {
                Image(systemName: "person.2.fill")
            }
            
            Spacer()
            
            CapsuleButton {
                canvas.reset()
            } label: {
                Image(systemName: "trash.fill")
            }
        }
    }
}
