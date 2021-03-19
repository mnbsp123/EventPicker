//
//  EventProductNamePicker.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 2/18/21.
//

import SwiftUI

struct EventProductNamePicker: View {
    
    @EnvironmentObject var event:EventViewModel
    
    var body: some View {
        
            print("EventProductNamePicker: selectedEventProduct: \($event.selectedEventProduct.wrappedValue), selectedEventAction: \($event.selectedEventAction.wrappedValue)")
        
        if $event.selectedEventType.wrappedValue == 1 && $event.selectedEventAction.wrappedValue > 0 {

            if (event.eventProducts.count > 0 && event.eventProducts[0].productName == nil){
                _ = event.fetchEventProducts()
            }

            let picker = AnyView(
                Picker(selection: $event.selectedEventProduct, label: Text("Product")) {
                    ForEach(0 ..< event.pickerProducts.count, id: \.self) { value in
                        Text("\(self.event.pickerProducts[value])").tag(value)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                .id(event.id))
            return picker
        }
        else{
            let picker = AnyView(EmptyView())
            return picker
        }
    }
}

struct EventProductNamePicker_Previews: PreviewProvider {
    static var previews: some View {
        EventProductNamePicker()
    }
}
