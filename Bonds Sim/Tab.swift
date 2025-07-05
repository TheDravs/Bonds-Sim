//
//  Tab.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 27/03/2025.
//

import SwiftUI


struct TabViewContainer: View {
 
    @StateObject private var bondSettings = BondSettings()
    
    
    var body: some View {
           TabView {
               ContentView(bondSettings: bondSettings)
                   .tabItem {
                       Image(systemName: "chart.line.uptrend.xyaxis")
                       Text("Simulation")
                   }
               
               BondDetailsView(bondSettings: bondSettings)
                   .tabItem {
                       Image(systemName: "info.circle")
                       Text("Details")
                   }
               
               NewsView(newsViewModel: bondSettings)
                   .tabItem {
                       Image(systemName: "globe")
                       Text("News")
                   }
              
           }
       }
   }


   #Preview {
       TabViewContainer()
   }
