//
//  ContentView.swift
//  RockPaperLose
//
//  Created by jacob aberasturi on 1/19/23.
//

import SwiftUI

struct MoveImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 100))
    }
}

extension View {
    func moveImage() -> some View {
        modifier(MoveImageModifier())
    }
}

struct ContentView: View {
                                  // Rock, Paper, Scissors
    private let moves: [String] = ["mountain.2", "doc.fill", "scissors"]
    private let winningMoves = ["doc.fill", "scissors", "mountain.2"]
    private var initMove: String {
        moves.randomElement() ?? "Rock"
    }
    @State private var currentMove = Int.random(in: 0...2)
    @State private var winOrLose = Bool.random()
    
    // game ends in 10 turns
    @State private var turn = 1
    @State private var score = 0
    
    @State private var showResult = false
    @State private var result = ""
    @State private var gameOver = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Text("RockPaperLose?")
                    .font(.largeTitle)
                    .bold()
                
                Text("Turn Number: \(turn)")
                
                Spacer()
                
                Image(systemName: moves[currentMove]).moveImage()
                Spacer()
                Text("Goal: \(winOrLose ? "Win" : "Lose")!").font(.title)
            
                HStack {
                    ForEach(moves.filter{$0 != moves[currentMove]},
                            id: \.self) { choice in
                        Button {
                            checkIfScore(choice)
                        } label: {
                            Image(systemName: choice).moveImage()
                        }
                    }
                }
                Spacer()
                Text("Score: \(score)").font(.title2)
                Spacer()
            }
        }
        .alert("Result!", isPresented: $showResult) {
            Button("next!", action: nextTurn)
        } message: {
            Text("You were \(result)")
        }
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Restart?", action: restart)
        } message: {
            Text("Your final score was \(score)")
        }
    }
    func checkIfScore(_ choice: String) -> Void {
        if turn > 9 {
            showResult = false
            gameOver = true

        }
        if winOrLose && choice == winningMoves[currentMove] || !winOrLose && choice != winningMoves[currentMove]{
            score += 1
            result = "Correct!"
        }
        else {
            result = "Wrong!"
        }
        if gameOver {
            return
        }
        else {
            showResult = true
        }
    }
    
    func nextTurn() -> Void {
        currentMove = Int.random(in: 0...2)
        winOrLose.toggle()
        turn += 1
    }
                   
    func restart() {
        nextTurn()
        turn = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
