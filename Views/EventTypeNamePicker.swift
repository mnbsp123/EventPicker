//
//  EventTypeNamePicker.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 2/18/21.
//

import SwiftUI

struct EventTypeNamePicker: View {
    
    @EnvironmentObject var event:EventViewModel
    
    var body: some View {

        print("EventTypeNamePicker: selectedEventType: \($event.selectedEventType.wrappedValue)")
        
        if (event.eventTypes.count > 0 && event.eventTypes[0].typeName == nil){
            _ = event.fetchEventTypes()
        }
        
        let picker = Picker(selection: $event.selectedEventType, label: Text("Event")) {
            ForEach(0 ..< event.pickerTypes.count, id: \.self) { value in
                Text("\(self.event.pickerTypes[value])").tag(value)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
        
        return picker
    }
}

struct EventTypeNamePicker_Previews: PreviewProvider {
    static var previews: some View {
        EventTypeNamePicker()
    }
}
