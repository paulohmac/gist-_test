//
//  FavoriteView.swift
//  GistTeste
//
//  Created by Paulo H.M. on 19/01/22.
//

import SwiftUI


struct FavoriteView: View {
    @ObservedObject var viewModel = FavoriteViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            Button("Fechar") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        
        List(viewModel.favoriteList){ favorite in
            Text( favorite.ownerUrlPhoto)
            Section(header: Text(favorite.login)) {
                VStack {
                    AsyncImage(url: URL(string: favorite.ownerUrlPhoto)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                }
                Text(favorite.fileType)
                ScrollView {
                    Text( favorite.content).lineLimit(nil)
                }
            }
        }.onAppear(perform: loadData)
    }
    
    private func loadData() {
        viewModel.getFavorites({})
    }

}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
