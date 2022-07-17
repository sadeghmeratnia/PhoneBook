//
//  NetworkAgent.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit
import RxSwift

class NetworkAgent: NSObject {
    private var decoder: JSONDecoder!
    private var encoder: JSONEncoder!
    private var session: URLSession!
    private var baseURL: URL?
    
    init(baseUrl: URL? = URL(string: "https://stdevtask3-0510.restdb.io/rest/")) {
        super.init()
        self.baseURL = baseUrl
        self.setupURLSessionConfiguration()
        self.setupDecoder()
        self.setupEncoder()
    }
    
    func setupURLSessionConfiguration() {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = false
        config.httpCookieAcceptPolicy = .never
        config.networkServiceType = .responsiveData
        config.timeoutIntervalForRequest = 30
        config.shouldUseExtendedBackgroundIdleMode = true
        self.session = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
    }
    
    func setupDecoder() {
        let decoder =  JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        decoder.dateDecodingStrategy = .millisecondsSince1970
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "Infinity",
            negativeInfinity: "-Infinity",
            nan: "NaN")
        
        self.decoder = decoder
    }
    
    func setupEncoder() {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        self.encoder = encoder
    }
    
    func request<R: APIRouter>(_ router: R) -> Observable<R.ResponseType?> {
        let decodableType = type(of: router)
        
        do {
            guard let url = URL(string: decodableType.path, relativeTo: self.baseURL) else {
                throw NetworkError.parsing
            }
                
            var request = URLRequest(url: url)
            request.httpMethod = decodableType.method.rawValue
            switch decodableType.requestType {
            case .jsonBody:
                if let data = router.requestBody?.toJSON() {
                    request.httpBody = data
                }
            case .urlQuery:
                if let parameters = router.queryParams {
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                    
                    components?.queryItems = parameters.compactMapValues({ $0 }).map { key, value in
                        URLQueryItem(name: key, value: value)
                    }
                    request = URLRequest(url: components?.url ?? url)
                }
            case .httpHeader:
                request.httpBody = nil
            default:
                fatalError()
            }
            
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            #warning("Insert your token here")
            let token = "YOUR_TOKEN"
            request.addValue(token, forHTTPHeaderField: "x-apikey")
            
            return run(request)
        } catch {
            return Observable<R.ResponseType?>.create { observer in
                observer.onError(error)
                return Disposables.create()
            }
            .observe(on: MainScheduler.instance)
        }
    }
    
    func run<C: Codable>(_ request: URLRequest) -> Observable<C?> {
        return Observable<C?>
            .create { observer in
                let task = self.session.dataTask(with: request) { (data1, response, error) in
                    do {
                        if let error = error { throw error }
                        guard let response = response as? HTTPURLResponse else { throw NetworkError.network }
                        
                        let data = try self.validate(response: response, data: data1)
                        let model = try self.decoder.decode(C.self, from: data)
                        
                        observer.onNext(model)
                    } catch {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
        }
        .observe(on: MainScheduler.instance)
    }
    
    private func validate(response: URLResponse?, data: Data?) throws -> Data {
        guard let response = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        
        switch response.statusCode {
        case 500:
            throw NetworkError.network
        case 401:
            throw NetworkError.authorization
        case 400:
            throw NetworkError.badRequest()
        default:
            break
        }
        
        guard let data = data else { throw NetworkError.invalidResponse }
        
        return data
    }
}
