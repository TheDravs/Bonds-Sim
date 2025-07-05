//
//  ContentView.swift
//  Bonds Sim
//
//  Created by Matthieu Draveny on 24/03/2025.
//

import SwiftUI

struct ContentView: View {
    // Utiliser l'objet observé passé par TabViewContainer
    @ObservedObject var bondSettings: BondSettings
    
    @FocusState private var isFaceValueFocused: Bool
    
    
    @State private var showingInputError = false
    @State private var inputErrorMessage = ""
    @State private var inputFaceValueText = ""
    
    
// MARK: Formatter
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.maximum = 1000000  // Set a high maximum
        return formatter
    }()
    
    // MARK: Start of the code
    var body: some View {
       
        
        NavigationStack {
           
            VStack {
           
                List {
                    
                
                    
                     Section {
                         
                         VStack(alignment: .leading) {
                             Text("$" + String(format: "%.2f", bondSettings.bondPriceDynamic))
                                 .fontWeight(.bold)
                                 .foregroundStyle(.white)
                                 .padding()
                                 .frame(maxWidth: .infinity)
                                 .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .trailing))
                                 .clipShape(RoundedRectangle(cornerRadius: 12))
                                 .shadow(color: Color.blue.opacity(0.3), radius: 5, x:0,y:2)
                             
                         }
                     }
                    
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("Credit Parameters")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.bottom, 5)
                            
                            VStack {
                                HStack {
                                    Text("Face Value: $")
                                        .foregroundColor(.primary)
                                    
                                    ZStack(alignment: .leading) {
                                                TextField("", text: $inputFaceValueText)
                                                        .keyboardType(.decimalPad)
                                                        .focused($isFaceValueFocused)
                                                        .toolbar {
                                                            ToolbarItemGroup(placement: .keyboard) {
                                                                Spacer()
                                                                Button("Done") {
                                                                    isFaceValueFocused = false
                                                                }
                                                            }
                                                        }
                                                        .onAppear {
                                                        inputFaceValueText = "\(Int(bondSettings.faceValue))"
                                                                               }
                                                        .onChange(of: inputFaceValueText) { newValue in
                                                        validateAndUpdateFaceValue(newValue)
                                                            }
                                                        .padding()
                                                        .background(Color(.systemGray6))
                                                        .cornerRadius(8)
                                                        .overlay(
                                                        
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(showingInputError ? Color.red : Color.gray.opacity(0.3), lineWidth: showingInputError ? 2 : 1)
                                                                )
                                                                }
                                                        .accessibilityLabel("Face Value Input")
                                                        }
                                                                   
                                                    // Error message display
                                                    if showingInputError {
                                                    Text(inputErrorMessage)
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .padding(.top, 4)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .transition(.opacity)
                                                    }
                                
                                Picker("Coupon Rate", selection: $bondSettings.couponRate) {
                                    ForEach(Array(stride(from: bondSettings.couponSpreadRange.lowerBound,
                                                         through: bondSettings.couponSpreadRange.upperBound,
                                                         by: 0.01)), id: \.self) { value in
                                        Text(String(format: "%.2f%%", value * 100)) // Multiply by 100 and append "%" symbol
                                            .tag(value)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                
                                Picker("Required Rate", selection: $bondSettings.requiredRate) {
                                    ForEach(Array(stride(from: bondSettings.creditSpreadRange.lowerBound,
                                                         through: bondSettings.creditSpreadRange.upperBound,
                                                         by: 0.01)), id: \.self) { value in
                                        Text(String(format: "%.2f%%", value * 100)) // Multiply by 100 and append "%" symbol
                                            .tag(value)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            .padding(.vertical, 15)
                        }
                        
                        Section {
                            VStack(alignment: .leading) {
                                Text("Maturity")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Slider(value: $bondSettings.maturity, in: 1...15, step: 1.0) {
                                    Text("Bond's Maturity")
                                }
                                .padding(.vertical, 5)
                                .accentColor(.blue)
                                .padding(.vertical, 5)
                                
                                HStack {
                                    Spacer()
                                    Text(String(format: "%.0f", bondSettings.maturity))
                                    Text("years")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.1))
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 3))
                }
            }
            .navigationTitle(Text("Bond Sim"))
            .alert("Invalid Input", isPresented: $showingInputError) {
                           Button("OK", role: .cancel) {
                               resetValidation()
                           }
                       } message: {
                           Text(inputErrorMessage)
                       }
        }
    }
    // MARK: - Validation Functions
        
        private func validateAndUpdateFaceValue(_ input: String) {
            // Clear any existing errors
            showingInputError = false
            
            // Remove any non-numeric characters except decimal point
            let filteredInput = input.filter { "0123456789.".contains($0) }
            
            // If input was filtered, update the text field
            if filteredInput != input {
                inputFaceValueText = filteredInput
            }
            
            // Check if it has more than one decimal point
            if filteredInput.filter({ $0 == "." }).count > 1 {
                showError("Invalid number format")
                return
            }
            
            // Allow empty input without validation
            if filteredInput.isEmpty {
                inputFaceValueText = ""
                return
            }

            // Check if it's a valid number
            guard let value = Double(filteredInput) else {
                return
            }
            
            // Validate value range
            if value <= 0 {
                showError("Face value must be greater than zero")
                return
            }
            
            if value > 1000000 {
                showError("Face value cannot exceed $1,000,000")
                return
            }
            
            // If we reach here, update the bond settings
            bondSettings.faceValue = value
        }
        
        private func showError(_ message: String) {
            inputErrorMessage = message
            showingInputError = true
        }
        
        private func resetValidation() {
            // Reset to current bond setting value
            inputFaceValueText = "\(Int(bondSettings.faceValue))"
            showingInputError = false
        
    }
}


#Preview {
    ContentView(bondSettings: BondSettings())
}
