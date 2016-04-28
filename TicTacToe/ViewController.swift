//
//  ViewController.swift
//  TicTacToe
//
//  Created by Rick Ke on 16/3/26.
//  Copyright © 2016年 CodeWorld. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    
    @IBOutlet var isVisitingPlayerButton: UIButton!
    @IBOutlet var notVisitingPlayerButton: UIButton!
    @IBOutlet var markOButton: UIButton!
    @IBOutlet var markXButton: UIButton!
    @IBOutlet var startButton: UIButton!


    var isVisitingPlayerDone = false;       // 先攻
    var isGameOver = false
    var userMark = "O"
    var AIMark = "X"
    var buttonMarkNumber = 0
    var theSameMarkWithAIMark = 0
    var theDifferentWithAIMark = 0
    var notObjectMarkNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func toggleIsVisitingPlayerButton(sender: UIButton){
        countButtonMarkNumber()
        // 先攻按鈕被點選
        if sender == isVisitingPlayerButton{
            if buttonMarkNumber > 0 {
                messageGaming()
            } else {
                isVisitingPlayerDone = false
                isVisitingPlayerButton.backgroundColor = UIColor.greenColor()
                notVisitingPlayerButton.backgroundColor = UIColor.grayColor()
                startButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
                startButton.backgroundColor = UIColor.clearColor()
            }
            
        // 先守按鈕被點選
        }else if sender == notVisitingPlayerButton{
            if buttonMarkNumber > 0 {
                messageGaming()
            } else {
                isVisitingPlayerDone = true
                isVisitingPlayerButton.backgroundColor = UIColor.grayColor()
                notVisitingPlayerButton.backgroundColor = UIColor.greenColor()
                startButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                startButton.backgroundColor = UIColor.blueColor()
            }
        }
    }
    
    
    @IBAction func toggleWhatMarkButton(sender: UIButton){
        countButtonMarkNumber()
        // Ｏ按鈕被點選
        if sender == markOButton{
            if buttonMarkNumber > 0 {
                messageGaming()
            } else {
                userMark = "O"
                AIMark = "X"
                markOButton.backgroundColor = UIColor.greenColor()
                markXButton.backgroundColor = UIColor.lightGrayColor()
            }
            
        // Ｘ按鈕被點選
        }else if sender == markXButton{
            if buttonMarkNumber > 0 {
                messageGaming()
            } else {
                userMark = "X"
                AIMark = "O"
                markOButton.backgroundColor = UIColor.lightGrayColor()
                markXButton.backgroundColor = UIColor.greenColor()
            }
            
        }
    }
    
    // 畫Ｏ或Ｘ
    func drawMark(button: UIButton, mark: String) {
        if mark == "O" {
            button.tintColor = UIColor.blueColor()
        } else if mark == "X" {
            button.tintColor = UIColor.redColor()
        }
        button.setImage(UIImage(named: mark), forState: .Normal)
    }
    
    // 計算buttonMarkNumber數量
    func countButtonMarkNumber() {
        let buttons = [UIButton](arrayLiteral: button1, button2, button3, button4, button5, button6, button7, button8, button9)
        
        for button in buttons {
            if button.currentImage != nil {
                buttonMarkNumber += 1
            }
        }
    }
    
    // 遊戲進行中訊息
    func messageGaming() {
        let alertMessage = UIAlertController(title: nil, message: "遊戲進行中!!", preferredStyle: .Alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    
    // Game Start

    // Set Button
    @IBAction func buttonTapped(sender: UIButton) {
        
        if sender != startButton {
            if (isVisitingPlayerDone == false) && (sender.currentImage == nil) {
                drawMark(sender, mark: userMark)
                isVisitingPlayerDone = true
                //print(sender.currentTitle)
            } else if sender.currentImage != nil {
                let alertMessage = UIAlertController(title: nil, message: "這位置已經下過了！！", preferredStyle: .Alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
                return
            }
        }
        
        //print("AI先")
        

        checkWinOrLose()
        if isGameOver == true {
            isGameOver = false
            return
        }
        
        At5Def10AI()
        
        checkWinOrLose()
        if isGameOver == true {
            isGameOver = false
            return
        }

    }
    
    
    
    
    // Win or Lose or The two players drew
    func checkWinOrLose() {
        var alertMessageTitle = ""
    
        if checkConnectToLine() {
            if isVisitingPlayerDone == true {
                alertMessageTitle = "玩家 贏了!"
            } else {
                alertMessageTitle = "電腦 贏了!"
            }
        } else if tableIsFull() {
            alertMessageTitle = "平手"
        }
        
        if checkConnectToLine() || tableIsFull() {
            let alertMessage = UIAlertController(title: alertMessageTitle, message: "要再玩一場嗎?", preferredStyle: .Alert)
            isGameOver = true
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                (action:UIAlertAction) in
                self.clearTable()
            }))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
    }
    
    
    // 判斷連線
    func checkConnectToLine() -> Bool {
        if (// row
            compareThreeEqual(button1, object2: button2, object3: button3) ||
            compareThreeEqual(button4, object2: button5, object3: button6) ||
            compareThreeEqual(button7, object2: button8, object3: button9) ||
            
            // column
            compareThreeEqual(button1, object2: button4, object3: button7) ||
            compareThreeEqual(button2, object2: button5, object3: button8) ||
            compareThreeEqual(button3, object2: button6, object3: button9) ||
            
            // diagonal
            compareThreeEqual(button1, object2: button5, object3: button9) ||
            compareThreeEqual(button3, object2: button5, object3: button7)
            ){
            return true
        }
        return false
    }
    
    
    // 滿格情況
    func tableIsFull() -> Bool {
        let buttons = [UIButton](arrayLiteral: button1, button2, button3, button4, button5, button6, button7, button8, button9)
        
        for button in buttons {
            if button.currentImage == nil {
                return false
            }
        }
        return true
    }

    
    // 三點比較
    func compareThreeEqual(object1: UIButton , object2: UIButton, object3: UIButton) -> Bool {
        if object1.currentImage != nil && object2.currentImage != nil && object3.currentImage != nil {
            if object1.currentImage == object2.currentImage && object1.currentImage == object3.currentImage {
                return true
            }
        }
        return false
    }

    
    // 清除表格，回復至初始設定
    func clearTable() {
        let buttons = [UIButton](arrayLiteral: button1, button2, button3, button4, button5, button6, button7, button8, button9)
        
        for button in buttons {
            button.setImage(nil, forState: .Normal)
        }
        
        isVisitingPlayerDone = false;
        isGameOver = false
        buttonMarkNumber = 0
    }
    

    
    
    // MARK: - Artificial Intelligence
    
    // AI
    func At5Def10AI() {
        let buttons = [UIButton](arrayLiteral: button1, button2, button3, button4, button5, button6, button7, button8, button9)
        let lineArray = [[UIButton]](arrayLiteral:
            // row
            [button1, button2, button3], [button4, button5, button6], [button7, button8, button9],
            // column
            [button1, button4, button7], [button2, button5, button8], [button3, button6, button9],
            // diagonal
            [button1, button5, button9], [button3, button5, button7])
        
        countButtonMarkNumber()
        
        //print("buttonMarkNumber: \(buttonMarkNumber)")
        
        // AI起手設定
        if buttonMarkNumber == 0 {          // AI先攻，起手設定
            let randomIndex = Int(arc4random_uniform(UInt32(buttons.count)))
            drawMark(buttons[randomIndex], mark: AIMark)
            isVisitingPlayerDone = false
            return
        
        } else if buttonMarkNumber == 1 {   // AI先守，起手設定
            // User先佔角
            if ( button1.currentImage != nil || button3.currentImage != nil || button7.currentImage != nil || button9.currentImage != nil ) {
                
                drawMark(button5, mark: AIMark)
                
            // User先佔邊
            } else if ( button2.currentImage != nil || button4.currentImage != nil || button6.currentImage != nil || button8.currentImage != nil ) {
                
                var sideT = [UIButton]()
                if button2.currentImage != nil {
                    sideT = [UIButton](arrayLiteral: button1, button3, button5, button8)
                } else if button4.currentImage != nil {
                    sideT = [UIButton](arrayLiteral: button1, button5, button6, button7)
                } else if button6.currentImage != nil {
                    sideT = [UIButton](arrayLiteral: button3, button4, button5, button9)
                } else if button8.currentImage != nil {
                    sideT = [UIButton](arrayLiteral: button8, button5, button7, button9)
                }
                
                let randomIndex = Int(arc4random_uniform(UInt32(sideT.count)))
                drawMark(sideT[randomIndex], mark: AIMark)
                
            // User先佔中間
            } else if ( button5.currentImage != nil ) {
                
                let coners = [UIButton](arrayLiteral: button1, button3, button7, button9)
                let randomIndex = Int(arc4random_uniform(UInt32(coners.count)))
                drawMark(coners[randomIndex], mark: AIMark)
 
            }
            
            isVisitingPlayerDone = false
            return
            
        }
        
        // 呼叫 兩點比較，執行進攻連線（TheSameMarkWithAIMark）
        for i in 0...7 {
            compareTwoEqual(lineArray[i])
            if theSameMarkWithAIMark > 1 && notObjectMarkNumber != 0 {
                compareTwoEqualTheSameMarkWithAIMark(lineArray[i])
                isVisitingPlayerDone = false
                return
            }
        }
        
        // 呼叫 兩點比較，執行防守阻線（TheDifferentWithAIMark）
        for i in 0...7 {
            compareTwoEqual(lineArray[i])
            if theDifferentWithAIMark > 1 && notObjectMarkNumber != 0 {
                compareTwoEqualTheDifferentWithAIMark(lineArray[i])
                isVisitingPlayerDone = false
                return
            }
        }

        // 呼叫 預備連線
        preConnectToLine()
        

        
    }
    
    // 兩點比較
    func compareTwoEqual(object: [UIButton]) {
        theSameMarkWithAIMark = 0
        theDifferentWithAIMark = 0
        notObjectMarkNumber = 0
        for i in 0...2 {
            if object[i].currentImage != nil {
                if object[i].currentImage == UIImage(named: AIMark) {
                    theSameMarkWithAIMark += 1
                } else {
                    theDifferentWithAIMark += 1
                }
            } else {
                notObjectMarkNumber += 1
            }
        }
    }
    
    // 兩點比較，TheSameMarkWithAIMark
    func compareTwoEqualTheSameMarkWithAIMark(object: [UIButton]) {
        if object[0].currentImage == object[1].currentImage {
            drawMark(object[2], mark: AIMark)
        } else if object[1].currentImage == object[2].currentImage {
            drawMark(object[0], mark: AIMark)
        } else if object[0].currentImage == object[2].currentImage {
            drawMark(object[1], mark: AIMark)
        }
    }
    
    // 兩點比較，TheDifferentWithAIMark
    func compareTwoEqualTheDifferentWithAIMark(object: [UIButton]) {
        if object[0].currentImage == object[1].currentImage {
            drawMark(object[2], mark: AIMark)
        } else if object[1].currentImage == object[2].currentImage {
            drawMark(object[0], mark: AIMark)
        } else if object[0].currentImage == object[2].currentImage {
            drawMark(object[1], mark: AIMark)
        }
    }
    
    
    // 預備連線 bug in here
    func preConnectToLine() {
        let buttons = [UIButton](arrayLiteral: button1, button2, button3, button4, button5, button6, button7, button8, button9)
        
//        if buttonMarkNumber == 2 {
//            // AI先佔角
//            if ( button1.currentImage == UIImage(named: AIMark) || button3.currentImage == UIImage(named: AIMark) || button7.currentImage == UIImage(named: AIMark) || button9.currentImage == UIImage(named: AIMark) ) {
//                if ( button5.currentImage == nil) {
//                    drawMark(button5, mark: AIMark)
//                    isVisitingPlayerDone = false
//                    return
//                }
//
//            // AI先佔邊
//            } else if ( button2.currentImage == UIImage(named: AIMark) || button4.currentImage == UIImage(named: AIMark) || button6.currentImage == UIImage(named: AIMark) || button8.currentImage == UIImage(named: AIMark) ) {
//                
//                if button2.currentImage == UIImage(named: AIMark) {
//                    if button4.currentImage == UIImage(named: userMark) || button7.currentImage == UIImage(named: userMark) {
//                        drawMark(button1, mark: AIMark)
//                    } else if button6.currentImage == UIImage(named: userMark) || button9.currentImage == UIImage(named: userMark) {
//                        drawMark(button3, mark: AIMark)
//                    }
//                } else if button4.currentImage == UIImage(named: AIMark) {
//                    if button2.currentImage == UIImage(named: userMark) || button3.currentImage == UIImage(named: userMark) {
//                        drawMark(button1, mark: AIMark)
//                    } else if button8.currentImage == UIImage(named: userMark) || button9.currentImage == UIImage(named: userMark) {
//                        drawMark(button7, mark: AIMark)
//                    }
//                } else if button6.currentImage == UIImage(named: AIMark) {
//                    if button1.currentImage == UIImage(named: userMark) || button2.currentImage == UIImage(named: userMark) {
//                        drawMark(button3, mark: AIMark)
//                    } else if button7.currentImage == UIImage(named: userMark) || button8.currentImage == UIImage(named: userMark) {
//                        drawMark(button9, mark: AIMark)
//                    }
//                } else if button8.currentImage == UIImage(named: AIMark) {
//                    if button1.currentImage == UIImage(named: userMark) || button4.currentImage == UIImage(named: userMark) {
//                        drawMark(button7, mark: AIMark)
//                    } else if button3.currentImage == UIImage(named: userMark) || button6.currentImage == UIImage(named: userMark) {
//                        drawMark(button9, mark: AIMark)
//                    }
//                }
//                        isVisitingPlayerDone = false
//                        return
//            }
//        
//        
//            // AI先佔中間
//            } else if ( button5.currentImage == UIImage(named: AIMark) ) {
//                let coners = [UIButton](arrayLiteral: button1, button3, button7, button9)
//                for i in 0...3 {
//                    if coners[i].currentImage == nil && coners[i].currentImage != UIImage(named: userMark) {
//                        let randomIndex = Int(arc4random_uniform(UInt32(coners.count)))
//                        drawMark(coners[randomIndex], mark: AIMark)
//                        isVisitingPlayerDone = false
//                        return
//                    }
//            }
//            
//    
//    
//        } else {
            while isVisitingPlayerDone == true {
                let randomIndex = Int(arc4random_uniform(UInt32(buttons.count)))
                //print("\(randomIndex)")
                if buttons[randomIndex].currentImage == nil {
                    drawMark(buttons[randomIndex], mark: AIMark)
                    isVisitingPlayerDone = false
                    //print("正確： \(randomIndex)")
                }
            }
//        }
    }
    
    
    //鎖定視圖自動旋轉
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }


}


