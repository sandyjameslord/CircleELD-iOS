//
//  APICaller.swift
//  CircleLanguageDevelopment
//
//  Created by Sandy Lord on 7/9/21.
//

import Foundation
import UIKit

typealias APIResponses = [APIResponse]
struct JSONDataManager {
    func getDataFromCircleAPI(_ completion: @escaping ((APIResponses?) -> ())) {
        let urlPath = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/cirdata-khyvx/service/cirData/incoming_webhook/cirlAPI"
        guard let url = URL(string: urlPath) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
                let APIResponses = try JSONDecoder().decode(APIResponses.self, from: data)
                completion(APIResponses)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
}
