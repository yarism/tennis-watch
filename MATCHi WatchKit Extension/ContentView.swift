//
//  ContentView.swift
//  MATCHi WatchKit Extension
//
//  Created by Joakim Johansson on 2019-06-06.
//  Copyright © 2019 Joakim Johansson. All rights reserved.
//

import SwiftUI

class NetworkManager {
    
    func test() {
        
        if let url = URL(string: "https://dev-smash.matchi.se/matches/hashid/Mk3") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("\n\nDATA: \(data)")
                print("\n\nRESPONSE: \(response)")
                print("\n\nERROR: \(error)")
                
                if let data = data {
                    if let dataString = String(data: data, encoding: .utf8) {
                        print("data string: \(dataString)")
                    }
                }
                
                }.resume()
        }
    }

    func postAction(homeOpponent: Int, awayOpponent: Int, matchId: String) {
        print(homeOpponent)
        print(awayOpponent)
        let json: [String: Any] = ["homeOpponent": homeOpponent, "awayOpponent": awayOpponent, "status": "RUNNING"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://dev-smash.matchi.se/matches/hashid/\(matchId)")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
}

struct ContentView : View {
    
    @State var homeScore: Int = 0
    @State var awayScore: Int = 0
    @State var matchId: String = "Mk3"
    
    init() {
        NetworkManager().test()
    }
    
    var body: some View {
        VStack {
            Text("\(homeScore) - \(awayScore)")
            HStack {
                Button(action: {self.homeScore = self.homeScore + 1;NetworkManager().postAction(homeOpponent: self.homeScore, awayOpponent: self.awayScore, matchId: self.matchId)}) {
                    Text("Hemma")
                        .color(.green)
                }
                Button(action: {self.awayScore = self.awayScore + 1;NetworkManager().postAction(homeOpponent: self.homeScore, awayOpponent: self.awayScore, matchId: self.matchId)}) {
                    Text("Borta")
                        .color(.blue)
                }
            }
            Button(action: {self.homeScore = 0;self.awayScore = 0}) {
                Text("Starta om")
            }
            TextField($matchId)
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
