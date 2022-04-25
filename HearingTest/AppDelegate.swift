//
//  AppDelegate.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Swinject
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var assembler: Assembler?

    var rootViewController: UIViewController? {
        get { return window?.rootViewController }
        set {
            window?.rootViewController = newValue
            window?.makeKeyAndVisible()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initWindow()
        initDI()
        initUI()
        
        return true
    }
    
    // - Initializing window
    private func initWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }
    
    /// - Initializing dependency injection
    private func initDI() {
        assembler = Assembler([
            /// - Scenes
            PreparationAssembly(),
            ResultAssembly(),
            SplashAssembly(),
            StatusAssembly(),
            TestAssembly(),

        ])
        assembler?.apply(assembly: ViewControllerFactoryAssembly(assembler: assembler!))
    }

    /// - Initializing UI w/ initial view controller
    func initUI() {
        let initialViewController = assembler?.resolver.resolve(SplashViewController.self)!
        rootViewController = initialViewController
    }
}
