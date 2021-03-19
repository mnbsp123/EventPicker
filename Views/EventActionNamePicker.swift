//
//  EventActionNamePicker.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 2/18/21.
//

import SwiftUI

struct EventActionNamePicker: View {
    
    @EnvironmentObject var event:EventViewModel
    
    var body: some View {
        
        print("EventActionNamePicker: selectedEventAction: \($event.selectedEventAction.wrappedValue), selectedEventType: \($event.selectedEventType.wrappedValue)")

        if $event.selectedEventType.wrappedValue == 1 {

            if (event.eventActions.count > 0 && event.eventActions[0].actionName == nil){
                _ = event.fetchEventActions()
            }
            
            let picker = AnyView( Picker(selection: $event.selectedEventAction, label: Text("Action")) {
                    ForEach(0 ..< event.pickerActions.count, id: \.self) { value in
                        Text("\(self.event.pickerActions[value])").tag(value)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            )
            return picker
        }
        else{
            let picker = AnyView(EmptyView())
            return picker
        }
    }
}

struct EventActionNamePicker_Previews: PreviewProvider {
    static var previews: some View {
        EventActionNamePicker()
    }
}
