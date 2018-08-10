//
//  UCCourseDetailViewController.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 08/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import Foundation
import UIKit

/**
 This class is responsible for showing course details.
 */
class UCCourseDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    // MARK: -
    
    @IBOutlet weak var bioImageView: UIImageView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var required_knowledge: UILabel!
    @IBOutlet weak var full_course_available: UILabel!
    @IBOutlet weak var expected_duration: UILabel!
    @IBOutlet weak var expected_learning: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    // MARK: -
    
    /// Current course details
    var currentSelectedCourseDetails: UCCoursesBaseModel?
    /// delegate helper for UCCoursesListViewPresenter
    fileprivate let courseDetailPresenter = UCCoursesListViewPresenter()
    
    // MARK: - Life cycle methods
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setDefaultBackgroundColor()
        self.courseDetailPresenter.attachView(view: self as UCCoursesViewHelperDelegate)
        let backButton = UIBarButtonItem(image: UIImage(named: UCImageIconeName.backIcon),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTextOnLabelsWithCourseDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.courseDetailPresenter.detachView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let courseImgUrlStr =  currentSelectedCourseDetails?.image, (currentSelectedCourseDetails?.image?.count)! > 0 {
            self.courseDetailPresenter.downloadBioImg(imageURL: courseImgUrlStr)
        } else {
            self.bioImageView.image = UIImage(named: UCImageIconeName.imageNotFoundIcon)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: 300 + self.summary.frame.size.height + self.required_knowledge.frame.size.height)
    }

    
    // MARK: - Private methods
    // MARK: -
    
    /**
     Update all the label text with course details
     */
    func updateTextOnLabelsWithCourseDetails() {
        if (self.currentSelectedCourseDetails?.subtitle?.count)! > 0 {
            self.subtitle.attributedText = UCCustomStyle.attributedText(first: (self.currentSelectedCourseDetails?.subtitle)!)
        }

        let expectedDurationWeeks = "\(self.currentSelectedCourseDetails?.expected_duration ?? 0)"
        if (self.currentSelectedCourseDetails?.expected_duration)! > 0 {
            self.expected_duration.attributedText = UCCustomStyle.attributedText(first: StringConstants.durationString, second: (String(expectedDurationWeeks)))
        }
        if (self.currentSelectedCourseDetails?.level?.count)! > 0 {
            self.level.attributedText = UCCustomStyle.attributedText(first: (self.currentSelectedCourseDetails?.level?.capitalized)!)
        }
        if (self.currentSelectedCourseDetails?.required_knowledge?.count)! > 0 {
            self.required_knowledge.attributedText = UCCustomStyle.attributedText(first: StringConstants.requiredKnowledgeString, second: (self.currentSelectedCourseDetails?.required_knowledge)!)
        }
        if (self.currentSelectedCourseDetails?.syllabus?.count)! > 0 {
            self.summary.attributedText = UCCustomStyle.attributedText(first: StringConstants.syllabusString, second: (self.currentSelectedCourseDetails?.syllabus)!)
        }
        
    }

    /**
     Hides spinner view from course details view
     */
    private func hideSpinnerView() {
        UCSpinnerView().hideOverlayView(view: self.view)
    }
    
    /**
     Shows spinner view on course details view.
     */
    private func showSpinnerView() {
        UCSpinnerView().showOverlayOn(view: self.view)
    }
    
    private func setBioImageForCourse(imageData: Data?) {
        if imageData != nil {
            self.bioImageView.image = UIImage(data: imageData!)
        } else {
            self.bioImageView.image = UIImage(named: UCImageIconeName.imageNotFoundIcon)
        }
    }
    
    /**
     Set default color for background view
     */
    private func setDefaultBackgroundColor() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    /**
     Set navigation bar title and back button title
     */
    private func setNavigationBar() {
        self.title = self.currentSelectedCourseDetails?.title
        let backButton = UIBarButtonItem()
        backButton.title = StringConstants.backButtonTitle
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font: font])
        let boldFontAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}

extension UCCourseDetailViewController: UCCoursesViewHelperDelegate {
    func startLoading() {
        DispatchQueue.main.async {
            self.showSpinnerView()
        }
    }
    
    func finishLoading() {
        DispatchQueue.main.async {
            self.hideSpinnerView()
        }
    }

    func setBioImage(imageData: Data?, error: NSError?) {
        DispatchQueue.main.async {
            self.setBioImageForCourse(imageData: imageData)
        }
    }

}
