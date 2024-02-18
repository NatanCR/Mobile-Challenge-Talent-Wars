//
//  SceneDelegate.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var flowCoordinator = FlowCoordinatorController?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowscene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowscene)
        flowCoordinator = FlowCoordinatorController()
        let rootVC = flowCoordinator?.start()
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

