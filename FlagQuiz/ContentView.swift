//
//  ContentView.swift
//  FlagQuiz
//
//  Created by Jonathan Sweeney on 9/23/20.
//

import SwiftUI

struct FlagImage: View {
    var ImageName: String
    
    var body: some View {
        Image(ImageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .white, radius: 2)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var animationAmount = 0.0
    @State private var userTapped = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .leading)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                        self.userTapped = number
                        if number == self.correctAnswer {
                            withAnimation(.easeInOut(duration: 2)) {
                                self.animationAmount += 360
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                self.askQuestion()
                                
                            }
                        }
                    }) {
                        FlagImage(ImageName: self.countries[number])
                    }
                    .rotation3DEffect(
                        .degrees(self.animationAmount),
                        axis: (x: 0.0, y: number == self.userTapped ? 1.0 : 0, z: 0.0),
                        anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                        anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                        perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
                    )
                }
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    self.showingScore = false
                    self.score = 0
                    askQuestion()
                }) {
                    Text("Reset")
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .clipShape(Circle())
                        .font(.title)
                        .shadow(color: .white, radius: 4)
                }
            }
        }
        .alert(isPresented: $showingScore, content: {
            Alert(title: Text(scoreTitle), message: Text("That is the flag of \(countries[userTapped])"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        })
    }
    func flagTapped(_ number: Int) {
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong"
        score += number == correctAnswer ? 10 : -5
        print(score)
        showingScore = number != correctAnswer
    }
    
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
