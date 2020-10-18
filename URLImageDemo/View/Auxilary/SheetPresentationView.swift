//
//  SheetPresentationView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 18/10/2020.
//

import SwiftUI

struct SheetPresentationView<Label: View, Content: View>: View {

    var label: () -> Label

    var content: () -> Content

    init(label: @escaping () -> Label, content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }

    var body: some View {
        Button(action: { isPresented = true }, label: label)
        .sheet(isPresented: $isPresented) {
            NavigationView {
                content()
                    .navigationBarTitle("Grid Configuration", displayMode: .inline)
                    .navigationBarItems(leading: Button("Done") {
                        isPresented = false
                    } .frame(minWidth: 44.0, minHeight: 44.0))
            }
        }
    }

    @State private var isPresented = false
}


extension View {

    func sheet<Label: View>(label: @escaping () -> Label) -> some View  {
        SheetPresentationView(label: label) { self }
    }

    func configurationSheet() -> some View  {
        sheet {
            Image(systemName: "gear")
                .imageScale(.large)
                .frame(minWidth: 44.0, minHeight: 44.0)
        }
    }

    func infoSheet() -> some View  {
        sheet {
            Image(systemName: "info.circle")
                .imageScale(.large)
                .frame(minWidth: 44.0, minHeight: 44.0)
        }
    }
}


struct SheetPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        SheetPresentationView(label: { Image(systemName: "gear").imageScale(.large).frame(minWidth: 44.0, minHeight: 44.0) }) { Text("Hello, world!") }
    }
}
