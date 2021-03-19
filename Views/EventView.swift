//
//  EditView.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 1/14/21.
//

import SwiftUI
import Combine

struct EventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var event:EventViewModel
    
    var singleTagScan: TagScan?
    var tagScans: FetchedResults<TagScan>
    var editMode: EditMode
//    var selectKeeper: Set<String>
    
    let scanDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @State private var notes: String = ""
    @State private var filteredTagScans: [TagScan] = []
    @State private var filteredTagEvents: [TagEvent] = []
    @State private var selectedFilteredTagEvents: [TagEvent] = []
    @State private var displayedFilteredTagEvents: [TagEvent] = []
    @State private var replacementTagScanEid: String? = "Test EID"
    @State private var replacementTagScanDate: Date? = nil
    @State private var showingSaveAlert = false
    @State private var showingReplacementTagAlert = false
    @State private var haveSetReplacementTagAlert = false
    @State private var showReplacementTagButton = false
    
    @State private var formHeight: CGFloat? = 100
    
    @State var isActive: Bool = false
    
    var body: some View {
        VStack{
            VStack{
                Text("EID")
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0))
                    .foregroundColor(Color.black)
                    .background(Color.blue)
                
                if singleTagScan == nil{
                    //ScrollView {
                    List {
                        ForEach(filteredTagScans) { tagScan in
                            Text("\(tagScan.eid ?? "Unknown")")
                            //.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, minHeight: singleTagScan == nil ? 100 : 35, maxHeight: singleTagScan == nil ? 100 : 35, alignment: .leading)
                    .foregroundColor(Color.yellow)
                    .background(Color.blue)
                }
                
                //}
                else{
                    Text("\(singleTagScan?.eid ?? "Unknown EID")")
                        .padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0))
                        .frame(maxWidth: .infinity, minHeight: singleTagScan == nil ? 100 : 35, maxHeight: singleTagScan == nil ? 100 : 35, alignment: .leading)
                        .foregroundColor(Color.yellow)
                        .background(Color.blue)
                }
                
                
                Text("SCAN DATE")
                    .frame(maxWidth: .infinity, minHeight: 10, alignment: .leading)
                    .padding(EdgeInsets(top: 10, leading: 27, bottom: 0, trailing: 0))
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                
                Text("\($filteredTagScans.wrappedValue.map{ $0.scanDate ?? .distantPast}.max() ?? .distantPast, formatter: self.scanDateFormat)")
                    .font(Font.system(size: 18, weight: .heavy))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0))
                    .background(Color.blue)
            }
            .frame(maxWidth: .infinity, minHeight: singleTagScan == nil ? 220 : 160, alignment: .leading)
            
            
            ScrollView {
                VStack(){
                    Form {
                        //                    Section(header:
                        //                    //            VStack(alignment: .leading) {
                        //                                Text("EID")
                        //                                .padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0))
                        //                    //            }
                        //                    ){
                        //
                        //                        ScrollView {
                        //                            List {
                        //                                ForEach(filteredTagScans) { tagScan in
                        //                                    Text("\(tagScan.eid)")
                        //                                        .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 0))
                        //                                }
                        //                            }
                        //                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        //                            .frame(maxWidth: .infinity, minHeight: singleTagScan == nil ? 100 : 35, alignment: .leading)
                        //                            .foregroundColor(ColorManager.textHighlightColor)
                        //                            .background(ColorManager.backgroundColor)
                        //                        }
                        //                    }
                        
                        //                    Section (
                        //                        header:
                        //                            VStack(alignment: .leading) {
                        //                                Text("SCAN DATE")
                        //
                        //                                Text("\($filteredTagScans.wrappedValue.map{ $0.scanDate ?? .distantPast}.max() ?? .distantPast, formatter: self.scanDateFormat)")
                        //                                    .font(Font.system(size: 18, weight: .heavy))
                        //                                    .foregroundColor(ColorManager.labelTertiaryColor)
                        //                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        //                            }) {
                        //                        EmptyView()
                        //                    }
                        //                    .background(ColorManager.backgroundAlternateColor)
                        //                    .padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0))
                        
                        
                        Section{
                            
                            EventTypeNamePicker().environmentObject(event)
                            
                            EventActionNamePicker().environmentObject(event)
                            
                            EventProductNamePicker().environmentObject(event)
                            
                            if isSaveEnabled(){
                                Text("Notes")
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                                
                                TextEditor(text: self.$notes)
                                    //.addDoneButton()
                                    .frame(width: 375, height: 40, alignment: .leading)
                                    .foregroundColor(Color.yellow)
                                    .background(Color.blue)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
                        
                        
                    } //Form
                    .background(Color.gray)
                    .frame(width: 414, height: formHeight, alignment: Alignment.top)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    //.keyboardAdaptive()
                    //.adaptsToKeyboard()
                    
                    Button(action: {
                        print("add tapped")
                        if saveEvent
                        {
                            print("saveEvent success")
                            calcFormHeight()
                        }
                        else
                        {
                            print("saveEvent failed")
                            self.showingSaveAlert = true
                        }
                    })
                    {
                        Text("Add")
                            .padding()
                            .frame(width:322, height: 55)
                            .foregroundColor(Color.yellow)
                            .font(Font.system(size: 20).bold())
                    }
                    .alert(isPresented:$showingSaveAlert) {
                        Alert(title: Text("Event Save Error"),
                              message: Text("Unable to save the Event to Local Storage."),
                              dismissButton: .default(Text("OK")) {
                                print("Submitting...")
                              })
                    }
                    .frame(width:322, height: 55)
                    .background(isSaveEnabled() ? Color.pink : Color.orange)
                    .padding([.top, .bottom], 0)
                    .disabled(!isSaveEnabled())
                    
                    //if $event.selectedEventType.wrappedValue == 0 {
                    Spacer()
                    
                    if displayedFilteredTagEvents.count > 0 {
                        Text("UPDATES")
                            .font(Font.system(size: 14, weight: .light))
                            .foregroundColor(Color.pink)
                            .padding(EdgeInsets(top: 0, leading: 47, bottom: 0, trailing: 0))
                            .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                        
                        allEvents
                        //.frame(maxWidth: .infinity, minHeight: 169, alignment: .leading)
                        //}
                    }
                } //VStack
                .padding([.leading, .trailing], 20)
                .background(Color.blue)
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
                                                Text("EID Tags")
                                            }
                                        },
                                    trailing:
                                        Button(action: {
                                            
                                            $event.selectedEventType.wrappedValue = 0
                                            $event.selectedEventAction.wrappedValue = 0
                                            $event.selectedEventProduct.wrappedValue = 0
                                            notes = ""
                                            
                                            self.presentationMode.wrappedValue.dismiss()
                                        }) {
                                            HStack {
                                                Text("Done")
                                            }
                                        }
                )
                .navigationBarTitle("Edit", displayMode: .inline)
                .alert(isPresented: $showingReplacementTagAlert) {
                    Alert(title: Text("A New Tag Number Has Been Scanned!"),
                          dismissButton: .default(Text("Close")) {
                            print("Submitting...")
                          })
                }
                .onAppear(){
                    updateFilteredTagScans()
                    
                    //if !haveSetReplacementTagAlert {
                    //    haveSetReplacementTagAlert = true
                        if singleTagScan == nil {
                            showingReplacementTagAlert = false
                        }
                        else {
                            showingReplacementTagAlert = $event.mostRecentTagScanEid.wrappedValue != nil
                            $event.mostRecentTagScanEid.wrappedValue = nil
                        }
                    //}
                    calcFormHeight()
                }
                
            }
        } //VStack
        .background(Color.blue)
    }
    
    private func calcFormHeight() {
        formHeight = 100
        
        //formHeight! += (singleTagScan == nil ? 100 : 35)
        if $event.selectedEventType.wrappedValue > 0 {
            formHeight! += 50
        }
        if $event.selectedEventAction.wrappedValue > 0 {
            formHeight! += 50
        }
        if isSaveEnabled(){
            formHeight! += 100
        }
        
        print("EventView calcFormHeight: \(formHeight ?? 0.0)")
    }
    private func updateFilteredTagScans() {
        
        filteredTagScans.removeAll()
        filteredTagEvents.removeAll()
        selectedFilteredTagEvents.removeAll()
        displayedFilteredTagEvents.removeAll()
        
        if filteredTagScans.count == 0{
            if singleTagScan != nil{
                
                showReplacementTagButton = true
                
                replacementTagScanEid = singleTagScan?.eid
                replacementTagScanDate = singleTagScan?.scanDate
                
                //                filteredTagScans.append(singleTagScan!)
                //
                //
                //                if let events = singleTagScan?.tagEvent {
                //                    for event in events {
                //                        filteredTagEvents.append(event as! TagEvent)
                //                    }
                //                }
                
                let tmp = tagScans.filter { $0.eid == singleTagScan?.eid }
                filteredTagScans.append(contentsOf: tmp)
                
                for tag in tmp {
                    if let events = tag.tagEvent {
                        for event in events {
                            if (event as! TagEvent).eventType?.typeName != ""{
                                filteredTagEvents.append(event as! TagEvent)
                                selectedFilteredTagEvents.append(event as! TagEvent)
                                
                                if (event as! TagEvent).eventType?.typeId == 101{
                                    showReplacementTagButton = false
                                }
                            }
                        }
                    }
                }
                displayedFilteredTagEvents = filteredTagEvents
            }
//            else {
//                var s2: Set<eventTypeTuple>? = nil
//                for item in selectKeeper {
//                    let tmp = tagScans.filter { $0.eid == item }
//                    filteredTagScans.append(contentsOf: tmp)
//                    
//                    
//                    var starterEvents: Set = tmp.first?.tagEvent as! Set<TagEvent>
//                    
//                    if (s2 == nil){
//                        s2 = Set(starterEvents.map { eventTypeTuple(typeId: $0.typeId, actionId: $0.actionId, productId: $0.productId) })
//                    }
//                    
//                    for tag in tmp {
//                        if let events = tag.tagEvent {
//                            
//                            starterEvents = tag.tagEvent as! Set<TagEvent>
//                            
//                            let s3 = Set(starterEvents.map { eventTypeTuple(typeId: $0.typeId, actionId: $0.actionId, productId: $0.productId) })
//                            
//                            s2 = s2!.intersection(s3)
//                            
//                            for event in events {
//                                if (event as! TagEvent).eventType?.typeName != ""{
//                                    filteredTagEvents.append(event as! TagEvent)
//                                    let ev = event as! TagEvent
//                                    print("filteredTagEvent: EID: \(String(describing: ev.eid)), type: \(ev.typeId), action: \(ev.actionId), product: \(ev.productId)")
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                var tmpTagEvents = [TagEvent]()
//                
//                s2?.forEach{fe in
//                    var foundOne = false
//                    filteredTagEvents.forEach{event in
//                        if fe.typeId < 100 && event.typeId == fe.typeId && event.actionId == fe.actionId && event.productId == fe.productId {
//                            
//                            //                            var te = TagEvent()
//                            //                            te.actionId = fe.actionId
//                            //                            te.productId = fe.productId
//                            //                            te.typeId = fe.typeId
//                            //                            te.eventDate = Date()
//                            
//                            //                            tmpTagEvents.append(te)
//                            
//                            selectedFilteredTagEvents.append(event)
//                            
//                            if (!foundOne){
//                                tmpTagEvents.append(event)
//                                foundOne = true
//                            }
//                            
//                            s2?.remove(fe)
//                        }
//                    }
//                }
//                displayedFilteredTagEvents = tmpTagEvents
//                
//                
//                //var y = filteredTagEvents.filter(<#T##isIncluded: (TagEvent) throws -> Bool##(TagEvent) throws -> Bool#>)
//                //var z = filteredTagEvents.filter { $0.typeId in s2.map { $0.typeId } }
//            }
        }
    }
    var allEvents: some View{
        //ScrollView {
        //List {
        ForEach(displayedFilteredTagEvents.sorted(by: { (itemA, itemB) -> Bool in
            (itemA).eventDate ?? Date.distantPast > (itemB).eventDate ?? Date.distantPast
        })) { tagEvent in
            
                NavigationLink(destination:
                                EventEditView(tagEvent: tagEvent, filteredTagEvents: selectedFilteredTagEvents)
                                .environmentObject(event)
                ) {
                    TagEventDetail(tagEvent: tagEvent)
                }
        }
        .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(Color.black)
        .background(Color.blue)
    }
    
    
    
    var saveEvent: Bool {
        var results = true
        for tagScan in filteredTagScans {
            let result = event.addEvent(tagScan: tagScan, notes: $notes.wrappedValue)
            
            
            if (!results){
                results = result // did any fail?
            }
        }
        
        event.selectedEventType = 0
        event.selectedEventAction = 0
        event.selectedEventProduct = 0
        notes = ""
        
        filteredTagScans.removeAll()
        updateFilteredTagScans()
        
        return results
    }
    
    
    
    private func isSaveEnabled() -> Bool {
        return (($event.selectedEventType.wrappedValue == 1 && $event.selectedEventAction.wrappedValue != 0 && $event.selectedEventProduct.wrappedValue != 0)
                    || $event.selectedEventType.wrappedValue > 1)
    }
    
}

struct eventTypeTuple : Hashable {
    var typeId: Int64
    var actionId: Int64
    var productId: Int64
}


//struct AdaptsToKeyboard: ViewModifier {
//    @State var currentHeight: CGFloat = 0
//
//    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            content
//                .padding(.bottom, self.currentHeight)
//                .onAppear(perform: {
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
//                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
//                        .compactMap { notification in
//                            withAnimation(.easeOut(duration: 0.16)) {
//                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//                            }
//                        }
//                        .map { rect in
//                            rect.height - geometry.safeAreaInsets.bottom
//                        }
//                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
//                        .compactMap { notification in
//                            CGFloat.zero
//                        }
//                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//                })
//        }
//    }
//}
//
//extension View {
//    func adaptsToKeyboard() -> some View {
//        return modifier(AdaptsToKeyboard())
//    }
//}
