//
//  MainView.swift
//  Main view of project
//
//  Created by Paulo H.M. on 17/01/22.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    @State var detail = DetailView()
    @State var currentId = ""
    @State private var isPresented = false

    
    var body: some View {
        NavigationView{
            VStack{
                Text("Gists from GitHub API")
                Text("by Paulo H Mac")
//                    .navigationTitle("Gist Example")
                    .toolbar {
                        Button("Favorites") {
                            isPresented.toggle()
                        }.fullScreenCover(isPresented: $isPresented, content: FavoriteView.init)
                        
                    }
                if viewModel.isLoadingPage{
                    ProgressView()
                        .padding(10)
                }
                List(viewModel.gistList){ gist in
                    Section(header: Text("")) {
                        HStack {
                            AsyncImage(url: URL(string: gist.owner?.avatarUrl ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            Text(gist.owner?.login ?? "-")
                        }
                        NavigationLink( "Ver", destination: DetailView(gist: gist))
                        Button(gist.favorite ? "Favorited" : "Add Favorite", action: {
                            if !gist.favorite{
                                viewModel.addToFavorite(item: gist)
                            }else{
                                viewModel.removeFromFavorite(item: gist)
                            }
                        })
                        ForEach(gist.files.keys.sorted() , id: \.self) { key in
                                HStack {
                                    Text(key)
                                    Text("\(gist.files[key]?.type ?? "all" )")
                                }
                        }
                    }
                    .onAppear {
                        currentId = gist.id ?? ""
                        if currentId == viewModel.gistList.last?.id { // 6
                         loadMore()
                       }
                    }
                }.onAppear(perform: loadData)
                    .alert(viewModel.error, isPresented: $viewModel.showError) {
                        Button("Ok") { }
                    }
            }
        }
    }
    // MARK: - Retrive data
    private func loadData() {
        viewModel.listGists({})
    }

    private func loadMore() {
        viewModel.listMoreGists({})
    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
