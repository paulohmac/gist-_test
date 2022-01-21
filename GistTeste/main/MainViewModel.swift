//
//  MainViewModel.swift
//  View model of main screen
//
//  Created by Paulo H.M. on 18/01/22.
//

import UIKit
import SwiftUI

protocol MainViewModelProtocol{
    func listGists( _ completion : @escaping (() -> Void))
    func listMoreGists( _ completion : @escaping (() -> Void))
    func addToFavorite(item: Gist)
    func removeFromFavorite(item: Gist)
}

class MainViewModel : ObservableObject, MainViewModelProtocol{
    @Published var gistList  = [Gist]()
    @Published var isLoadingPage = true
    // MARK: - Binding Error
    @Published var error : String = ""
    @Published var showError : Bool = false
    // MARK: - Service
    lazy var service = GitService()

    init(){
    }
    // MARK: - Request for github backend
    public func listGists( _ completion : @escaping (() -> Void)){
        isLoadingPage = true
            self.service.getGists({ ret , error in
                //The Ui binding only work in mainthread!
                DispatchQueue.main.async {
                    self.isLoadingPage = false
                    if let ret = ret {
                        self.gistList = ret
                        //For unitest
                        completion()
                    }else if let error = error{
                        self.showError = true
                        self.error = error
                        completion()
                    }
                }
            })
    }
    
    public func listMoreGists(_ completion : @escaping (() -> Void)){
        isLoadingPage = true
            self.service.nextPage({ ret, error in
                //The Ui binding only work in mainthread!
                DispatchQueue.main.async {
                    self.isLoadingPage = false
                    if let ret = ret {
                        self.gistList.append(contentsOf: ret)
                        completion()
                    }else if let error = error{
                        self.showError = true
                        self.error = error
                        completion()
                    }
                }
            })
    }
    // MARK: - Persitence of Favorite data
    public func addToFavorite(item: Gist){
        if let dataSource =  GistFactory.dataSource.getInstance() as? DataSource {
            dataSource.saveFavorite(item: item )
            listGists({})
        }
    }
    
    public func removeFromFavorite(item: Gist){
        if let dataSource =  GistFactory.dataSource.getInstance() as? DataSource {
            dataSource.deleteFavorite(item:  item )
            listGists({})
        }
    }
    
}
