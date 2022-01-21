//
//  DetailView.swift
//  GistTeste
//
//  Created by Paulo H.M. on 19/01/22.
//

import SwiftUI

struct DetailView: View {
    @State var gist : Gist?
    @ObservedObject var viewModel = DetailViewModel()

    var body: some View {
        if viewModel.isLoadingPage{
            ProgressView()
                .padding(10)
        }
        VStack{
            HStack {
                AsyncImage(url: URL(string: viewModel.gistDetail?.owner?.avatarUrl ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                Text(viewModel.gistDetail?.owner?.login ?? "-")
            }
            if let  list = viewModel.gistDetail?.files.keys.sorted(){
                ForEach(list , id: \.self) { key in
                        VStack {
                            Text(key)
                            Text("\(viewModel.gistDetail?.files[key]?.type ?? "%" )")
                            ScrollView {
                                Text( viewModel.gistDetail?.files[key]?.content ?? "")
                                    .lineLimit(nil)
                            }
                        }
                }
            }
        }.onAppear(perform: loadData )
        .alert(viewModel.error, isPresented: $viewModel.showError) {
                    Button("Ok") { }
         }
    }

    private func loadData() {
        if let gist = gist,let idGist = gist.id {
            viewModel.getGist(id: idGist, {})
        }
    }

}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

 
