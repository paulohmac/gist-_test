//
//  DetailView.swift
//  GistTeste
//
//  Created by Paulo H.M. on 19/01/22.
//

import SwiftUI

struct DetailView: View {
    @State var gist : Gist?
    @State var selectedFile : FileDetail?
    @ObservedObject var viewModel = DetailViewModel()
    
    var body: some View {
        if viewModel.isLoadingPage{
            ProgressView()
                .padding(10)
        }
        VStack{
            if let  list = viewModel.gistDetail?.files.keys.sorted(){
                ScrollView {
                    ForEach(list , id: \.self) { key in
                        VStack {
                            HStack{
                                Text("\(viewModel.gistDetail?.files[key]?.filename ?? "%" )")
                                    .padding(8)
                                    .font(.custom("Supria Sans Bold", size: 12))
                                Spacer()
                                
                                Button(action: {
                                    if let url = URL(string: viewModel.gistDetail?.files[key]?.rawUrl ?? "") {
                                        UIApplication.shared.open(url)
                                    }
                                },label: {
                                    Image("mglass")
                                })
                                    .frame(width: 10, height: 10 )
                                    .padding(.trailing, 8)
                                
                                Button(action: {
                                    let pasteboard = UIPasteboard.general
                                    pasteboard.string = viewModel.gistDetail?.files[key]?.content
                                },label: {
                                    Image("copy")
                                })
                                    .frame(width: 10, height: 10 )
                                    .padding(.trailing, 8)
                            }
                            ScrollView {
                                ExpandableText(text: viewModel.gistDetail?.files[key]?.content ?? "")
                                    .padding(8)
                                    .font(.body)
                                    .foregroundColor(Color(hex:"0D0D0E"))
                                    .animation(Animation.easeInOut(duration: 0.5), value: true )
                                    .background(Color.white)
                            }
                        }
                        Divider()
                        
                    }
                }.background(Color(hex:"EFF1F5"))
            }
        }.onAppear(perform: loadData )
            .alert(viewModel.error, isPresented: $viewModel.showError) {
                Button("Fechar") { }
            }
            .navigationBarTitle(Text("Gist List"), displayMode: .inline)
            
        
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


