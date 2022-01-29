//
//  CardView.swift
//  stacks
//
//  Created by jaydan on 12/10/21.
//

import SwiftUI

struct CardView: View {
    // flipped manages which side of the card is currently being drawn
    @State var flipped : Bool = false
    
    // animate3d controls the animation and maintains state as flipped toggles at 90 degress
    @Binding var animate3d : Bool
    @Binding var flipLeft : Bool
    @Binding var color : Color
    
    @Binding var clue : Fact
    @Binding var facts : [Fact]
    
    var body: some View {
        ZStack() {
            FrontSideView(clue: $clue, facts: $facts, color:$color)
                .opacity(flipped ? 0.0 : 1.0)
            BackSideView(clue: $clue, facts: $facts, color:$color)
                .opacity(flipped ? 1.0 : 0.0)
        }
        .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : (flipped == flipLeft ? 0 : 360), axis: (x: 0.0, y: 1)))
        .offset(y:-80)
    }
}

struct FlipEffect: GeometryEffect {
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        // toggle which side is being drawn based on current angle
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270
        }
        
        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height/2.0))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct FrontSideView : View {
    @Binding var clue : Fact
    @Binding var facts : [Fact]
    @Binding var color : Color
    
    var body: some View {

        Text(clue.fact)
            .padding(5)
            .frame(maxWidth: 300, maxHeight: 300)
            .opacity(1.0)
            .background(color)
            .cornerRadius(1.0)
            .font(.system(size:100))

    }
}

struct BackSideView : View {
    @Binding var clue : Fact
    @Binding var facts : [Fact]
    @Binding var color : Color
    
    var body: some View {
        VStack {
            ForEach (facts) { fact in
                if fact.fact != clue.fact
                {
                    Text(fact.fact)
                        .padding(5)
                        .opacity(1.0)
                        .cornerRadius(1.0)
                        .font(.system(size:60))
                        .padding()
                }
            }
        }
        .frame(maxWidth: 300, maxHeight: 300)
        .background(color)

    }
}

//struct FlippingView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(isFlipped: false)
//    }
//}
