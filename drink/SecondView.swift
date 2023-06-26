//
//  secondView.swift
//  drink
//
//  Created by 笠井翔雲 on 2023/06/06.
//

import SwiftUI

struct SecondView: View {
    @Binding var orders: [Order]
    @State var name: String = ""
    @State var age = 0
    @State var amount = 0
    @State var whiskey = 0

    var body: some View {
        VStack(spacing: 50) {
            TextField("ドリンメニュー入力", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("残り：\(age)ml")
                .font(.headline)
                .foregroundColor(.black)

            TextField("一本の容量を書いて下さい", value: $age, formatter: NumberFormatter())
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("一回に使う量を書いて下さい", value: $amount, formatter: NumberFormatter())
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: addOrder) {
                Text("追加")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                    )
            }
        }
        .padding()
    }

    private func addOrder() {
        let newOrder = Order(name: name, age: age, amount: amount, whiskey: whiskey)
        orders.append(newOrder)
        name = ""
        age = 0
        amount = 0
        whiskey = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

