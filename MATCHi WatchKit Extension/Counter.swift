//
//  Counter.swift
//  MATCHi WatchKit Extension
//
//  Created by Joakim Johansson on 2019-06-09.
//  Copyright © 2019 Joakim Johansson. All rights reserved.
//

import Foundation

class Counter {
    var count = 0
    func increment() {
        print(count)
        count += 1
        let url = URL(string: "http://dev-smash.wfbt6q4w6y.eu-west-1.elasticbeanstalk.com/matches/hashid/Mk3")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func fetchData() {
        let sing = "hej"
        guard let url = URL(string: "https://aztro.sameerkumar.website/?sign=\(sing)&day=today") else { return }
        
        print("https://aztro.sameerkumar.website/?sign=\(sing)&day=today")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                print("hurra")
            } else {
                print("vacio")
            }
            }.resume()
    }
    

    func match() {
        let config = URLSessionConfiguration.default
        //let config = URLSessionConfiguration.background(withIdentifier: String)
        let session = URLSession(configuration: config)

        let url = URL(string: "https://httpbin.org/anything")!
        let task = session.dataTask(with: url) { data, response, error in

            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {	
                print("No data")
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            print("gotten json response dictionary is \n \(json)")
            // update UI using the response here
        }

        // execute the HTTP request
        task.resume()
    }
    
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}
