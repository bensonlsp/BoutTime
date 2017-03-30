//
//  ViewController.swift
//  BoutTime
//
//  Created by Benson Lo on 23/3/2017.
//  Copyright © 2017年 Benson Lo. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    // The 4 Labels meansvare four button text boxes from top to bottom
    @IBOutlet weak var label1: UIButton!
    @IBOutlet weak var label2: UIButton!
    @IBOutlet weak var label3: UIButton!
    @IBOutlet weak var label4: UIButton!
    
    // The 6 buttons means the arrow buttons from top to bottom
    @IBOutlet weak var button1Down: UIButton!
    @IBOutlet weak var button2Up: UIButton!
    @IBOutlet weak var button2Down: UIButton!
    @IBOutlet weak var button3Up: UIButton!
    @IBOutlet weak var button3Down: UIButton!
    @IBOutlet weak var button4Up: UIButton!
    
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    var timer: Timer? = nil
    var counter: Int = 60
    
    var isNewGame: Bool = true
    
    var urlString: String?
    
    var hanDynasty: HanDynasty
    var boutManager: BoutTimeManager
    
    required init?(coder aDecoder: NSCoder) {

        // Load emperors data into the hanDynasty class
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "HanEmperors", ofType: "plist")
            
            let emperors = try EmperorUnarchiver.emperorInventory(fromDictionary: dictionary)
            
            self.hanDynasty = HanDynasty.init(emperors: emperors)
        } catch let error {
            fatalError("\(error)")
        }
        
        // Randomly draw four emperors from hanDynasty
        let fourRandomEmperors = hanDynasty.returnFourRandomEmperors()
        
        // Create a boutmanager to manage the game
        self.boutManager = BoutTimeManager(emperorsOfCurrenRound: fourRandomEmperors)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNewGame == true {
            // Disable user to click to show details of the emperor from wiki when playing
            label1.isUserInteractionEnabled = false
            label2.isUserInteractionEnabled = false
            label3.isUserInteractionEnabled = false
            label4.isUserInteractionEnabled = false
            
            // To prevent the game to restart when the view appear again
            isNewGame = false
            // Reset the BoutManager
            boutManager.reset()
            // Reset the button state
            resetButtonState()
            // Randomly draw four emperors from hanDynasty to put into the next round
            let fourRandomEmperors = hanDynasty.returnFourRandomEmperors()
            boutManager.emperorsOfCurrentRound.removeAll()
            boutManager.emperorsOfCurrentRound = fourRandomEmperors
            // Update a new set of emperors and his description to the screen
            updateEmperorsToScreen()
            // Hide the button
            nextRoundButton.isHidden = true
            // Show the timer
            timerLabel.isHidden = false
            // Reset the counter
            counter = timePerRound
            // Run the timer
            startTimer()
            // Change the label to "Shake to Complete"
            bottomTextLabel.text = "Shake to Complete"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to update the emperors information to the screen
    func updateEmperorsToScreen() {
        label1.setTitle("\(boutManager.emperorsOfCurrentRound[0].name) - \(boutManager.emperorsOfCurrentRound[0].description)", for: .normal)
        label2.setTitle("\(boutManager.emperorsOfCurrentRound[1].name) - \(boutManager.emperorsOfCurrentRound[1].description)", for: .normal)
        label3.setTitle("\(boutManager.emperorsOfCurrentRound[2].name) - \(boutManager.emperorsOfCurrentRound[2].description)", for: .normal)
        label4.setTitle("\(boutManager.emperorsOfCurrentRound[3].name) - \(boutManager.emperorsOfCurrentRound[3].description)", for: .normal)
    }
    
    // The function to control the image when an arrow button pressed
    func resetButtonState() {
        button1Down.setImage(#imageLiteral(resourceName: "down_full"), for: .normal)
        button2Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button2Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button3Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button3Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button4Up.setImage(#imageLiteral(resourceName: "up_full"), for: .normal)
    }
    
    // The function to control the image when an arrow button pressed
    @IBAction func button1DownPressed() {
        button1Down.setImage(#imageLiteral(resourceName: "down_full_selected"), for: .normal)
        button2Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button2Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button3Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button3Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button4Up.setImage(#imageLiteral(resourceName: "up_full"), for: .normal)
    }
    
    // The function to control the image when an arrow button pressed
    @IBAction func button2UpPressed() {
        button1Down.setImage(#imageLiteral(resourceName: "down_full"), for: .normal)
        button2Up.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .normal)
        button2Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button3Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button3Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button4Up.setImage(#imageLiteral(resourceName: "up_full"), for: .normal)
    }
    
    // The function to control the image when an arrow button pressed
    @IBAction func button2DownPressed() {
        button1Down.setImage(#imageLiteral(resourceName: "down_full"), for: .normal)
        button2Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button2Down.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .normal)
        button3Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button3Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button4Up.setImage(#imageLiteral(resourceName: "up_full"), for: .normal)
    }
    
    // The function to control the image when an arrow button pressed
    @IBAction func button3UpPressed() {
        button1Down.setImage(#imageLiteral(resourceName: "down_full"), for: .normal)
        button2Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button2Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button3Up.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .normal)
        button3Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button4Up.setImage(#imageLiteral(resourceName: "up_full"), for: .normal)
    }
    
    // The function to control the image when an arrow button pressed
    @IBAction func button3DownPressed() {
        button1Down.setImage(#imageLiteral(resourceName: "down_full"), for: .normal)
        button2Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button2Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button3Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button3Down.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .normal)
        button4Up.setImage(#imageLiteral(resourceName: "up_full"), for: .normal)
    }
    
    @IBAction func button4UpPressed() {
        button1Down.setImage(#imageLiteral(resourceName: "down_full"), for: .normal)
        button2Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button2Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button3Up.setImage(#imageLiteral(resourceName: "up_half"), for: .normal)
        button3Down.setImage(#imageLiteral(resourceName: "down_half"), for: .normal)
        button4Up.setImage(#imageLiteral(resourceName: "up_full_selected"), for: .normal)
    }
    
    // Function to swop label of label 1 and label 2
    @IBAction func swopLabel1Label2() {
        if let label1Label = label1.titleLabel,
            let label2Label = label2.titleLabel {
            label1.setTitle(label2Label.text, for: .normal)
            label2.setTitle(label1Label.text, for: .normal)
            swap(&boutManager.emperorsOfCurrentRound[0], &boutManager.emperorsOfCurrentRound[1])
        }
    }
    
    // Function to swop label of label 2 and label 3
    @IBAction func swopLabel2Label3() {
        if let label2Label = label2.titleLabel,
            let label3Label = label3.titleLabel {
            label2.setTitle(label3Label.text, for: .normal)
            label3.setTitle(label2Label.text, for: .normal)
            swap(&boutManager.emperorsOfCurrentRound[1], &boutManager.emperorsOfCurrentRound[2])
        }
    }
    
    // Function to swop label of label 3 and label 4
    @IBAction func swopLabel3Label4() {
        if let label3Label = label3.titleLabel,
            let label4Label = label4.titleLabel {
            label3.setTitle(label4Label.text, for: .normal)
            label4.setTitle(label3Label.text, for: .normal)
            swap(&boutManager.emperorsOfCurrentRound[2], &boutManager.emperorsOfCurrentRound[3])
        }
    }
    
    // Function to start the timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // Function to stop the timer
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
            roundOver()
        }
    }
    
    // Function to update the timer
    func updateTimer() {
        if counter > 0 {
            if counter >= 10 {
                timerLabel.text = "0:\(counter)"
            } else {
                timerLabel.text = "0:0\(counter)"
            }
            counter -= 1
        } else {
            timerLabel.text = "0:00"
            stopTimer()
        }
    }
    
    // Function to check if the sequence sorted by the player is correct
    // i.e. from the oldest at the top to the nearest at the bottom
    func checkResult() -> Bool {
        if boutManager.emperorsOfCurrentRound[0].order < boutManager.emperorsOfCurrentRound[1].order &&
        boutManager.emperorsOfCurrentRound[1].order < boutManager.emperorsOfCurrentRound[2].order &&
            boutManager.emperorsOfCurrentRound[2].order < boutManager.emperorsOfCurrentRound[3].order {
            return true
        } else {
            return false
        }
    }
    
    // Function to be run when the time is up or the user shake the phone to indicate end of the round
    func roundOver() {
        // Enable user to click to show details of the emperor from wiki
        label1.isUserInteractionEnabled = true
        label2.isUserInteractionEnabled = true
        label3.isUserInteractionEnabled = true
        label4.isUserInteractionEnabled = true
        
        // Hidden the timer label
        timerLabel.isHidden = true
        
        // Change the bottom label to "Tap events to learn more"
        bottomTextLabel.text = "Tap events to learn more"
        
        // Check the result is correct or not
        let result = checkResult()
        
        // Round + 1
        boutManager.round -= 1
        
        // Add one point if the result is correct
        if result == true {
            // Add one point
            boutManager.score += 1
            //display the next round button to the green one
            let greenButton = UIImage(named: "next_round_success")
            nextRoundButton.setImage(greenButton, for: UIControlState.normal)
            nextRoundButton.isHidden = false
        } else {
            // display the next round button to the red one
            let redButton = UIImage(named: "next_round_failure")
            nextRoundButton.setImage(redButton, for: UIControlState.normal)
            nextRoundButton.isHidden = false
        }
    }
    
    // After round 6, game is over, display the game over view
    func gameover() {
        isNewGame = true
        self.performSegue(withIdentifier: "toGameOverView", sender: self)
    }
    
    // The first emperor clicked to show his information in Wiki
    @IBAction func toWebView1(_ sender: Any) {
        urlString = boutManager.emperorsOfCurrentRound[0].wikiLink
        self.performSegue(withIdentifier: "toWebView", sender: self)
    }

    // The second emperor clicked to show his information in Wiki
    @IBAction func toWebView2(_ sender: Any) {
        urlString = boutManager.emperorsOfCurrentRound[1].wikiLink
        self.performSegue(withIdentifier: "toWebView", sender: self)
    }

    @IBAction func toWebView3(_ sender: Any) {
        urlString = boutManager.emperorsOfCurrentRound[2].wikiLink
        self.performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    @IBAction func toWebView4(_ sender: Any) {
        urlString = boutManager.emperorsOfCurrentRound[3].wikiLink
        self.performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    // Send information to game over view or web view based on the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameOverView"{
            let vc = segue.destination as! GameOverViewController
            vc.data = boutManager.score
        }
        if segue.identifier == "toWebView"{
            let vc = segue.destination as! WebViewController
            if let urlString = urlString {
                vc.data = urlString
            }
        }
    }
    
    // To handle shake motion
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            stopTimer()
        }
    }
    
    // The action of the next round button
    @IBAction func nextRound() {
        if boutManager.round > 0 {
            // Disable user to click to show details of the emperor from wiki when playing
            label1.isUserInteractionEnabled = false
            label2.isUserInteractionEnabled = false
            label3.isUserInteractionEnabled = false
            label4.isUserInteractionEnabled = false
            
            // Reset arrow button state
            resetButtonState()
            
            // Randomly draw four emperors from hanDynasty to put into the next round
            let fourRandomEmperors = hanDynasty.returnFourRandomEmperors()
            boutManager.emperorsOfCurrentRound.removeAll()
            boutManager.emperorsOfCurrentRound = fourRandomEmperors
        
            // Update a new set of emperors and his description to the screen
            updateEmperorsToScreen()
            // Hide the button
            nextRoundButton.isHidden = true
            // Show the timer
            timerLabel.isHidden = false
            // Reset the counter
            counter = timePerRound
            // Run the timer
            startTimer()
            // Change the label to "Shake to Complete"
            bottomTextLabel.text = "Shake to Complete"
        } else {
            gameover()
        }
    }
}

