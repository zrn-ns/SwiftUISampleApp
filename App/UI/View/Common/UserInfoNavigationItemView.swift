//
//  UserInfoNavigationItemView.swift
//  App
//
//  Created by zrn_ns on 2022/08/12.
//

import Kingfisher
import SwiftUI

struct UserInfoNavigationItemView: View {
    let userIconURL: URL?
    let userName: String?

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            KFImage(userIconURL)
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
                .scaledToFit()
                .cornerRadius(5)
            Text(userName ?? "")
                .font(.title3)
                .foregroundColor(R.color.typoNormal.color)
        }
    }
}

struct UserInfoNavigationItemView_Previews: PreviewProvider {

    static var previews: some View {
        UserInfoNavigationItemView(userIconURL: .init(string: "https://avatars.githubusercontent.com/u/583231"),
                                   userName: "Octocat")
            .previewLayout(.sizeThatFits)
    }
}
