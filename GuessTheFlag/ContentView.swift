//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aleksey Nosik on 26.09.2022.
//

import SwiftUI

struct FlagImage: View {
    var forFlags: String

    var body: some View {
        Image(forFlags)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

struct ContentView: View {
    
    @State private var animationAmount = 1.0
    @State private var myOpacity = 1.0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var currentScore = 0
    @State private var theEndGame = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold() )
                    .foregroundColor(.white)
                
                VStack(spacing: 40) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) { number in
                        Button {
                            tappedFlag(number)
                            withAnimation {
                                switch number == correctAnswer {
                                case true: animationAmount += 360
                                case false: animationAmount = 0
                                }
                            }
                        } label: {
                            FlagImage(forFlags: countries[number])
                        }
                        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                        .opacity(myOpacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(currentScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert("Congrats. You won", isPresented: $theEndGame) {
            Button("New Game", action: reset)
        } message: {
            Text("Tap \"New Game\" for start")
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(currentScore)")
        }
    }
    
    func tappedFlag(_ number: Int) {
    
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
    
            if currentScore > 4 {
                theEndGame = true
                return
            }
        } else {
            scoreTitle = "Wrong. Its flag of \(countries[number])"
            currentScore -= 1
          
            if currentScore < 0 {
                currentScore = 0
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        myOpacity = 1
    }
    
    func reset() {
        askQuestion()
        currentScore = 0
        myOpacity = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
