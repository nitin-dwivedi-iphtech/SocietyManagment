//  SplashScreenView.swift
//  SocietyManagmentApp
//
//  Created by iPHTech 40 on 17/07/26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            SplashView(scale: logoScale, opacity: logoOpacity)
                .onAppear{
                    withAnimation(.spring(response: 1.0, dampingFraction: 0.38, blendDuration: 0)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                self.isActive = true
                            }
                        }
                    }
                }
        }
    }
}

struct SplashView:View{
    var scale: CGFloat
    var opacity: Double
    var body: some View{
        ZStack{
            LinearGradient(
                colors: [.grandBlack, .grandGreen, .grandBlack],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack{
                Image("app_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 38))
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Society Managment App")
                    .foregroundStyle(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
