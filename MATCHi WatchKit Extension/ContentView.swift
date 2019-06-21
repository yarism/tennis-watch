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
        
        if let url = URL(string: "https://dev-smash.matchi.se/matches/hashid/6Xo") {
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
    
    var maxScore = 32
    @State var homeScore: Int = 0
    @State var awayScore: Int = 0
    @State var totalScore: Int = 0
    @State var matchId: String = "6Xo"
    
    init() {
        NetworkManager().test()
    }
    
    func scorePoint(team: String) {
        if (self.totalScore < self.maxScore) {
            if (team == "home") {
                self.homeScore = self.homeScore + 1
            }
            else if (team == "away") {
                self.awayScore = self.awayScore + 1
            }
            self.totalScore = self.totalScore + 1
        }
     }
    
    func removePoint(team: String) {
        if (team == "home" && self.homeScore > 0) {
            self.homeScore = self.homeScore - 1
            self.totalScore = self.totalScore - 1
        }
        else if (team == "away" && self.awayScore > 0) {
            self.awayScore = self.awayScore - 1
            self.totalScore = self.totalScore - 1
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {self.scorePoint(team: "home");NetworkManager().postAction(homeOpponent: self.homeScore, awayOpponent: self.awayScore, matchId: self.matchId)}) {
                    HStack {
                        Text("ARO/JOH")
                        Spacer()
                        Text("\(homeScore)")
                            .bold()
                            .font(.system(size: 30))
                    }
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.42, green: 0.79, blue: 0.27), .green]), startPoint: .top, endPoint: .bottom), cornerRadius: 20)
            }
            HStack {
                Button(action: {self.scorePoint(team: "away");NetworkManager().postAction(homeOpponent: self.homeScore, awayOpponent: self.awayScore, matchId: self.matchId)}) {
                    HStack {
                        Text("EKM/LIN")
                        Spacer()
                        Text("\(awayScore)")
                            .bold()
                            .font(.system(size: 30))
                    }
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.34, green: 0.66, blue: 0.84), Color.init(red: 0.11, green: 0.57, blue: 0.87)]), startPoint: .top, endPoint: .bottom), cornerRadius: 20)
            }
            HStack {
                Button(action: {self.removePoint(team: "home");NetworkManager().postAction(homeOpponent: self.homeScore, awayOpponent: self.awayScore, matchId: self.matchId)}) {
                    Text("-")
                        .color(.green)

                }
                TextField($matchId)
                Button(action: {self.removePoint(team: "away");NetworkManager().postAction(homeOpponent: self.homeScore, awayOpponent: self.awayScore, matchId: self.matchId)}) {
                    Text("-")
                        .color(Color.init(red: 0.11, green: 0.57, blue: 0.87))
                }
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
