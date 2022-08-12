//
//  PagingView.swift
//  App
//
//  Created by zrn_ns on 2022/08/12.
//

import SwiftUI

struct PagingView: View {
    var body: some View {
        VStack(alignment: .center) {
            ProgressView()
                .progressViewStyle(.circular)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        PagingView()
            .previewLayout(.sizeThatFits)
            .frame(width: 320, alignment: .center)
    }
}
