//
//  NavigationLazyView.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 2/22/21.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
