//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 26/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var savedMemes = [Meme]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIViewController {
    //A computed property that simply "proxies" to the actual storage in AppDelegate
    var savedMemes: [Meme]! {
        get {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.savedMemes
        }
        set {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.savedMemes = newValue
        }
    }
}

extension UITabBarController {
    
    //This is more complex that I hoped because of a quirk I wasn't able to solve in an easier way..
    //In practice, the idea was simply to "offset" away the tabbarcontroller toolbar to hide it,
    //and it works by itself, but then when showing the navigationcontroller toolbar (with the trash item in it)
    //it seems to "remember" where the tabbarcontroller toolbar was and it gets drawn above its original (i.e.
    //before offsetting it away) position (If you want to see what I mean, rename the setToolbarHidenSimpler below and use that).
    //So I went further and set the height to zero to let the navigationcontroller sit flush at the bottom.
    //But then I found out that the UITabBarItem images (the icon for table and grid) remained somehow in the way
    //although partially clipped.
    //I wasn't able to find any better way other then nilling them out before ofsetting the toolbar and then 
    //restoring them.
    //I'd really be curious to understand why is that!
    
    func setToolbarHidden (hidden: Bool, animated: Bool, completion userCompletion: (() -> Void)? = nil) {
        
        //We need some "permanent" state to be able to restore original height and UITabBarItem images
        struct Holder {
            static var height = CGFloat(0.0)
            static var images = [UIImage?]()
        }
        
        //If we're already in the desired state, NOP
        if toolbarIsVisible() == !hidden {
            return
        }
        
        if (hidden) {//When hiding, store height and UITabBarItem images to be restored when showing again
            Holder.height = tabBar.frame.size.height
            for item in tabBar.items! {
                Holder.images.append((item ).image)
                (item ).image = nil
            }
        }
        else { //Restore original height and UITabBarItem images
            tabBar.frame.size.height = Holder.height
            for (index, image) in Holder.images.enumerate() {
                (tabBar.items![index] ).image = image
            }
            Holder.images = [UIImage?]()
        }
        
        let frame = tabBar.frame
        let offsetY = hidden ? frame.size.height : -frame.size.height
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0
            , animations: {
                self.tabBar.frame = CGRectOffset(frame, CGFloat(0.0), offsetY)
            }
            , completion: {_ in
                if hidden {
                    self.tabBar.frame.size.height = CGFloat(0.0)
                }
                userCompletion?()
        })
    }
    
    /******** MUCH SIMPLER AND CLEANER IMPLEMENTATION BUT SEE COMMENTS ABOVE *********/
    func setToolbarHidden_simpler (hidden: Bool, animated: Bool, completion userCompletion: (() -> Void)? = nil) {
        
        
        //If we're already in the desired state, NOP
        if toolbarIsVisible() == !hidden {
            return
        }
        
        let frame = tabBar.frame
        let offsetY = hidden ? frame.size.height : -frame.size.height
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0
            , animations: {
                self.tabBar.frame = CGRectOffset(frame, CGFloat(0.0), offsetY)
            }
            , completion: {_ in
                userCompletion?()
        })
        
    }
    /*********************************************************************************/

    private func toolbarIsVisible() -> Bool {
        return tabBar.frame.origin.y < CGRectGetMaxY(view.frame)
    }
}
