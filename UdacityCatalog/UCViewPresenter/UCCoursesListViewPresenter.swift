//
//  UCCoursesViewPresenter.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 08/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import Foundation

@objc protocol UCCoursesViewHelperDelegate: NSObjectProtocol {
    /**
     Show the spinner to show something happening on background
     */
    func startLoading()
    
    /**
     Stop the spinner to show background task is over
     */
    func finishLoading()
    
    /**
     Provides the list of courses array
     
     @param coursesList Array of courses.
     */
    @objc optional func setCoursesList(coursesList: NSMutableArray)
    
    /**
     Provides bio image
     
     @param imageData image data.
     */
    @objc optional func setBioImage(imageData: Data?, error: NSError?)
    
    /**
     Provides the list of courses array
     
     @param coursesList Array of courses.
     */
    @objc optional func showErrorMessage(error: NSError)

}

class UCCoursesListViewPresenter {
    
    ///Delegate helper for coursesListUpdateDelegate
    var coursesListUpdateDelegate = UCCourseDataManager.shared()
    ///Delegate helper for courses view
    weak fileprivate var coursesListView: UCCoursesViewHelperDelegate?
    
    /**
     Initializer method
     */
    init() {
        self.coursesListUpdateDelegate.coursesListUpdateDelegate = self
        self.coursesListUpdateDelegate.courseBioImageDownloadedDelegate = self
    }
    
    /**
     Setting the view delegate.
     
     @param view delegate from delegator
     */
    func attachView(view: UCCoursesViewHelperDelegate) {
        self.coursesListView = view
    }
    
    /**
     Removing the view delegate.
     */
    func detachView() {
        self.coursesListView = nil
    }
    
    /**
     Request API service to get all courses.
    */
    func getAllUdacityCourses() {
        self.coursesListView?.startLoading()
        UCCoursesAPIServiceManager.shared().getAllUdacityCourses()
    }
    
    /**
     Download the Course image.
     
     @param url SVG flag image url
     
     @param onView View on which svg image should be placed.
     */
    func downloadBioImg(imageURL: String) {
        self.coursesListView?.startLoading()
        UCCoursesAPIServiceManager.shared().downloadBioImage(imageURL: imageURL)
    }
}

extension UCCoursesListViewPresenter: UCCoursesListUpdateDelegate {
    func coursesListUpdated(error: NSError?) {
        self.coursesListView?.finishLoading()
        self.coursesListView?.setCoursesList!(coursesList: UCCourseDataManager.shared().courseslist)
        if error != nil {
            self.coursesListView?.showErrorMessage!(error: error!)
        }
    }
}

extension UCCoursesListViewPresenter: UCCourseBioImageDownloadedDelegate {
    func courseBioImageDownloaded(imageData: Data?, error: NSError?) {
        self.coursesListView?.finishLoading()
        self.coursesListView?.setBioImage!(imageData: imageData, error: error)
    }
}
