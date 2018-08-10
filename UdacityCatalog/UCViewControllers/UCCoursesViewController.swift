//
//  UCCoursesViewController.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 05/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import UIKit

/**
 This class is responsible for showing courses list.
 */
class UCCourseListViewController: UIViewController {
    
    // MARK: - IBOutlets
    // MARK: -
    
    //Tableview for showing courses list
    @IBOutlet weak var coursesTableView: UITableView!
    
    // MARK: - Variables
    // MARK: -
    
    ///Arrayrray list with courses received
    var coursesList = NSMutableArray()
    ///Delegate helper for UCCoursesViewPresenter
    fileprivate let coursesListPresenter = UCCoursesListViewPresenter()
    
    // MARK: - Life cycle methods
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set title of the view
        self.title = StringConstants.titleCoursesView
        //Setting delegate for courseListPresenter
        self.coursesListPresenter.attachView(view: self as UCCoursesViewHelperDelegate)
        //Setting datasource and delegate for tableview
        self.coursesTableView.delegate = self
        self.coursesTableView.dataSource = self
        
        self.coursesListPresenter.getAllUdacityCourses()

    }
    
    // MARK: - Custom methods
    // MARK: -

    
    /**
     Stops spinner view on course search view.
     */
    private func hideSpinnerView() {
        UCSpinnerView().hideOverlayView(view: self.view)
    }
    
    /**
     Shows spinner view on course search view.
     */
    private func showSpinnerView() {
        UCSpinnerView().showOverlayOn(view: self.view)
    }
}

// MARK: - UITableViewDataSource
// MARK: -

extension UCCourseListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.coursesTableViewCell, for: indexPath) as! UCCustomCourseViewCell
        let courseBaseModelAtCurrentIndexPath = coursesList[indexPath.row] as? UCCoursesBaseModel
        cell.selectionStyle = .none
        cell.courseName?.attributedText = UCCustomStyle.attributedText(first: (courseBaseModelAtCurrentIndexPath?.title)!)
        cell.courseLevel?.attributedText = UCCustomStyle.attributedText(first: (courseBaseModelAtCurrentIndexPath?.level?.capitalized)!)
        return cell
    }
}

// MARK: - UITableViewDelegate
// MARK: -

extension UCCourseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MathConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSelectedCourse = self.coursesList[indexPath.row]
        let storyBoard: UIStoryboard = UdacityCatalogAppStoryboard.Main.instance
        let courseDetailsViewController = storyBoard.instantiateViewController(withIdentifier: StringConstants.courseDetailsViewController) as? UCCourseDetailViewController
        courseDetailsViewController?.currentSelectedCourseDetails = currentSelectedCourse as? UCCoursesBaseModel
        self.navigationController?.pushViewController(courseDetailsViewController!, animated: true)
    }
}

// MARK: - UCCoursesViewHelperDelegate
// MARK: -

extension UCCourseListViewController: UCCoursesViewHelperDelegate {
    
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
    
    func setCoursesList(coursesList: NSMutableArray) {
        self.coursesList.removeAllObjects()
        self.coursesList = coursesList
        DispatchQueue.main.async {
            self.coursesTableView.reloadData()
        }
    }
    
    func showErrorMessage(error: NSError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: StringConstants.ohh, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                }}))
            alert.addAction(UIAlertAction(title: StringConstants.tryAgain, style: .default, handler: { (action) in
                switch action.style{
                case .default:
                    self.coursesListPresenter.getAllUdacityCourses()
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

