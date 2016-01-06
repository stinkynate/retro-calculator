//
//  ViewController.swift
//  retro-calculator
//
//  Created by Nathan Luttmann on 1/6/16.
//  Copyright © 2016 GE Healthcare. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation {
        case Divide
        case Multiply
        case Add
        case Subtract
        indirect case Equals(Operation)
        case Empty
    }
    
    // Outlets
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = ""
    }

    @IBAction func onClearPressed(sender: UIButton) {
        playSound()
        
        clearCalculator()
    }
    
    @IBAction func onNumberPressed(sender: UIButton) {
        playSound()
        
        if case .Equals(_) = currentOperation {
            leftValStr = ""
            currentOperation = .Empty
        }
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }

    @IBAction func onDividePressed(sender: UIButton) {
        processOperation(.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: UIButton) {
        processOperation(.Subtract)
    }
    
    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(.Add)
    }
    
    @IBAction func onEqualsPressed(sender: UIButton) {
        if runningNumber == "" {
            runningNumber = rightValStr
        }
        if case .Equals(let repeatOp) = currentOperation {
            currentOperation = repeatOp
        }
        processOperation(currentOperation)
        currentOperation = .Equals(currentOperation)
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        // User selected 2 operators in a row
        if case Operation.Empty = currentOperation {
            // This is the first time an operation has been pressed
            if runningNumber == "" {
                runningNumber = "0"
            }
            
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        } else {
            // Run some math
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
            
                let leftNum = Double(leftValStr)!
                let rightNum = Double(rightValStr)!
                var result = 0.0
                
                switch currentOperation {
                case .Multiply:
                    result = leftNum * rightNum
                case .Divide:
                    result = leftNum / rightNum
                case .Subtract:
                    result = leftNum - rightNum
                case .Add:
                    result = leftNum + rightNum
                default:
                    break
                }
                
                leftValStr = "\(result)"
                outputLbl.text = leftValStr
            } else if leftValStr != "" {
                runningNumber = leftValStr
            }
            
            currentOperation = op
        }
    }
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func clearCalculator() {
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
        currentOperation = .Empty
        outputLbl.text = ""
    }
}

