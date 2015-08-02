//
//  SwinjectStoryboard.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 8/1/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import AppKit

public class SwinjectStoryboard: _SwinjectStoryboardBase {
    private var container: Container!
    
    public class func create(name name: String, bundle storyboardBundleOrNil: NSBundle?) -> SwinjectStoryboard {
        return SwinjectStoryboard.create(name: name, bundle: storyboardBundleOrNil, container: Container.defaultContainer)
    }
    
    public class func create(name name: String, bundle storyboardBundleOrNil: NSBundle?, container: Container) -> SwinjectStoryboard {
        // Use this factory method to create an instance because the initializer of NSStoryboard is "not inherited".
        let storyboard = SwinjectStoryboard._create(name, bundle: storyboardBundleOrNil)
        storyboard.container = container
        return storyboard
    }
    
    public override func instantiateControllerWithIdentifier(identifier: String) -> AnyObject {
        let controller = super.instantiateControllerWithIdentifier(identifier)
        injectDependency(controller)
        return controller
    }
    
    private func injectDependency(controller: AnyObject) {
        let registrationName = (controller as! RegistrationNameAssociatable).swinjectRegistrationName
        if let viewController = controller as? NSViewController {
            container.runInitCompleted(viewController.dynamicType, controller: viewController, name: registrationName)
        
            for child in viewController.childViewControllers {
                injectDependency(child)
            }
        }
        else if let windowController = controller as? NSWindowController {
            container.runInitCompleted(windowController.dynamicType, controller: windowController, name: registrationName)
        }
    }
}
