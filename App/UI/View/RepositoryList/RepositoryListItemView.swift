//
//  RepositoryListItemView.swift
//  App
//
//  Created by zrn_ns on 2022/08/08.
//

import APIClient
import SwiftUI

struct RepositoryListItemView: View {
    @State var repository: MinimalRepository

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(repository.name)
                    .font(.title)
                    .foregroundColor(R.color.typoNormal.color)
                Spacer()
                Text("\(Image(systemName: "star"))\(repository.stargazersCount)")
                    .font(.subheadline)
                    .foregroundColor(R.color.typoNormal.color)
            }
            HStack {
                if let desc = repository.description {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(R.color.typoNormal.color)
                        .lineLimit(1)
                }
                Spacer()
                if let lang = repository.language {
                    Text(lang)
                        .font(.subheadline)
                        .foregroundColor(R.color.typoNormal.color)
                        .lineLimit(1)
                        .layoutPriority(.infinity)
                }
            }
        }.padding(.all, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RepositoryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListItemView(repository: MinimalRepository(id: 1,
                                                             name: "repo_name",
                                                             description: "🎉Repo Description hogehogehogehogehoge",
                                                             language: "Swift",
                                                             stargazersCount: 3,
                                                             htmlUrl: URL(string: "https://google.com/")!))
        .previewLayout(.sizeThatFits)
        .frame(width: 320)
    }
}
