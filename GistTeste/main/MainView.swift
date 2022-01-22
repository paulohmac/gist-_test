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
    @State var isNavigationBarHidden: Bool = true
    
    var body: some View {
        NavigationView{
            VStack{
                if viewModel.isLoadingPage{
                    ProgressView()
                        .padding(10)
                }
                List(viewModel.gistList){ gist in
                    
                    Section(header: Text(gist.owner?.login ?? "-")) {
                        HStack{
                            AsyncImage(url: URL(string: gist.owner?.avatarUrl ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                Image("githubicon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 64, height: 64 , alignment: .center)
                            }
                            .frame(width: 64, height: 64 , alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            Spacer()
                            Button(action: {
                                if !gist.favorite{
                                    viewModel.addToFavorite(item: gist)
                                }else{
                                    viewModel.removeFromFavorite(item: gist)
                                }
                            },label: {
                                if gist.favorite {
                                    Image("favorited")
                                        .aspectRatio(contentMode: .fit)
                                }else{
                                    Image("favorite")
                                        .aspectRatio(contentMode: .fit)
                                }
                            })
                                .frame(width: 10, height: 10 )
                                .padding(.trailing, 8)
                        }
                        ForEach(gist.files.keys.sorted() , id: \.self) { key in
                            HStack {
                                Text("Type: \(gist.files[key]?.type ?? "all" )").font(.custom("Supria Sans Regular", size: 12))
                                Spacer()
                                NavigationLink( "", destination: DetailView(gist: gist, selectedFile: gist.files[key]))
                                Spacer()
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
            .toolbar {
                Button("Favorites"){
                    isPresented.toggle()
                }.fullScreenCover(isPresented: $isPresented, content: FavoriteView.init).foregroundColor(Color.blue)
            }
            .navigationBarTitle(Text("GitHub Gist List"), displayMode: .inline)
            
        }.background(Color(hex:"EFF1F5"))
            .font(.custom("Supria Sans Regular", size: 16))
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
