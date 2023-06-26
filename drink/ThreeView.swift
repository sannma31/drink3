//
//  ThreeView.swift
//  drink
//
//  Created by 笠井翔雲 on 2023/06/15.
//

import SwiftUI
import UserNotifications

struct ThreeView: View {
    @Binding var orders: [Order]
    @Binding var selectedOrder: Order?
    @State private var isShowingAlert = false

    var body: some View {
        List {
            ForEach(orders) { order in
                VStack {
                    Text(order.name)
                        .font(.headline)
                        .padding(.bottom, 5)

                    HStack {
                        Text("一本の容量：\(order.whiskey)ml")
                        Text("一回の量：\(order.amount)ml")
                        Text("通知の残り：\(order.suuji)ml")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)

                    Divider()
                }
            }
            .onDelete(perform: deleteOrder)
        }
        .listStyle(PlainListStyle())
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("注文を削除"),
                message: Text("この注文を削除してもよろしいですか？"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("削除"), action: deleteSelectedOrder)
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }

    private var backButton: some View {
        Button(action: {
            selectedOrder = nil
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.blue)
        }
    }

    private func deleteOrder(at offsets: IndexSet) {
        if let index = offsets.first {
            let deletedOrder = orders[index]
            if selectedOrder == deletedOrder {
                selectedOrder = nil
            }
            orders.remove(atOffsets: offsets)
        }
    }

    private func deleteSelectedOrder() {
        if let selectedOrder = selectedOrder,
           let index = orders.firstIndex(of: selectedOrder) {
            self.selectedOrder = nil
            orders.remove(at: index)
        }
    }
}
