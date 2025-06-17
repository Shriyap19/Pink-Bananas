//
//  circlesubview.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 6/3/25.
//

import SwiftUI


struct circlesubview: View {
    @State private var symbolname = "largecircle.fill.circle"
    var body: some View {
        VStack {
            Text("Home Page").padding(.leading).font(.custom("Furtura", size: 40)).frame(alignment: .top)
            //Can't being Home PAge text to the top
            
            Spacer()
        }
           
            
       
          
            
            
        VStack {
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                ForEach(1...4, id: \.self) { y in GridRow {
                    ForEach(1...7, id: \.self) { x in
                        VStack(spacing: 0){
                            Image(systemName:symbolname ).font(.largeTitle).foregroundColor(.gray)
                                .frame(maxWidth: 60, maxHeight: 100)
                                .aspectRatio(1, contentMode: .fit)
                            Text(String(y*x)).font(.callout).foregroundColor(.gray)
                        }
                       
                        
                    }
                }
                    
                }
                
            }
            Spacer().frame(height:290)

        }
            
        
       
        

    }
}

#Preview {
    circlesubview()
}
