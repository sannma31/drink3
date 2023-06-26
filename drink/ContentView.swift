//
//  ContentView.swift
//  drink
//
//  Created by 笠井翔雲 on 2023/06/06.
//

import SwiftUI
import  UserNotifications

struct ContentView: View {
    @State var orders = [Order]()
    @State var buttonText = "5秒後にローカル通知を発行する"
        
        //通知関係メソッド
    func makeNotification(){
        //通知タイミングを指定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //通知コンテンツの作成
        let content = UNMutableNotificationContent()
        content.title = "ドリンクバー"
        content.body = "商品が切れそうだよ！"
        content.sound = UNNotificationSound.default
        
        //通知リクエストを作成
        let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    var body: some View {
        NavigationView {
            VStack {
                ForEach(orders.indices, id: \.self) { index in
                    OrderView(order: $orders[index])
                        .padding()
                    
                    NavigationLink(
                        destination: SecondView(orders: $orders),
                        label: {
                            Text("編集")
                        }
                    )
                    .padding()

                    Button(action: {
                        orders.remove(at: index)
                    }) {
                        Text("削除")
                    }
                    .padding()
                }
                Button(action: {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                                (granted, error) in
                                if granted {
                                    //通知が許可されている場合の処理
                                    makeNotification()
                                }else {
                                    //通知が拒否されている場合の処理
                                    //ボタンの表示を変える
                                    buttonText = "通知が拒否されているので発動できません"
                                    //1秒後に表示を戻す
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    buttonText = "5秒後にローカル通知を発行する"
                                    }
                                }
                            }
                        }) {
                            //ボタンのテキストを表示
                            Text(buttonText)
                        }
                NavigationLink(
                    destination: SecondView(orders: $orders),
                    label: {
                        Text("入力")
                    }
                )
                .padding()
            }
            .padding()
            .navigationTitle("ドリンクオーダー")
        }
    }
}


struct OrderView: View {
    @Binding var order: Order
    
    var body: some View {
        VStack {
            Text("\(order.name)")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
            
            VStack {
                Text("残り：\(order.age)ml")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                
                Button(action: {
                    decreaseAmount()
                }) {
                    Text("一回に使う量を減らす")
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                        )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
        }
    }
    
    private func decreaseAmount() {
        if order.age >= order.amount {
            order.age -= order.amount
        }
    }
}

struct Order: Identifiable {
    let id = UUID()
    let name: String
    var age: Int
    var amount: Int
    var whiskey: Int {
        didSet {
            age = whiskey + amount
        }
    }
}

