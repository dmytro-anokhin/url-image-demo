//
//  GridConfigurationView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 18/10/2020.
//

import SwiftUI
import Combine


struct GridConfigurationView: View {

    var body: some View {
        Form {
            Section(header: Text("Item Length")) {
                TextField("Item Length", text: $input)
                    .keyboardType(.numberPad)
            }
        }
        .onAppear {
            input = String(Double(appConfiguration.gridConfiguration.length))
        }
        .onDisappear {
            if let number = Double(input) {
                appConfiguration.gridConfiguration.length = CGFloat(number)
            }
        }
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration

    @State private var input: String = ""
}


struct GridConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        GridConfigurationView()
    }
}
