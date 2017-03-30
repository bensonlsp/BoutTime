//
//  GameOverViewController.swift
//  BoutTime
//
//  Created by Benson Lo on 29/3/2017.
//  Copyright © 2017年 Benson Lo. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    var data: Int?
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let score = data {
            scoreLabel.text = "\(score)/6"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAgain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
