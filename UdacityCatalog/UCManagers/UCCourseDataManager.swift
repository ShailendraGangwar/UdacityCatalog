//
//  UCCoursesListManager.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 07/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import Foundation

protocol UCCoursesListUpdateDelegate: class {
    /**
     Notify about updated courses list received.
     */
    func coursesListUpdated(error: NSError?)
}

protocol UCCourseBioImageDownloadedDelegate: class {
    /**
     Notify about Bio Image downloaded.
     */
    func courseBioImageDownloaded(imageData: Data?, error: NSError?)
}

/*
 * This singleton class is reponsible
 * 1. parsing json in CoursesBaseModel
 * 2. provide global access point for courses received from API
 * 3. Notifies the Course Detail view about image download
 */
class UCCourseDataManager: NSObject {
    
    /// Array of courses
    public var courseslist = NSMutableArray()
    //delegate for UCCoursesListUpdateDelegate
    weak var coursesListUpdateDelegate: UCCoursesListUpdateDelegate?
    //delegate for UCCourseBioImageDownloadedDelegate
    weak var courseBioImageDownloadedDelegate: UCCourseBioImageDownloadedDelegate?

    /// Provides singleton access to UCCourseDataManager
    private static var sharedListManager: UCCourseDataManager = {
        let dataManager = UCCourseDataManager()
        return dataManager
    }()
    
    /**
     Provides shared instance
     
     @return UCCourseDataManager shared instance of UCCourseDataManager.
     */
    class func shared() -> UCCourseDataManager {
        return sharedListManager
    }
    
    /**
     Save courses list and notify using delegate
     
     @param newCoursesList Array of new courses received
     
     @param error error received

     */
    func saveCoursesList(newCoursesList: NSArray, error: NSError?) {
        self.courseslist.removeAllObjects()
        self.courseslist = (UCCoursesBaseModel.getCoursesArrayWithModels(coursesList: newCoursesList) as? NSMutableArray)!
        coursesListUpdateDelegate?.coursesListUpdated(error: error)
    }
    
    /**
     Bio Image downloaded and notify using delegate
     
     @param imageData image data received
     
     @param error error received

     */
    func notifyBioImageDownloaded(imageData: Data?, error: NSError?) {
        courseBioImageDownloadedDelegate?.courseBioImageDownloaded(imageData: imageData, error: error)
    }
}
