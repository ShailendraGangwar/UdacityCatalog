//
//  UCCoursesBaseModel.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 07/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import Foundation

public class UCCoursesBaseModel {
    var title : String?
    var subtitle : String?
    var required_knowledge : String?
    var full_course_available : Bool?
    var syllabus : String?
    var expected_duration : Int?
    var expected_learning : String?
    var project_name : String?
    var level : String?
    var image : String?
    var banner_image : String?
    
    /**
     Initializer method.
     
     @param dictionary dictionary of courses
     */
    init(dictionary: Dictionary<String, Any>) {
        self.title = dictionary[UCCoursesBaseModelKeysConstants.title] as? String
        self.subtitle = dictionary[UCCoursesBaseModelKeysConstants.subtitle] as? String
        self.required_knowledge = dictionary[UCCoursesBaseModelKeysConstants.required_knowledge] as? String
        self.full_course_available = dictionary[UCCoursesBaseModelKeysConstants.full_course_available] as? Bool
        self.syllabus = dictionary[UCCoursesBaseModelKeysConstants.syllabus] as? String
        self.expected_duration = dictionary[UCCoursesBaseModelKeysConstants.expected_duration] as? Int
        self.expected_learning = dictionary[UCCoursesBaseModelKeysConstants.expected_learning] as? String
        self.project_name = dictionary[UCCoursesBaseModelKeysConstants.project_name] as? String
        self.level = dictionary[UCCoursesBaseModelKeysConstants.level] as? String
        self.image = dictionary[UCCoursesBaseModelKeysConstants.image] as? String

    }
    
    /**
     Converts each item in courses list to courses base model
     
     @param countriesList Array of courses
     
     @return Array of courses base models
     */
    public class func getCoursesArrayWithModels(coursesList: NSArray) -> NSArray {
        let coursesArray = NSMutableArray()
        for course in coursesList {
            coursesArray.add(UCCoursesBaseModel(dictionary: (course as? Dictionary)!))
        }
        return coursesArray
    }
    
}
