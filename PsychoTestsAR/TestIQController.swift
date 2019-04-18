//
//  TestIQController.swift
//  PsychoTestsAR
//
//  Created by AT Wolfar on 03/04/2019.
//  Copyright © 2019 PUMTeam. All rights reserved.
//

import UIKit
import AudioToolbox

class TestIQController: UIViewController {

    let ServerRq = ServerAction()
    let userDataIQTests = UserDefaults.standard
    var pointsResult: Int = 0
    var questionNumber: Int = 0
    var pickedAnser: Int = 0
    
    // Timer
    var countdownTimer: Timer! = nil
    var totalTime = 20 // Zmienna określająca czas na odpowieź w danym pytaniu
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    
    var arrayQuestion = [String]()
    var arrayAnswer = [String]()
    var arrayValue = [String]()
  
    let ServerRqe = ServerAction()
    let user_data_tests = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

       ServerRqe.dataIQTests() // Instancja zwraca pulę testów wraz z odpowiedźmiami (3 tablice zapisane na tel)
        
        arrayQuestion = user_data_tests.array(forKey: "questions") as? [String] ?? [String]()
        arrayAnswer = user_data_tests.array(forKey: "answers") as? [String] ?? [String]()
        arrayValue = user_data_tests.array(forKey: "values") as? [String] ?? [String]()
        
        print(arrayValue)
        
        nextQuestion()
        startTimer()
       
    }
  
    
    @IBAction func answerPressed(_ sender: AnyObject) {
        
        pickedAnser = Int(arrayValue[questionNumber * 3 + sender.tag])!
        
        checkAnswer()
        questionNumber = questionNumber + 1
        nextQuestion()
        startTimer()
    }
    
    
    func updateUI() {
        
       // scoreLabel.text = "Punkty: \(pointsResult)"
        progressLabel.text = "Pytanie: \(questionNumber + 1) / 10"
     //   progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionNumber + 1)
        
    }
    
    
    func nextQuestion() {
        
        if questionNumber  < 10{
            
             questionLabel.text = arrayQuestion[questionNumber]
            //wyszukanie wlasciwych odpowiedzi do pytania w tablicy
            let answerNumber = questionNumber * 3
            answerA.setTitle(arrayAnswer[answerNumber + 0], for: .normal)
            answerB.setTitle(arrayAnswer[answerNumber + 1], for: .normal)
            answerC.setTitle(arrayAnswer[answerNumber + 2], for: .normal)
            
            updateUI()
            
        }else{
            SaveResultAndGoToNextVC()
          }
        
    }
    
    func checkAnswer() {
     
        if pickedAnser == 1{
            
       //     ProgressHUD.showSuccess("Correct")
            
              print("You got it!")
            pointsResult += 1
        }else{
            print("blad")
          //  ProgressHUD.showError("Wrong!")
        }
    }
    
    func startTimer() {
        totalTime = 20
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            
        }
    }
    
    func endTimer() {
        //wlacz wibracje
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        countdownTimer?.invalidate()
        countdownTimer = nil
        
        if(questionNumber<10){
            questionNumber = questionNumber + 1
            startTimer()
            nextQuestion()
        }else{
                //przenies na formatke z wynikami
                SaveResultAndGoToNextVC()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    //przeniesienie wyniku testu na formatke resultTest
    func SaveResultAndGoToNextVC () -> Void {
        let userSave = UserDefaults.standard
        userSave.set(pointsResult, forKey: "scoreResult")
        userSave.set(1, forKey: "nrTest")
     //   userSave.set(nrQuestBadAnswer, forKey: "nrQuestBadAnserList")
    //    userSave.set(badAnswer, forKey: "badAnserList")
   //     userSave.set(nrQuestionRadom, forKey: "nrQuestRadomList")
    //    print(nrQuestionRadom)
        performSegue(withIdentifier: "resultTestIQ", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var shouldAutorotate: Bool {
        if UIDevice.current.orientation.isLandscape == false {
            return true
        }
        else {
            return false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
