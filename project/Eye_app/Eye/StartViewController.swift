//
//  StartViewController.swift
//  Eye
//
//  Created by Sean on 26/06/2018.
//  Copyright © 2018 seanhao. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }}

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fullSize = UIScreen.main.bounds.size
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小（全屏）
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        
        //创建并添加vibrancy视图
        let vibrancyView = UIVisualEffectView(effect:
            UIVibrancyEffect(blurEffect: blurEffect))
        vibrancyView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        blurView.contentView.addSubview(vibrancyView)
        
        //将文本标签添加到vibrancy视图中
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        label.text = "seanhao"
        label.font = UIFont(name: "Zapfino", size: 60)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.center = CGPoint(
            x: fullSize.width * 0.5, y: fullSize.height * 0.2)
        vibrancyView.contentView.addSubview(label)
        
        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
        self.view.addSubview(blurView)
        
        
        // Do any additional setup after loading the view.
        
        //self.view.backgroundColor = UIColor.white
        
        //button1
        let myButton = UIButton(frame: CGRect(
            x: 0, y: 0, width: 200, height: 60))
        myButton.layer.borderWidth = 1.5
        myButton.layer.cornerRadius = 16
        myButton.layer.masksToBounds = true
        myButton.setTitle("情緒偵測", for: UIControlState.normal)
        myButton.backgroundColor = UIColor.clear
        myButton.setBackgroundColor(color: UIColor.black, forState: UIControlState.highlighted)
        
        myButton.setTitleColor(UIColor.black, for: .normal)
        myButton.setTitleColor(UIColor.white, for: .highlighted)
        myButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        myButton.addTarget(
            nil, action: #selector(StartViewController.goMain),
            for: .touchUpInside)
        myButton.center = CGPoint(
            x: fullSize.width * 0.5, y: fullSize.height * 0.4)
        self.view.addSubview(myButton)
        
        //button2
        let myButton2 = UIButton(frame: CGRect(
            x: 0, y: 0, width: 200, height: 60))
        myButton2.layer.borderWidth = 1.5
        myButton2.layer.cornerRadius = 16
        myButton2.layer.masksToBounds = true
        myButton2.setTitle("品牌辨識", for: UIControlState.normal)
        myButton2.backgroundColor = UIColor.clear
        myButton2.setBackgroundColor(color: UIColor.black, forState: UIControlState.highlighted)
        myButton2.setTitleColor(UIColor.black, for: .normal)
        myButton2.setTitleColor(UIColor.white, for: .highlighted)
        myButton2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        myButton2.addTarget(
            nil, action: #selector(StartViewController.goMain2),
            for: .touchUpInside)
        myButton2.center = CGPoint(
            x: fullSize.width * 0.5, y: fullSize.height * 0.5)
        self.view.addSubview(myButton2)
        
        //button3
        //button2
        let myButton3 = UIButton(frame: CGRect(
            x: 0, y: 0, width: 200, height: 60))
        myButton3.layer.borderWidth = 1.5
        myButton3.layer.cornerRadius = 16
        myButton3.layer.masksToBounds = true
        myButton3.setTitle("花種辨識", for: UIControlState.normal)
        myButton3.backgroundColor = UIColor.clear
        myButton3.setBackgroundColor(color: UIColor.black, forState: UIControlState.highlighted)
        myButton3.setTitleColor(UIColor.black, for: .normal)
        myButton3.setTitleColor(UIColor.white, for: .highlighted)
        myButton3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        myButton3.addTarget(
            nil, action: #selector(StartViewController.goMain3),
            for: .touchUpInside)
        myButton3.center = CGPoint(
            x: fullSize.width * 0.5, y: fullSize.height * 0.6)
        self.view.addSubview(myButton3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func goMain() {
        self.present(ViewController(), animated: true, completion: nil)
    }
    
    @objc func goMain2() {
        self.present(ViewController2(), animated: true, completion: nil)
    }
    
    @objc func goMain3() {
        self.present(ViewController3(), animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
