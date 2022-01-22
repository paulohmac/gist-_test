//
//  DetailViewModel.swift
//  GistTeste
//
//  Created by Paulo H.M. on 19/01/22.
//

import UIKit
import SwiftUI

class DetailViewModel: ObservableObject {

    @Published var gistDetail : Gist?
    @Published var error : String = ""
    @Published var showError : Bool = false
    @Published var isLoadingPage = true

    lazy var service = GitService()

    init(){
    }
    
    public func getGist(id : String, _ completion : @escaping (() -> Void)){
        isLoadingPage = true
        DispatchQueue.main.async {
            self.service.getGistDetail(id: id, { ret, error in
                self.isLoadingPage = false
                if let ret = ret {
                    self.gistDetail = ret
                    self.updateGistData(gistDetail: ret)
                }else if let error = error{
                    self.showError = true
                    self.error = error
                }
                completion()
            })
        }
    }

    // MARK: - Persitence of Favorite data
    public func  updateGistData(gistDetail : Gist){
        if let dataSource =  GistFactory.dataSource.getInstance() as? DataSource {
            dataSource.update(item: gistDetail)
        }
    }
    
    
}
