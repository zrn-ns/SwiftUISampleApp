//
//  GithubRepositoryListItemView.swift
//  App
//
//  Created by zrn_ns on 2022/08/08.
//

import APIClient
import SwiftUI

struct GithubRepositoryListItemView: View {
    @State var githubRepository: MinimalGithubRepository

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(githubRepository.name)
                    .font(.title)
                    .foregroundColor(R.color.typoNormal.color)
                Spacer()
                Text("\(Image(systemName: "star"))\(githubRepository.stargazersCount)")
                    .font(.subheadline)
                    .foregroundColor(R.color.typoNormal.color)
            }
            HStack {
                if let desc = githubRepository.description {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(R.color.typoNormal.color)
                        .lineLimit(1)
                }
                Spacer()
                if let lang = githubRepository.language {
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

struct GithubRepositoryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        GithubRepositoryListItemView(githubRepository: MinimalGithubRepository(id: 1,
                                                             name: "repo_name",
                                                             description: "🎉Repo Description hogehogehogehogehoge",
                                                             language: "Swift",
                                                             stargazersCount: 3,
                                                             htmlUrl: URL(string: "https://google.com/")!,
                                                             isFork: false))
        .previewLayout(.sizeThatFits)
        .frame(width: 320)
    }
}
