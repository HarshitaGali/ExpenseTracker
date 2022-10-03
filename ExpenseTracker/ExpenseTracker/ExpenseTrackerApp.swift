//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Harshita Gali on 30/09/2022.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
