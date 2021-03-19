//
//  TagEventDetail.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 2/22/21.
//

import SwiftUI

struct TagEventDetail: View {
    var tagEvent: TagEvent
    
    @State private var formHeight: CGFloat? = 0
    
    var body: some View {
        
        //Print("TagEventDetail: EID: \(tagEvent.eid ?? "default eid"), type: \(tagEvent.typeId), action: \(tagEvent.actionId), product: \(tagEvent.productId)")
        
        VStack (alignment: .leading){
            HStack {
            Text("\(tagEvent.eventType?.typeName ?? "")")
                .font(Font.system(size: 18, weight: .bold))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 10)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(Font.system(size: 16, weight: .light))
                    .padding([.trailing], 50)
                    .padding([.top, .bottom], 10)
            }
            if (tagEvent.eventAction?.actionName ?? "") != "" {
                Text("\(tagEvent.eventAction?.actionName ?? "")")
                    .font(Font.system(size: 18, weight: .light))
                    .padding([.leading, .trailing], 40)
                Text("\(tagEvent.eventProduct?.productName ?? "")")
                    .font(Font.system(size: 18, weight: .regular))
                    .padding([.leading, .trailing], 40)
            }
            Text("\(tagEvent.notes ?? "")")
                .font(Font.system(size: 18, weight: .regular))
                .padding([.leading, .trailing], 40)
        }
        .onAppear(){
            calcFormHeight()
        }
        .frame(maxWidth: .infinity, minHeight: formHeight, alignment: Alignment.topLeading)
    }
    
    private func calcFormHeight() {
        formHeight = 80
        
        if tagEvent.typeId == 1 {
            formHeight! += 40
        }
        
        //print("TagEventDetail calcFormHeight: \(formHeight ?? 0.0)")
    }
}
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
struct TagEventDetail_Previews: PreviewProvider {
    static var previews: some View {
        TagEventDetail(tagEvent: TagEvent())
    }
}
