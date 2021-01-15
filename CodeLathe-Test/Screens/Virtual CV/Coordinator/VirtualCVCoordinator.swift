//
//  VirtualCVCoordinator.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

// Mock Candidate Data
let candidate = Candidate(
    firstName: "Alex",
    lastName: "Marchant",
    emailAddress: "myemailaddress@fake.com",
    phoneNumber: "0771112356",
    bio: "An iOS developer with a hunger to take on new challenges that provide the ability to grow, learn and make a positive difference. With a focus on self-improvement, opportunities to step out his comfort zone to develop are welcomed with open arms and shaky legs. Experience and knowledge as a business analyst, love for communicating/building relationships and a team orientated approach is brought to all teams; along with a big smile.",
    gallery: CandidateGallery(
        showcases: [
            GalleryShowcase(
                displayImageUrl: "https://www.ptfinder.app/assets/logo/icon-and-text/PTFinder-IconAndText-Black.png",
                title: "PTFinder",
                description: "Use PTFinder to discover and connect with personal trainers in your area, ensuring you know all the essential information to make the right decision. All for free.",
                projectLink: "https://apps.apple.com/us/app/id1500327189",
                technologiesUsed: ["Swift", "Firebase Platform", "Typescript/Javascript", "Mockingbird"],
                challenges: [
                    "Location-Based Data: PTFinder enables any user to find trainers in their local area, this is achieved by using their location (either the one stored on their profile or their current location) to query the database for trainer profiles within a specific distance. The challenge here was integrating into the 'GeoLocation' library and extending it to support pagination of results to ensure users got the content they needed, not everything at one time.",
                    "Remote Push Notifications: PTFinder supports a wide array of remote push notifications that are sent to other users whilst they perform various actions in the app. The challenge here was managing and setting up APN keys correctly, integrating that into the Firebase platform and client code.",
                    "Live Chat: PTFinder allows any user to chat with other users within the app. The challenge here was devising a storage technique that maximised cost efficiency for storing the messages for each chat but ensuring the chat was still fluid and fully responsive for the user."
                ]),
            GalleryShowcase(
                displayImageUrl: "https://www.",
                title: "A Great Project",
                description: "This project simply showcases what happens when an image fails to load.",
                technologiesUsed: ["Swift"],
                challenges: [
                    "Finding a URL: What happens if someone uses the URL I say will fail and it doesn't, that would be quite the predicament..."
                ]),
            GalleryShowcase(
                displayImageUrl: "https://kegeltrainer.app/assets/kegel-trainer-logo.png",
                title: "Kegel Trainer",
                description: "Experience the benefits of Kegels and make them an effortless daily habit with the Kegel Trainer app. No matter where you start from, the pre-built levels and stages help you improve your strength so you can see results faster.",
                projectLink: "https://apps.apple.com/us/app/kegel-trainer/id1451350209",
                technologiesUsed: ["Swift", "Firebase Platform", "Core Data"],
                challenges: [
                    "Leaderboards: Kegel Trainer enables a user to create an account and earn points for each workout. The difficulty with this was creating a leaderboard and ensuring it was kept up to date as required. To overcome this, the leaderboard updates once a day through a Typescript function built on the server. Client devices then query the database when looking at the leaderboard view.",
                    "Translations: I have translated the Kegel Trainer app into Spanish for fun. The challenge here was refactoring the code to support multiple languages and what the best practices were. Now, I am translating the app into French and possibly Arabic - which will have its own challenges with supporting right-to-left views.",
                    "Handling Queues: Kegel Trainer was my first ever app, therefore I everything was completely new to me. I struggled a lot with understanding and utilising DispatchQueues correctly, especially when performing animations with the correct timing.",
                    "Advertisements: Kegel Trainer has adverts built into it, so I can earn some money from people using it. The challenge here was ensuring that adverts were pre-loaded in preparation to show them since some users would complete exercises faster than others, or a users network would be slow. As a result, I integrated Google AdMob and Facebook Audience Network into the app, so if one advertising network could fill the ad, I would call on the other.",
                    "In-App Purchases (IAPs): Kegel Trainer supports IAPs, which at first only consisted of removing adverts. My initial implementation, to be honest, was pretty awful and prone to a lot of bugs. As a result, when I came back to the app to add leaderboards into the app, I re-wrote the code in order to provide a proper flow in all cases in addition to allowing the IAPs to 'fail gracefully', without creating big issues for the users experience."
                ]),
            GalleryShowcase(
            displayImageUrl: "https://phimosisstretches.com/assets/phimosis-stretches-logo.png",
            title: "Phimosis Stretches",
            description: "Phimosis Stretches is an app that helps you cure your Phimosis on your own using a variety of stretch exercises. The hardest part of curing phimosis on your own is performing the correct workouts, performing workouts for the correct amount of time for you and remembering to do the workouts consistently, this app solves those issues. By enabling you to set up customised reminders, having full control over workout settings and manging workout times for you, all you have to do is perform the stretches.",
            projectLink: "https://apps.apple.com/app/phimosis-stretcher/id1513978220",
            technologiesUsed: ["Swift", "Typescript", "Firebase Hosting"],
            challenges: [
                "Creating The Website: Phimosis Stretches was the first app that I created a website. I decided to do this to understand setting up a website correctly from the infrastructure side of things. The challenge here was playing around with the DNS records and hosting it correctly with Firebase Hosting. With this knowledge, I was able to improve the PTFinder website architecture."
            ])
        ]),
    skills: [
        CandidateSkill(skill: "Swift"),
        CandidateSkill(skill: "Javascript"),
        CandidateSkill(skill: "Jira"),
        CandidateSkill(skill: "Agile"),
        CandidateSkill(skill: "Scrum")
    ])


protocol VirtualCVCoordinatorDelegate: AnyObject {
    func didFinishViewingCV(_ virtualCVCoordinator: VirtualCVCoordinator)
}

class VirtualCVCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let urlSessionService: UrlSessionServiceProtocol
    let uiApplicationHelperService: UIApplicationHelperServiceProtocol
    
    weak var delegate: VirtualCVCoordinatorDelegate?
    
    init(
        _ navigationController: UINavigationController,
        _ urlSessionService: UrlSessionServiceProtocol,
        _ uiApplicationHelperService: UIApplicationHelperServiceProtocol) {
        
        self.navigationController = navigationController
        self.urlSessionService = urlSessionService
        self.uiApplicationHelperService = uiApplicationHelperService
        
        self.navigationController.isNavigationBarHidden = false
    }
    
    override func start() {
        showVirtualCV()
    }
    
    func showVirtualCV() {
        let virtualCVViewController = VirtualCVViewController.instantiate(storyboard: "VirtualCV")
        
        let virtualCVPresenter = VirtualCVPresenter(
            candidate: candidate,
            self.urlSessionService,
            with: virtualCVViewController,
            delegate: self)
        
        virtualCVViewController.virtualCVPresenter = virtualCVPresenter
        
        self.navigationController.pushViewController(virtualCVViewController, animated: true)
    }
    
    func showViewShowcase(_ showcase: GalleryShowcase) {
        let viewShowcaseViewController = ViewShowcaseViewController.instantiate(storyboard: "ViewShowcase")
        
        let viewShowcasePresenter = ViewShowcasePresenter(
            showcase: showcase,
            self.urlSessionService,
            self.uiApplicationHelperService,
            with: viewShowcaseViewController,
            delegate: self)
        
        viewShowcaseViewController.viewShowcasePresenter = viewShowcasePresenter
        
        self.navigationController.pushViewController(viewShowcaseViewController, animated: true)
    }
}


// MARK: - VirtualCVPresenterDelegate

extension VirtualCVCoordinator: VirtualCVPresenterDelegate {
    
}


// MARK: - ViewShowcasePresenterDelegate

extension VirtualCVCoordinator: ViewShowcasePresenterDelegate {
    func viewShowcaseInformation(_ showcase: GalleryShowcase) {
        self.showViewShowcase(showcase)
    }
    
    func goBack() {
        self.navigationController.popToRootViewController(animated: true)
    }
}


