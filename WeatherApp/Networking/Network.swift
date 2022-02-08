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
    
    func requestToApi<T: Decodable>(api: Api, completionHandler: @escaping (Result<T,Error>)->Void ) {
        guard let url = api.getUrl() else { return }
        let dataTask = urLSession.dataTask(with: url) { data, _, error in
            guard error == nil else { completionHandler(.failure(error!)); return }
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(json))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
