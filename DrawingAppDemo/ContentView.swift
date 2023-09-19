//
//  ContentView.swift
//  DrawingAppDemo
//
//  Created by Sona Maria Jolly on 07/01/22.
//

import SwiftUI
import GroupActivities

struct ContentView: View {
    @StateObject var canvas = Canvas()
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                StrokeColorIndicator(color: canvas.strokeColor.uiColor)
            }.padding()
            CanvasView(canvas: canvas)
            ControlBar(canvas: canvas).padding()
        }.task {
            for await session in DrawTogether.sessions() {
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


