//
//  Coordinator.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import Foundation
import UIKit

public protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
    
}
