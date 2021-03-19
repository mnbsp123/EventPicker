//
//  TagScanRowView.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 1/29/21.
//

import SwiftUI

struct TagScanRowView: View {
    @ObservedObject var tagScan: TagScan
    var showDetails: Bool
    
    let scanDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    var body: some View {
        HStack (alignment: .top) {
            
            if showDetails {
                Image(systemName: "pencil.circle")
                    .foregroundColor(tagScanFormatColor(tagScan: tagScan))
            }

            VStack(alignment: .leading) {
                
                Text(tagScan.eid ?? "Unknown EID")
                    .font(Font.system(size: 16))
                    .foregroundColor(tagScanFormatColor(tagScan: tagScan))
                
//                Text("\(tagScan.scanDate ?? Date.distantPast, formatter: self.scanDateFormat)")
//                    .font(Font.system(size: 16))
//                    .foregroundColor(tagScanFormatColor(tagScan: tagScan))
//
                Text(tagScan.tagEvent?
                        .sorted(by: { (itemA, itemB) -> Bool in
                            (itemA as! TagEvent).eventDate! > (itemB as! TagEvent).eventDate!
                        })
                        .map( { String(($0 as! TagEvent).eventType?.typeName ?? ".") } )
                        .joined(separator: ", ") ?? ".")
                    .font(Font.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
    }
    
    private func tagScanFormatColor(tagScan: TagScan) -> Color {
        
        return Color.pink
    }
}

//struct TagScanRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagScanRowView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(UserAppSettings())
//            .environmentObject(EventViewModel())
//    }
//}
