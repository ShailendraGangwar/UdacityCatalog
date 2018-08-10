//
//  UCCoursesAPIServiceManager.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 06/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import Foundation


/*
 * This class is responsible for
 * 1. making http request
 * 2. Parse data using Jsonserialization
 * 3. Handle http url response
 */
class UCCoursesAPIServiceManager {
    
    /// Provides singleton sccess to UCCoursesAPIServiceManager
    private static var sharedServiceManager: UCCoursesAPIServiceManager = {
        let serviceManager = UCCoursesAPIServiceManager()
        return serviceManager
    }()
    
    /**
     Returns shared instance of UCCoursesAPIServiceManager
     
     @return UCCoursesAPIServiceManager Shared instance.
     */
    class func shared() -> UCCoursesAPIServiceManager {
        return sharedServiceManager
    }
    
    /**
     Get all courses using NSURLSession
     */
    func getAllUdacityCourses() {
        let config = URLSessionConfiguration.default // Session Configuration
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: UCCoursesRestAPI.url)!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                UCCourseDataManager.shared().saveCoursesList(newCoursesList: [], error: error! as NSError)
                print(error!.localizedDescription)
            } else {
                self.parseDataWith(response: response!, data: data!)
            }
        })
        task.resume()
    }
    
    /**
     Download bio image for course
     
     @param imageURL Image URL
     */
    func downloadBioImage(imageURL: String) {
        let config = URLSessionConfiguration.default // Session Configuration
        config.timeoutIntervalForRequest = 10.0
        config.timeoutIntervalForResource = 10.0
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: imageURL)
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if error != nil {
                UCCourseDataManager.shared().notifyBioImageDownloaded(imageData: nil, error: error! as NSError)
            } else {
                self.bioImageWith(response: response!, data: data!)
            }
        })
        task.resume()
    }
    
    /**
     Parse the data received from REST API based on URL response. It also asks UCCoursesListManager to model the data recieved.
     
     @param response URL Response
     
     @param data Data received
     */
    func parseDataWith(response: URLResponse, data: Data) {
        let httpResponse = response as? HTTPURLResponse
        switch(httpResponse?.statusCode) {
        case 200?:
            do {
                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                UCCourseDataManager.shared().saveCoursesList(newCoursesList: someDictionaryFromJSON?.value(forKey: "courses") as! NSArray, error: nil)
            } catch {
                print("error in JSONSerialization")
            }
        case 404?:
            print("Not found")
            UCCourseDataManager.shared().saveCoursesList(newCoursesList: [], error: nil)
        default:
            print("Nothing")
        }
    }
    
    /**
     Receive data received from REST API based on URL response. It also asks UCCoursesListManager to notify the image recieved.
     
     @param response URL Response
     
     @param data Data received
     */
    func bioImageWith(response: URLResponse, data: Data) {
        let httpResponse = response as? HTTPURLResponse
        switch(httpResponse?.statusCode) {
        case 200?:
            UCCourseDataManager.shared().notifyBioImageDownloaded(imageData: data, error: nil)
        case 404?:
            let userInfo: [String : Any] = [NSLocalizedDescriptionKey :
                NSLocalizedString("Not Found", value: "Not Found", comment: "")]
            let error : NSError = NSError(domain: "ImageNotFound", code: 404, userInfo: userInfo)
            UCCourseDataManager.shared().notifyBioImageDownloaded(imageData: nil, error: error)
        default:
            print("Nothing")
        }
    }
}
