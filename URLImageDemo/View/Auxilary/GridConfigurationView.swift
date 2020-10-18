//
//  GridConfigurationView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 18/10/2020.
//

import SwiftUI
import Combine


struct GridConfigurationView: View {

    @EnvironmentObject var appConfiguration: AppConfiguration

    @State private var input: String = ""

    var body: some View {
        Form {
            Section(header: Text("Item Length")) {
                TextField("Item Length", text: $input)
                    .keyboardType(.numberPad)
            }
        }
        .onAppear {
            input = String(Double(appConfiguration.grid.length))
        }
        .onDisappear {
            if let number = Double(input) {
                appConfiguration.grid.length = CGFloat(number)
            }
        }
    }
}


struct GridConfigurationPresentingView: View {

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: "gear")
                .imageScale(.large)
                .frame(minWidth: 44.0, minHeight: 44.0)
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                GridConfigurationView()
                    .navigationBarTitle("Grid Configuration", displayMode: .inline)
                    .navigationBarItems(leading: Button("Done") {
                        isPresented = false
                    } .frame(minWidth: 44.0, minHeight: 44.0))
            }
        }
    }

    @State private var isPresented = false
}


struct GridConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        GridConfigurationView()
    }
}
