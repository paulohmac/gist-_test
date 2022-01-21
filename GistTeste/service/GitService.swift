//
//  GitService.swift
//  Service for Github API
//
//  Created by Paulo H.M. on 17/01/22.
//

import UIKit

protocol GitServiceProtocol{
    func getGists(_ completion : @escaping (_ list: [Gist]?, _ error : String?) -> Void)
    func nextPage( _ completion : @escaping (_ gists : [Gist]?, _ error : String?) -> Void)
    func getGistDetail(id : String, _ completion : @escaping (_ gist : Gist?,_ errorMsg : String?) -> Void)
}

class GitService : ObservableObject, GitServiceProtocol{
    var currentPage = 0
    // MARK: - favorite validation
    private func checkItemsFavorited(list : [Gist])->[Gist]{
        list.forEach { $0.favorite =  checkHasFavorite(gist: $0) }
        return list
    }
    private func checkHasFavorite(gist : Gist)-> Bool{
        if let idGist  = gist.id, let ret = (GistFactory.dataSource.getInstance() as? DataSource)?.itemExists(id: idGist) {
            return ret
        }else{
            return false
        }
    }
    // MARK: - Services request
    func getGists(_ completion : @escaping (_ list: [Gist]?, _ error : String?) -> Void){
        sendGistsServerRequest(toPage: String (currentPage), { ret, error in
            if let ret = ret {
                DispatchQueue.main.async {
                    completion(self.checkItemsFavorited(list :ret), nil)
                }
            }else{
                completion(nil, error)
            }
        })
    }
    
    func nextPage( _ completion : @escaping (_ gists : [Gist]?, _ error : String?) -> Void) {
        currentPage = currentPage + 1
        sendGistsServerRequest(toPage: String (currentPage), { ret , error in
            DispatchQueue.main.async {
                if let ret = ret {
                    completion( self.checkItemsFavorited(list: ret), nil)
                }else{
                    completion(nil, error)
                }
            }
        })
    }
    
    private func sendGistsServerRequest(toPage page : String, _ completion : @escaping (_ gists : [Gist]?, _ errorMsg : String?) -> Void){
        let requestData = RequestData<[BaseCodable]>(parameters: ["page": page], url: URLMapping.main, retType: type(of: [Gist]()))
        NetworkFactory.getInstante().sendRequestWithArray(requestData, { ret in
            if case let RequestResult.successApi(data) = ret{
                if let gists: [Gist] = data as? [Gist]{
                    completion(gists, nil)
                }else if case let RequestResult.failureApi(errorRet) = ret {
                    completion(nil, errorRet.localizedDescription)
                }
            }
        })
    }
    
    func getGistDetail(id : String, _ completion : @escaping (_ gist : Gist?,_ errorMsg : String?) -> Void){
        sendGistServerRequest(id: id, { ret, error in
            DispatchQueue.main.async {
                if let ret = ret {
                    completion(ret, nil)
                }else{
                    completion(nil, error)
                }
            }
        })
    }
    
    private func sendGistServerRequest(id : String, _ completion : @escaping (_ data :Gist?,_ error : String?)-> Void){
        let requestData = RequestData<BaseCodable>(parameters: ["id": id], url: URLMapping.detail(idGist: id), retType: Gist.self)
        NetworkFactory.getInstante().sendRequest(requestData, { ret in
            if case let RequestResult.successApi(data) = ret{
                if let gists: Gist = data as? Gist{
                    completion(gists, nil)
                }
            }else if case let RequestResult.failureApi(errorRet) = ret {
                completion(nil, errorRet.localizedDescription)
            }
        })
    }
    
}
