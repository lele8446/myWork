import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 创建主窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        initializeGlobalValue()
        
        var selectImage = UIImage(named: "tab_info")
        selectImage = selectImage!.cj_image(with: UIColor.logo_color)
        let homeModel: CJTabModel = CJTabModel(vc: DeviceInfoViewController(), title: LocalizedStr("Info"), image: UIImage(named: "tab_info"), select: selectImage)
        
        
        var selectImage2 = UIImage(named: "tab_clean")
        selectImage2 = selectImage2!.cj_image(with: UIColor.logo_color.withAlphaComponent(0.85))
        let orcModel: CJTabModel = CJTabModel(vc: ScanViewController(), title: LocalizedStr("CJ Cleanup"), image: UIImage(named: "tab_clean"), select: selectImage2)
        
        var settingImage = UIImage(named: "tab_setting")
        settingImage = settingImage!.cj_image(with: UIColor.logo_color)
        let settingModel: CJTabModel = CJTabModel(vc: SettingViewController(), title: LocalizedStr("About"), image: UIImage(named: "tab_setting"), select: settingImage)
        
        
        let vcs = [homeModel,orcModel,settingModel]
        let tab = CJTabBarController()
        tab.addChildModels(vcs, tintColor: UIColor.logo_color)
        tab.selectedIndex = 1
        window?.rootViewController = tab
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        CJCommonHelper.addAppStartTime()
    }
}
