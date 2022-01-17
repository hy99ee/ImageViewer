//
//  NetworkService.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 23.12.2021.
//

import Foundation

final class Network {
    let accesKey = "3_lbTW1lM_piVLPAo3EDhm8Ld_H-hd2TUTHBTWAfkM8"
    let secretKey = "sG7NZuKi0bOMHNl6HTHCscgu-3EONe8fJzwmOU_6iWk"
    
    struct AdressComponents{
        let schema:String
        let host:String
        let path:String
    }
    let adressComponents:AdressComponents
    init(){
        adressComponents = AdressComponents(schema: "https", host: "api.unsplash.com", path: "/photos/random")
    }
    
    func request(comp: @escaping (Data?,Error?) -> Void){
        let url = url (params: prepareParams())
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, comp: comp)
        task.resume()
    
    }
    
    private func prepareHeaders() -> [String:String]?{
        var headers = [String:String]()
        headers["Authorization"] = String("Client-ID \(accesKey)")
        return headers
    }
    private func prepareParams() -> [String:String]{
        let params:[String:String] = [:]
//        params["orientation"] = "squarish"
        
        return params
    }
    
    private func url(params : [String:String]) -> URL{
        var components = URLComponents()
        components.scheme = adressComponents.schema
        components.host = adressComponents.host
        components.path = adressComponents.path
        components.queryItems = params.map{
            URLQueryItem(name: $0, value: $1)
        }
        return components.url!
    }
    
    private func createDataTask(from request:URLRequest, comp:@escaping (Data?, Error?) -> Void) -> URLSessionDataTask{
        return URLSession.shared.dataTask(with: request) { data, responce, error in
            DispatchQueue.main.async {
                comp(data,error)
            }
        }
    }
}
