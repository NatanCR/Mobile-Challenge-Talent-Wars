//
//  SceneDelegate.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: FlowCoordinatorController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        coordinator = FlowCoordinatorController(navigationController: navigationController)
        coordinator?.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        window?.rootViewController = navigationController
        window?.windowScene = windowScene
    }
}

