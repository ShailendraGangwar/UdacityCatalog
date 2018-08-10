//
//  UCConstants.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 06/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import Foundation
import UIKit

struct StringConstants {
    static let titleCoursesView = "Udacity Catalog"
    static let storyboardName = "Main"
    static let coursesTableViewCell = "coursesTableViewCell"
    static let backButtonTitle = "Back"
    static let courseDetailsViewController = "UCCourseDetailViewController"
    static let durationString = "Duration in weeks: "
    static let requiredKnowledgeString = "Required Knowledge:\n"
    static let syllabusString = "Syllabus:\n"
    static let ohh = "Ohh"
    static let ok = "OK"
    static let tryAgain = "Try again"
}

struct UCCoursesRestAPI {
    static let url = "https://www.udacity.com/public-api/v0/courses"
}

struct UCCoursesBaseModelKeysConstants {
    static let title = "title"
    static let subtitle = "subtitle"
    static let required_knowledge = "required_knowledge"
    static let full_course_available = "full_course_available"
    static let syllabus = "syllabus"
    static let expected_duration = "expected_duration"
    static let expected_learning = "expected_learning"
    static let project_name = "project_name"
    static let level = "level"
    static let image = "image"
    static let banner_image = "banner_image"

}

struct UCImageIconeName {
    static let backIcon = "backIcon"
    static let imageNotFoundIcon = "imageNotFoundIcon"
    
}
enum MathConstants {
    static let rowHeight: CGFloat  = 70
    static let overlayViewTag: Int = 2222
}

enum UdacityCatalogAppStoryboard: String {
    case Main = "Main"
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
