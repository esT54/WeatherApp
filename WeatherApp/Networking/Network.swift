//
//  Network.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 02.02.2022.
//

import Foundation

class Network {
    private init() {}
    static let share = Network()
    
    private lazy var urLSession = URLSession(configuration: .default)
    
//    func request<T: Decodable>(api: Api) -> [T] {
//        let dataTask = urLSession.dataTask(with: api.getUrl()) { data, _, error in
//            var result = [T]()
//            guard error == nil else { print(error!.localizedDescription); return}
//            if let data = data {
//                do {
//                    if let json = try JSONDecoder().decode([T]?.self, from: data) {
//                        result = json
//                    } else {
//                        print("error json decode")
//                    }
//                }
//                catch {
//                    print(String(describing: error))
//                }
//            }
//            return result
//        }
//        dataTask.resume()
//    }
    func requestToApi<T: Decodable>(api: Api, completionHandler: @escaping (T)->Void ) {
        guard let url = api.getUrl() else { return }
        let dataTask = urLSession.dataTask(with: url) { data, _, error in
            guard error == nil else { print(String(describing: error)); return }
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(json)
                } catch {
                    print(String(describing: error))
                }
            }
        }
        dataTask.resume()
    }
}
