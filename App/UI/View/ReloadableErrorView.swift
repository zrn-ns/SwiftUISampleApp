//
//  ReloadableErrorView.swift
//  App
//
//  Created by zrn_ns on 2022/08/07.
//

import SwiftUI

struct ReloadableErrorView: View {
    @State var errorMessage: String
    var tapReloadHandler: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(errorMessage).multilineTextAlignment(.center)
            Button(Localizable.reload()) {
                tapReloadHandler?()
            }
        }.padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
    }
}

struct ReloadableEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ReloadableErrorView(errorMessage: "読み込みに失敗しました。読み込みに失敗しました。読み込みに失敗しました。") {
            print("tapped reload")
        }
    }
}
