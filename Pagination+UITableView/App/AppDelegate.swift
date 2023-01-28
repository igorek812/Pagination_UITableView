//
//  AppDelegate.swift
//  Pagination+UITableView
//
//  Created by Igor on 24.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func printClassNames() {
        
        let amountClasses = objc_getClassList(nil, 0)
        print("Amount of classes: \(amountClasses)")

        var classes = [AnyClass](repeating: NSObject.self, count: Int(amountClasses))
        classes.withUnsafeMutableBufferPointer { buffer in
            let autoreleasingPointer = AutoreleasingUnsafeMutablePointer<AnyClass>(buffer.baseAddress)
            objc_getClassList(autoreleasingPointer, amountClasses)
        }

        for currentClass in classes {

            guard Bundle(for: currentClass) == Bundle.main else {continue}
            print("Class name:\(currentClass)")

            //printPropertyNamesForClass(currentClass)
            //printMethodNamesForClass(currentClass)
        }
        
        

    }
    
    func printPropertyNamesForClass(_ currentClass : AnyClass) {
        var count = UInt32()
        let propertyList = class_copyPropertyList(currentClass, &count)
        let intCount = Int(count)

        guard let properties = propertyList, intCount > 0 else {return}

        for i in 0 ..< intCount {
            let property : objc_property_t = properties[i]

            let nameCString = property_getName(property)
            print("\t Property name:\(String(cString: nameCString))");

        }

        free(properties)
    }

    func printMethodNamesForClass(_ currentClass: AnyClass) {
        var methodCount: UInt32 = 0
        let methodList = class_copyMethodList(currentClass, &methodCount)

        guard let methods = methodList, methodCount > 0 else {return}

        var ptr = methods
        for _ in 0 ..< methodCount {

            let sel = method_getName(ptr.pointee)
            ptr = ptr.successor()

            let nameCString = sel_getName(sel)

            print("\t method named:\(String(cString: nameCString))");
        }

    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //printClassNames()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

