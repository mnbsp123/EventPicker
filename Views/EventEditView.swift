//
//  EventEditView.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 2/18/21.
//

import SwiftUI

struct EventEditView: View {
    
    @EnvironmentObject var event:EventViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var tagEvent: TagEvent
    var filteredTagEvents: [TagEvent]
    @State private var notes: String = ""
    @State private var notInitialized = true
    @State private var showingDeleteAlert = false
    @State private var showingSaveAlert = false
    
    @State var isActive: Bool = false
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        
        VStack(){
            
            if (!keyboardResponder.isKeyboardVisible){
                VStack{
                    Text("EID")
                        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 0))
                        .foregroundColor(Color.yellow)
                        .background(Color.gray)
                    
                    //ScrollView {
                    List {
                        ForEach(filteredTagEvents.unique{$0.eid}) { tagScan in
                            Text("\(tagScan.eid ?? "Unknown")")
                            //.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, minHeight: filteredTagEvents.unique{$0.eid}.count > 1 ? 100 : 35, maxHeight: filteredTagEvents.unique{$0.eid}.count > 1 ? 100 : 35, alignment: .leading)
                    .foregroundColor(Color.yellow)
                    .background(Color.blue)
                }
                .frame(maxWidth: .infinity, minHeight: filteredTagEvents.unique{$0.eid}.count > 1 ? 160 : 100, alignment: .topLeading)
                
                
                //Spacer()
                //.frame(height:300)
            }
            Form{
                //                Section(header:
                //                            Text("EID")){
                //
                //                    //ScrollView {
                //                        List {
                //                            ForEach(filteredTagEvents.unique{$0.eid}) { tagEvent in
                //                                Text("\(tagEvent.eid ?? "")")
                //                            }
                //                        }
                //                        .frame(width: 375, height: filteredTagEvents.unique{$0.eid}.count > 1 ? 100 : 35, alignment: .leading)
                //                        .foregroundColor(ColorManager.textHighlightColor)
                //                        .background(ColorManager.backgroundColor)
                //                    //}
                //                }
                
                
                //                Section(header:
                //                    Text("EID")){
                //                    Text("\(tagEvents.first!.eid ?? "Unknown")")
                //                        .frame(width: 375, height: 35, alignment: .leading)
                //                        .foregroundColor(ColorManager.textHighlightColor)
                //                        .background(ColorManager.backgroundColor)
                //                }
                //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Section{
                    EventTypeNamePicker().environmentObject(event).disabled(keyboardResponder.isKeyboardVisible)
                    
                    EventActionNamePicker().environmentObject(event).disabled(keyboardResponder.isKeyboardVisible)
                    
                    EventProductNamePicker().environmentObject(event).disabled(keyboardResponder.isKeyboardVisible)
                    
                    if isSaveEnabled(){
                        HStack{
                            Text("Notes")
                                .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
                            
                            Spacer()
                            
                            if (keyboardResponder.isKeyboardVisible){
                                Button("Done") {
                                    //self.enteredNumber = self.someNumber
                                    //self.someNumber = "" // Clear text
                                    UIApplication.shared.endEditing() // Call to dismiss keyboard
                                }
                            }
                        }
                        
                        TextEditor(text: self.$notes)
                            .frame(width: 375, height: 80, alignment: .leading)
                            .foregroundColor(Color.yellow)
                            .background(Color.blue)
                        //                            .keyboardAdaptive()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
            } //Form
            //.offset(y: -keyboardResponder.currentHeight*0.10)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    Button(action: {
                                        
                                        $event.selectedEventType.wrappedValue = 0
                                        $event.selectedEventAction.wrappedValue = 0
                                        $event.selectedEventProduct.wrappedValue = 0
                                        notes = ""
                                        
                                        self.presentationMode.wrappedValue.dismiss()
                                    }) {
                                        HStack {
                                            Image(systemName: "chevron.left")
                                            Text("Close")
                                        }
                                    },
                                trailing:
                                    Button(action: {
                                        self.showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Text("Delete")
                                            Image("delete24Px")
                                        }
                                    }
                                    .alert(isPresented:$showingDeleteAlert) {
                                        Alert(title: Text("Delete this event?"),
                                              message: Text("Are you sure you want to delete this event?"),
                                              primaryButton: .destructive(Text("Delete")) {
                                                print("Deleting...")
                                                
                                                if deleteEvent{
                                                    
                                                    self.presentationMode.wrappedValue.dismiss()
                                                    
                                                    $event.selectedEventType.wrappedValue = 0
                                                    $event.selectedEventAction.wrappedValue = 0
                                                    $event.selectedEventProduct.wrappedValue = 0
                                                    notes = ""
                                                }
                                              },
                                              secondaryButton: .cancel())
                                    })
            .navigationBarTitle("Edit Update", displayMode: .inline)
            .onAppear(){
                initTagEvent()
            }
            
            Spacer()
            
            if (!keyboardResponder.isKeyboardVisible){
                Button(action: {
                    print("add tapped")
                    if updateEvent
                    {
                        print("updateEvent success")
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else
                    {
                        print("updateEvent failed")
                        self.showingSaveAlert = true
                    }
                })
                {
                    Text("Save")
                        .padding()
                        .frame(width:414, height: 55)
                        .foregroundColor(Color.pink)
                        .font(Font.system(size: 20).bold())
                }
                .alert(isPresented:$showingSaveAlert) {
                    Alert(title: Text("Event Save Error"),
                          message: Text("Unable to save the Event to Local Storage."),
                          dismissButton: .default(Text("OK")) {
                            print("Submitting...")
                          })
                }
                .frame(width:414, height: 55)
                .background(isSaveEnabled() ? Color.pink : Color.orange)
                .padding([.top, .bottom], 0)
                .disabled(!isSaveEnabled())
            }
            
            
        } //VStack
        //.offset(y: -keyboardResponder.currentHeight*0.10)
        //        .padding([.leading, .trailing], 20)
        //        .background(ColorManager.backgroundAlternateColor)
    }
    
    private func initTagEvent(){
        if (notInitialized){
            notInitialized = false
            
            $event.selectedEventType.wrappedValue = $event.pickerTypes.wrappedValue.firstIndex(of: tagEvent.eventType?.typeName ?? "none") ?? 0
            $event.selectedEventAction.wrappedValue = $event.pickerActions.wrappedValue.firstIndex(of: tagEvent.eventAction?.actionName ?? "none") ?? 0
            $event.selectedEventProduct.wrappedValue = $event.pickerProducts.wrappedValue.firstIndex(of: tagEvent.eventProduct?.productName ?? "none") ?? 0
            
            notes = tagEvent.notes ?? ""
        }
    }
    
    private func isSaveEnabled() -> Bool {
        return (($event.selectedEventType.wrappedValue == 1 && $event.selectedEventAction.wrappedValue != 0 && $event.selectedEventProduct.wrappedValue != 0)
                    || $event.selectedEventType.wrappedValue > 1)
    }
    
    var updateEvent: Bool {
        var result: Bool = true
        
        let typeId = tagEvent.typeId
        let actionId = tagEvent.actionId
        let productId = tagEvent.productId
        
        filteredTagEvents.forEach { filteredTagEvent in
            if (filteredTagEvent.typeId == typeId && filteredTagEvent.actionId == actionId && filteredTagEvent.productId == productId){
                //print("EventEditView.updateEvent flt: EID: \(filteredTagEvent.eid ?? "default eid"), type: \(filteredTagEvent.typeId), action: \(filteredTagEvent.actionId), product: \(filteredTagEvent.productId)")
                result = event.updateEvent(tagEvent: filteredTagEvent, notes: notes)
            }
        }
        
        event.selectedEventType = 0
        event.selectedEventAction = 0
        event.selectedEventProduct = 0
        
        notes = ""
        
        return result
    }
    
    var deleteEvent: Bool{
        var result: Bool = true
        
        let typeId = tagEvent.typeId
        let actionId = tagEvent.actionId
        let productId = tagEvent.productId
        
        //do {
            
            filteredTagEvents.forEach { filteredTagEvent in
                if (filteredTagEvent.typeId == typeId && filteredTagEvent.actionId == actionId && filteredTagEvent.productId == productId){
                    result = event.deleteEvent(tagEvent: filteredTagEvent)
                }
            }
            
            event.selectedEventType = 0
            event.selectedEventAction = 0
            event.selectedEventProduct = 0
            
            notes = ""
        //} catch {
        //    print("EventEditView Delete Error: \(error)\nCould not save Core Data context.")
        //}
        return result
    }
}

//extension Sequence where Iterator.Element: Hashable {
//    func unique() -> [Iterator.Element] {
//        var seen: Set<Iterator.Element> = []
//        return filter { seen.insert($0).inserted }
//    }
//}
extension Array {
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
struct EventEditView_Previews: PreviewProvider {
    static var previews: some View {
        EventEditView(tagEvent: TagEvent(), filteredTagEvents: [TagEvent]())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(EventViewModel())
    }
}



// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
