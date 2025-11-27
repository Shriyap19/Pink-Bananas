
//
//  OnboardingViewModel.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 9/30/25.
//

import Foundation

extension LoginView {
    func logIn(user:LoggingInUser)  {
        
        guard let url = URL(string: "http://127.0.0.1:8000") else //varible for the url link
        {return}
        
        var request = URLRequest(url:url) //varible for reqest asking for somthing, from the database
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // I thinkn to add to database
        
        do {
            let jsonData = try JSONEncoder().encode(user) //turn into json code
            
            request.httpBody = jsonData //attaches JSON data to the message that goes to server
            
            URLSession.shared.dataTask(with: request){ //sending message to the server
                data, response, error in if let error = error{
                    print(error)
        //            DispatchQueue.main.async {
          //              self.alert_message = "Failed to send feedback: \(error.localizedDescription)"
            //            self.show_alert = true
              //      }
                    return
                }
                //waiting for server to respond after message was sent
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else{
                                    DispatchQueue.main.async{
                                        //self.alert_message = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                                        //self.show_alert = true
                                        print("Failed with status code")
                                    }
                                    return
                                }
                
                
            }.resume()
            
            
        } catch {
            print("error uploading user data")
        }
    }
}


