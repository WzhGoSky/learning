//
//  WBMainTabbarController.swift
//  微博
//
//  Created by Hayder on 16/10/25.
//  Copyright © 2016年 wangzhenhai. All rights reserved.
//

import UIKit

//主控制器
class WBMainTabbarController: UITabBarController {

    //MARK: - 私有控件
   fileprivate lazy var composeButton : UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpChildControllers()
        setUpComposeButton();
        
    }
    
    /**
        portrait 肖像  竖屏
        landscape 风景 横屏
     
     
     在主控制器里面实现这个方法 主要是因为当前控制器和子控制器都会遵守
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return .portrait
    }
    //private 能够保证方法私有，仅在当前对象访问
    //@objc 允许这个函数在运行时通过OC的消息机制被调用
    
    @objc fileprivate func composeStatus(){
        
        print("撰写微博")
        
        
        
    }

}

//extension  类似于 OC中的分类， 在Swift中 还可以用来切分代码块
//可以把相近似功能的函数，放在一个extension钟
//便于代码的维护
//注意:和 OC 的分类一样， extension 中不能定义属性
extension WBMainTabbarController{
    
   fileprivate func setUpComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        //计算按钮的高度
        let count = CGFloat(childViewControllers.count)
        
        //将向内缩颈的宽度减小，能够让按钮的宽度变大，盖住容错点，防止穿帮
        let width = tabBar.bounds.width / count - 1
        
        //CGRectInset 正数向内缩进
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0);
        
        //按钮监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
    }
    
    fileprivate  func setUpChildControllers(){
        
        //界面的创建都依赖网络的json
        let array:[[String : Any]] = [
            ["clsName" : "WBHomeViewController","title" : "首页","imageName":"home","visitorInfo":["imageName" :"","message":"关注一些人，回这里看看有什么惊喜"]],
            
            ["clsName" : "WBMessageViewController","title" : "消息","imageName":"message_center","visitorInfo":["imageName" :"visitordiscover_image_message","message":"登录后别人评论你的微博，发给你的消息，都会在这边收到通知"]],
            
            ["clsName" : "","title" : "","imageName":""],

            ["clsName" : "WBDiscoverViewController","title" : "发现","imageName":"discover","visitorInfo":["imageName" :"visitordiscover_image_message","message":"登录后，最新，最热微博仅在掌握，不再会与事实潮流擦肩而过"]],

            ["clsName" : "WBPorfileViewController","title" : "我","imageName":"profile","visitorInfo":["imageName" :"visitordiscover_image_profile","message":"登录后，你的微博，相册，个人资料都会显示在这里，展示给别人看"]],

        ]
        
        //存到桌面
//        (array as NSArray) .write(toFile: "/Users/wangzhenhai/Desktop/status.plist", atomically: true)
     //数组 -> json序列化
        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
        
        (data as NSData).write(toFile: "/Users/wangzhenhai/Desktop/main.json", atomically: true)
        
        
        
        var arrayM = [UIViewController]()
        
        for dict in array
        {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    /// 使用字典创建一个子控制器
    ///
    /// - parameter dict: 信息字典 [claName , title, imageName, visitorInfo]
    // returns : 子控制器
    private func controller(dict:[String : Any]) -> UIViewController{
        
        guard let  claName = dict["clsName"] as? String,
                let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + claName) as? WBBaseViewController.Type,
        let visitorInfo = dict["visitorInfo"] as? [String : String]
            else {
                
                return UIViewController();
        }
        
        //2.创建视图控制器
        //1>将claName 转换成cls
        let vc = cls.init()
        
        vc.title = title
        
        //设置图像
        vc.tabBarItem.image = UIImage(named:"tabbar_" + imageName);
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        //设置tabbar的标题字体大小
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: .normal)
        
        //设置控制器的访客信息字典
        vc.visitorInfo = visitorInfo
        
        let nav = WBNaviagtionController(rootViewController: vc)
        
        return nav;
    
    }
}
