//
//  Service.swift
//  MATCHi WatchKit Extension
//
//  Created by Joakim Johansson on 2019-06-08.
//  Copyright © 2019 Joakim Johansson. All rights reserved.
//

import Foundation

func getMatch() {
    let url = URL(string: "http://dev-smash.wfbt6q4w6y.eu-west-1.elasticbeanstalk.com/matches/hashid/Mk3")!
    
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data else { return }
        print(String(data: data, encoding: .utf8)!)
    }
    
    task.resume()
}
