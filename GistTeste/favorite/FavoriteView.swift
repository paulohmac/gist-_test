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
                Text(favorite.filename)
                    .padding(8)
                    .font(.custom("Supria Sans Regular", size: 12))
                    .foregroundColor(Color(hex:"0D0D0E"))
                Text(" - " + favorite.fileType)
                    .foregroundColor(Color(hex:"0D0D0E"))
                    .font(.custom("Supria Sans Regular", size: 12))
                ScrollView {
                    ExpandableText(text: favorite.content)
                        .padding(8)
                        .font(.body)
                        .foregroundColor(Color(hex:"0D0D0E"))
                        .animation(Animation.easeInOut(duration: 0.5), value: true )
                        .background(Color.white)
                }
            }
        }.onAppear(perform: loadData)
            .font(.custom("Supria Sans Regular", size: 16))
            .foregroundColor(Color(hex:"0D0D0E"))
        
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
