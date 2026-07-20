//  SplashScreenView.swift
//  SocietyManagmentApp

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var isAnimating = false
    @State private var textAnimated = false
    
    var body: some View {
        ZStack {
            if isActive {
                ContentView()
                    .transition(.opacity)
            } else {
                SplashView(isAnimating: isAnimating, textAnimated: textAnimated)
                    .transition(.opacity)
                    .onAppear {
                        withAnimation(.spring(response: 0.9, dampingFraction: 0.6, blendDuration: 0)) {
                            isAnimating = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.easeOut(duration: 0.6)) {
                                textAnimated = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isActive)
    }
}

struct SplashView: View {
    var isAnimating: Bool
    var textAnimated: Bool
    
    @State private var ambientPulse = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.grandBlack, .grandGreen.opacity(0.25), .grandBlack],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color.grandGreen.opacity(0.12))
                .frame(width: 320, height: 320)
                .blur(radius: 50)
                .scaleEffect(isAnimating ? (ambientPulse ? 1.25 : 1.05) : 0.5)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        ambientPulse = true
                    }
                }
            
            VStack(spacing: 28) {
                Spacer()
                
                Image("app_icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 38, style: .continuous))
                    .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 12)
                    .shadow(color: .grandGreen.opacity(0.25), radius: 25, x: 0, y: 4)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)
                    .blur(radius: isAnimating ? 0 : 5)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                VStack(spacing: 10) {
                    Text("GreenValley")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .tracking(0.5)
                    
                    Text("SOCIETY MANAGEMENT")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                        .tracking(4.5)
                }
                .offset(y: textAnimated ? 0 : 15)
                .opacity(textAnimated ? 1.0 : 0.0)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
