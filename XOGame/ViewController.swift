//
//  ViewController.swift
//  XOGame
//
//  Created by Pitsillidis D (FCES) on 18/02/2020.
//  Copyright © 2020 Pitsillidis D (FCES). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        newGame()
        announceLbl.text = "Welcome, crosses play first"
    }
    
    @IBAction func new(_ sender: Any) {
        newGame()
    }
    
    @IBAction func save(_ sender: Any) {
        UserDefaults.standard.set(gameState, forKey: "stateOfGame")
        UserDefaults.standard.set(activePlayer, forKey: "playerActive")
        UserDefaults.standard.set(turn, forKey: "playerTurn")
    }
    
    @IBOutlet weak var announceLbl: UILabel!
    
    var activePlayer = 1
    
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    var gameActive = true
    
    var turn = 0
    
    var AIEnabled = false
    
    @IBAction func action(_ sender: UIButton) {
        
        if (gameActive){
        
            if(gameState[sender.tag-1] == 0){
                
                gameState[sender.tag-1] = activePlayer
            
                if(activePlayer == 1){
                    sender.setImage(UIImage(named:"X.png"), for: UIControl.State())
                    activePlayer = 2
                    if (AIEnabled == true){
                        AITurn()
                        announceLbl.text = "Cross's turn"
                    }
                    else {
                        announceLbl.text = "Nought's turn"
                    }
                    turn += 1
                }
                else {
                    sender.setImage(UIImage(named:"O.png"), for: UIControl.State())
                    activePlayer = 1
                    announceLbl.text = "Cross's turn"
                    turn += 1
                }
                checkWin()
            }
        }
    }
    
    func newGame() {
        for i in 1...9{
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControl.State())
        }
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        gameActive = true
        turn = 0
        activePlayer = 1
        announceLbl.text = "New Game, Cross's turn"
    }
    
    //check if a player has won, or if it is a draw
    func checkWin() {
        for combination in winningCombinations
        {
            if (gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]])
            {
                //someone has won
                gameActive = false
                if (gameState[combination[0]] == 1){
                    //crosses wins
                    announceLbl.text = "Crosses Wins!"
                }
                else{
                    //Noughts wins
                    announceLbl.text = "Noughts Wins!"
                }
            }
            //if draw
        }
    }
    
        @IBAction func loadButton(_ sender: Any) {
            newGame()
            if let x = UserDefaults.standard.object(forKey: "stateOfGame") as? [Int]{
                gameState = x
                for i in 1...9{
                    let button = view.viewWithTag(i) as! UIButton
                    if (gameState[i-1] == 1){
                        button.setImage(UIImage(named:"X.png"), for: UIControl.State())
                    }
                    else if (gameState[i-1] == 2){
                        button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                    }
                }
            }
            
            if let y = UserDefaults.standard.object(forKey: "playerActive") as? Int{
            activePlayer = y
                if (y == 1){
                    announceLbl.text = "Cross's turn"
                }
                else if (y == 2){
                    announceLbl.text = "Nought's turn"
                }
            }
            
            if let k = UserDefaults.standard.object(forKey: "playerTurn") as? Int{
            turn = k
            }
            checkWin()
        }
    
    @IBAction func vsAIButton(_ sender: Any) {
        //Enable or disable AI
        if (AIEnabled == true){
            AIEnabled = false
        } else if (AIEnabled == false){
            AIEnabled = true
        }
    }
    
       var AIPlayed = false
    
    func AITurn(){
        AIPlayed = false
        if (activePlayer == 2){
            if (AIPlayed == false) {
                //if winning is possible, win
                for combination in winningCombinations
                {
                    if (gameState[combination[0]] == 2 && gameState[combination[1]] == 2)
                    {
                        let button = view.viewWithTag(combination[2]+1) as! UIButton
                        if (gameState[combination[2]] == 0){
                            button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                            gameState[button.tag-1] = activePlayer
                            activePlayer = 1
                            AIPlayed = true
                        }
                    }
                    else if (gameState[combination[1]] == 2 && gameState[combination[2]] == 2)
                    {
                        let button = view.viewWithTag(combination[0]+1) as! UIButton
                        if (gameState[combination[0]] == 0){
                            button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                            gameState[button.tag-1] = activePlayer
                            activePlayer = 1
                            AIPlayed = true
                        }
                    }
                    else if (gameState[combination[0]] == 2 && gameState[combination[2]] == 2)
                    {
                        let button = view.viewWithTag(combination[1]+1) as! UIButton
                        if (gameState[combination[1]] == 0){
                            button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                            gameState[button.tag-1] = activePlayer
                            activePlayer = 1
                            AIPlayed = true
                        }
                    }
                    else
                    {
                        //do nothing
                    }
                }
            }
            if (AIPlayed == false){
                //if Player is about to win, stop them
                for combination in winningCombinations
                {
                    if (gameState[combination[0]] == 1 && gameState[combination[1]] == 1)
                    {
                        //works
                        let button = view.viewWithTag(combination[2]+1) as! UIButton
                        if (gameState[combination[2]] == 0){
                            button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                            gameState[button.tag-1] = activePlayer
                            activePlayer = 1
                            AIPlayed = true
                        }
                    }
                    else if (gameState[combination[1]] == 1 && gameState[combination[2]] == 1)
                    {
                        let button = view.viewWithTag(combination[0]+1) as! UIButton
                        if (gameState[combination[0]] == 0){
                            button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                            gameState[button.tag-1] = activePlayer
                            activePlayer = 1
                            AIPlayed = true
                        }
                    }
                    else if (gameState[combination[0]] == 1 && gameState[combination[2]] == 1)
                    {
                        let button = view.viewWithTag(combination[1]+1) as! UIButton
                        if (gameState[combination[1]] == 0){
                            button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                            gameState[button.tag-1] = activePlayer
                            activePlayer = 1
                            AIPlayed = true
                        }
                        
                    }
                }
            }
            if (AIPlayed == false){
                let numberArr = [1, 3, 5, 7, 9]
                //go for middle or corner randomly
                for num in numberArr{
                    let button = view.viewWithTag(num) as! UIButton
                    if (gameState[num-1] == 0){
                        button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                        gameState[button.tag-1] = activePlayer
                        activePlayer = 1
                        AIPlayed = true
                        break
                    }
                }
            }
            if (AIPlayed == false){
                //play random
                while true{
                    let randomNumber = Int.random(in: 1 ... 9)
                    let button = view.viewWithTag(randomNumber) as! UIButton
                    if (gameState[randomNumber-1] == 0){
                        button.setImage(UIImage(named:"O.png"), for: UIControl.State())
                        gameState[button.tag-1] = activePlayer
                        activePlayer = 1
                        AIPlayed = true
                        break
                    }
                }
            }
        }
    }
}

