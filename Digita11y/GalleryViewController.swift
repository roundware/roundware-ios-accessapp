//
//  GalleryViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/24/16.
//  Copyright © 2016 Roundware. All rights reserved.
//
// with http://swiftiostutorials.com/ios-tutorial-using-uipageviewcontroller-create-content-slider-objective-cswift/
import UIKit
class GalleryViewController: BaseViewController, UIPageViewControllerDataSource {
    // MARK: - Variables

    var viewModel: GalleryViewModel!

    fileprivate var pageViewController: UIPageViewController?

    fileprivate let contentImages =
        ["play.png",
         "pause.png"];


    // MARK: Outlets and Actions

    @IBOutlet weak var pageContainer: UIView!

    @IBAction func close(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "closeGallery", sender: sender)
    }



    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = GalleryViewModel(data: self.rwData!)
        //TODOsoon get content images
        //TODOsoon combine with texts
        //TODOsoon send to pageview controller
        //TODOsoon see pageItemController

        createPageViewController()
        setupPageControl()
    }

    fileprivate func createPageViewController() {

        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self

        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }

        pageViewController = pageController
        addChildViewController(pageViewController!)
        pageContainer.addSubview(pageViewController!.view)
        pageViewController!.view.frame = pageContainer.bounds

        pageViewController!.didMove(toParentViewController: self)
    }

    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
//        appearance.backgroundColor = UIColor.darkGrayColor()
    }


    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let itemController = viewController as! PageItemController

        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let itemController = viewController as! PageItemController

        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }

        return nil
    }

    fileprivate func getItemController(_ itemIndex: Int) -> PageItemController? {

        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            return pageItemController
        }

        return nil
    }


    // MARK: - Page Indicator

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
