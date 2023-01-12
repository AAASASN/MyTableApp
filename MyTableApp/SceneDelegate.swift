//
//  SceneDelegate.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        //        guard let _ = (scene as? UIWindowScene) else { return }
        
        // вместо let _ указываем название сцены (в отличие от сториборда где сцена создается другим способом)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // из windowScene создаем window
        let myWindow = UIWindow(windowScene: windowScene )
        // теперь у window назначаем корневым контороллером табБарКонтроллер
        myWindow.rootViewController = createUITapBarContoller()
        // делаем window ключевым - кладем его в основу нашей иерархии
        myWindow.makeKeyAndVisible()
        // присваиваем ссылку myWindow на window
        self.window = myWindow
    }
    
    // напишем функцию которая будет возвращать экземпляр UITabBarController
    func createUITapBarContoller() -> UITabBarController {
        let tapBarController = UITabBarController()
        // изменяем цвет
        tapBarController.tabBar.backgroundColor = .systemGray5
        // в него сразу положим два навигейшен контроллера
        tapBarController.viewControllers = [createFirstNavigationController(), createSecondNavigationController()]
        return tapBarController
    }
    
    // напишем функцию которая будет возвращать первый UINavigationController
    func createFirstNavigationController() -> UINavigationController {
    
        let someNavigationController = UINavigationController(rootViewController: StartTableViewController(style: .insetGrouped))
 
        // у UINavigationController есть свойство .tabBarItem которое будет передано в UITabBarController
        someNavigationController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "text.alignleft"), tag: 0)
        return someNavigationController
    }
    
    // напишем функцию которая будет возвращать второй UINavigationController
    func createSecondNavigationController() -> UINavigationController {
        let someNavigationController = UINavigationController(rootViewController: StartTableViewController())
        // у UINavigationController есть свойство .tabBarItem которое будет передано в UITabBarController
        someNavigationController.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        return someNavigationController
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    
    
}
