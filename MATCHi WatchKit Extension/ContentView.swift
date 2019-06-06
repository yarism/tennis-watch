//
//  ContentView.swift
//  MATCHi WatchKit Extension
//
//  Created by Joakim Johansson on 2019-06-06.
//  Copyright © 2019 Joakim Johansson. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @State var homeScore: Int = 0
    @State var awayScore: Int = 0
    
    var body: some View {
        VStack {
            Text("\(homeScore) - \(awayScore)")
            HStack {
                Button(action: {self.homeScore = self.homeScore + 1}) {
                    Text("Hemma")
                        .color(.green)
                }
                Button(action: {self.awayScore = self.awayScore + 1}) {
                    Text("Borta")
                        .color(.blue)
                }
            }
            Button(action: {self.homeScore = 0;self.awayScore = 0}) {
                Text("Starta om")
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
