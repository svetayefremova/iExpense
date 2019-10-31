//
//  AddView.swift
//  iExpense
//
//  Created by Yes on 30.10.2019.
//  Copyright © 2019 Yes. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                Button("Save") {
                    self.save()
                }
            )
            .alert(isPresented: $showError) {
                Alert(
                    title: Text(errorTitle),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
    
    func save() {
        guard self.isNotEmpty(self.amount) else {
            self.error(title: "The Amount is required", message: "")
            return
        }
        
        guard self.isNotEmpty(self.name) else {
            self.error(title: "The Name is required", message: "")
            return
        }
        
        guard self.isValidAmount(self.amount) else {
            self.error(title: "The Amount must be a number", message: "Use real price!")
            return
        }
        
        if let actualAmount = Int(self.amount) {
            let item = ExpenseItem(
                name: self.name,
                type: self.type,
                amount: actualAmount
            )
            self.expenses.items.append(item)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func isNotEmpty(_ field: String) -> Bool {
        (field != "")
    }
    
    func isValidAmount(_ amount: String) -> Bool {
        (Int(amount) != nil)
    }
    
    func error(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
