//
//  HTTPRequest.swift
//

import Foundation

struct RequestMultipartData {
    var data:       AnyObject
    var name:       String
    var type:       String?
    var filename:   String?
    
    init(data: AnyObject, name: String, type: String?, filename: String?) {
        self.data       = data
        self.name       = name
        self.type       = type
        self.filename   = filename
    }
    
    func data(boundary: String) -> NSData {
        var mutableData = NSMutableData()
        if let data = self.data as? NSData {
            return self.multipartFromData(boundary)
        }
        else if let stringValue = self.data as? String {
            return self.multipartFromString(boundary)
        } else {
            return NSData()
        }
    }
    
    func multipartFromString(boundary: String) -> NSData {
        var mutableData = NSMutableData()
        mutableData.appendData("--\(boundary)\r\n".data())
        var namefield = "\"" + self.name + "\""
        mutableData.appendData("Content-Disposition: form-data; name=\(namefield)\r\n\r\n".data())
        mutableData.appendData("\(self.data as! String)\r\n".data())
        return mutableData
    }
    func multipartFromData(boundary: String) -> NSData {
        var mutableData = NSMutableData()
        mutableData.appendData("--\(boundary)\r\n".data())
        var namefield = "\"" + self.name + "\""
        var filenamefield = "\"" + self.filename! + "\""
        mutableData.appendData("Content-Disposition: form-data; name=\(namefield); filename=\(filenamefield)\r\n".data())
        var typefield = "\"" + self.type! + "\""
        mutableData.appendData("Content-Type: \(typefield)\r\n\r\n".data())
        mutableData.appendData(self.data as! NSData)
        mutableData.appendData("\r\n".data())
        return mutableData
    }
}

extension String {
    func data() -> NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }
}

class Request {
    // Basic Request
    var method:                 String? = "GET"
    var url:                    NSURL?
    
    // Headers and Parameters
    var headers:                [String: String]?
    var urlParameters:          [String: String]?
    var bodyParameters:         [NSObject: AnyObject]?
    var multiparts:             [RequestMultipartData]?
    let multipartBoundary       = "__X_JOON__"
    
    // Handlers
    var unauthorizedHandler:    (() -> ())?
    var successHandler:         ((data: NSData!, response: NSURLResponse!) -> ())?
    var failureHandler:         ((data: NSData!, response: NSURLResponse!, error: NSError!) -> ())?
    
    func urlString(urlString: String) -> Self {
        self.url = NSURL(string: urlString)
        return self
    }
    
    func url(url: NSURL) -> Self {
        self.url = url
        return self
    }
    
    func method(method: String?) -> Self {
        self.method = method
        return self
    }
    
    func urlParameters(parameters: [String: String]?) -> Self {
        if var left = self.urlParameters {
            if var right = parameters {
                for (k, v) in right {
                    left.updateValue(v, forKey: k)
                }
            }
        } else {
            self.urlParameters = parameters
        }
        return self
    }
    
    func bodyParameters(parameters: [NSObject: AnyObject]?) -> Self {
        if var left = self.bodyParameters {
            if var right = parameters {
                for (k, v) in right {
                    left.updateValue(v, forKey: k)
                }
            }
        } else {
            self.bodyParameters = parameters
        }
        return self
    }
    
    func success(successHandler: ((data: NSData!, response: NSURLResponse!) -> ())?) -> Self {
        self.successHandler = successHandler
        return self
    }
    
    func failure(failureHandler: ((data: NSData!, response: NSURLResponse!, error: NSError!) -> ())?) -> Self {
        self.failureHandler = failureHandler
        return self
    }
    
    func unauthorized(unauthorizedHandler: (() -> ())?) -> Self {
        self.unauthorizedHandler = unauthorizedHandler
        return self
    }
    
    func addMultipartData(data: AnyObject, name: String, type: String?, filename: String?) -> Self {
        var multipartData = RequestMultipartData(data: data, name: name, type: type, filename: filename)
        if var multiparts = self.multiparts {
            multiparts.append(multipartData)
        } else {
            multiparts = [multipartData]
        }
        return self
    }
    
    func stringify(dictionary: [NSObject: AnyObject]) -> [String: String] {
        var newParameters: [String: String] = [:]
        for (key, value) in dictionary {
            
            if var _key = key as? String {
                switch value {
                case let _value as NSDate:
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZ"
                    newParameters[_key] = dateFormatter.stringFromDate(_value)
                case let _value as String:
                    newParameters[_key] = _value
                case let _value as Int:
                    newParameters[_key] = String(_value)
                case let _value as NSData:
                    println("Warning: Found data on Field: \(_key). Use multiparts.")
                default:
                    println("Info: Forgot to transform: \(value) on Field: \(_key)")
                }
            }
        }
        return newParameters
    }
    
    func call() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        if var URL = self.url {
            
            if var parameters = self.urlParameters {
                URL = self.NSURLByAppendingQueryParameters(URL, queryParameters: parameters)
            }
            let request = NSMutableURLRequest(URL: URL)
            
            
            if var multiparts = self.multiparts {
                // We have multipart form data, skip body parameters
                var multipartsAsData = NSMutableData()
                
                for multipart in multiparts {
                    multipartsAsData.appendData(multipart.data(self.multipartBoundary))
                }
                
                if var parameters = self.bodyParameters
                {
                    for (key, value) in self.stringify(parameters) {
                        let multipart_part = RequestMultipartData(data: value, name: key, type: nil, filename: nil)
                        multipartsAsData.appendData(multipart_part.data(self.multipartBoundary))
                    }
                }
                
                multipartsAsData.appendData("--\(self.multipartBoundary)--".data())
                multipartsAsData.appendData("\r\n".data())
                
                request.addValue("multipart/form-data; boundary=\(self.multipartBoundary)", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = multipartsAsData
            } else {
                if var parameters = self.bodyParameters
                {
                    let bodyString = self.stringFromQueryParameters(self.stringify(parameters))
                    request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                }
            }
            
            request.HTTPMethod = self.method!
            
            if var headers: [String: String] = self.headers {
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! NSHTTPURLResponse).statusCode
                    
                    NSLog("HTTP \(statusCode) on URL: \(self.url?.absoluteString)")
                    
                    // Unauthorized
                    if statusCode == 401 {
                        if var _unauthorizedHandler = self.unauthorizedHandler {
                            _unauthorizedHandler()
                        }
                    } else {
                        if var handler = self.successHandler {
                            handler(data: data, response: response)
                        }
                    }
                }
                else {
                    // Failure
                    println("URL Session Task Failed: %@", error.localizedDescription);
                    if var handler = self.failureHandler {
                        handler(data: data, response: response, error: error)
                    }
                }
            })
            task.resume()
        }
    }
    
    func stringFromQueryParameters(queryParameters: [String: String]) -> String {
        var parts: [String] = []
        for (name, value) in queryParameters {
            var part = NSString(format: "%@=%@",
                name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!,
                value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            parts.append(part as String)
        }
        return "&".join(parts)
    }
    
    func NSURLByAppendingQueryParameters(URL: NSURL!, queryParameters: [String: String]) -> NSURL {
        let URLString: NSString = NSString(format: "%@?%@", URL.absoluteString!, self.stringFromQueryParameters(queryParameters))
        return NSURL(string: URLString as String)!
    }
    
    class func dictionaryFromJSONString(data: NSData) -> AnyObject? {
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
    }
}