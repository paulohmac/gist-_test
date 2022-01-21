//
//  GistTesteTests.swift
//  GistTesteTests
//
//  Created by Paulo H.M. on 16/01/22.
//

import XCTest

@testable import GistTeste

class GistTesteTests: XCTestCase {
    
    private var viewModel : MainViewModel?
    private var detailViewModel : DetailViewModel?
    private var favoriteVideModel : FavoriteViewModel?
    private var gitService : GitServiceProtocol?

    override func setUpWithError() throws {
        viewModel = MainViewModel()
        detailViewModel = DetailViewModel()
        favoriteVideModel = FavoriteViewModel()
        gitService = GitService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainViewModel()throws{

        let expectation = self.expectation(description: "Teste MainviewModel listGists")
        viewModel?.listGists({ [weak self] in
            XCTAssertNotNil(self?.viewModel?.gistList,  "Api de gist vazia")
            XCTAssert(self?.viewModel?.gistList.count ?? 0  > 0,  "Menor que 1")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)

        let initialSize = viewModel?.gistList.count ?? -1
        let expectation2 = self.expectation(description: "Teste MainviewModel listMoreGists")
        viewModel?.listMoreGists({ [weak self] in
            XCTAssertNotNil(self?.viewModel?.gistList,  "Api de gist vazia após moreGist")
            XCTAssert(self?.viewModel?.gistList.count ?? 0  >= initialSize,  "Menor que ainitialSize requisição inicial")
            expectation2.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)

        let gist = Gist()
        gist.id = "abc"
        gist.description = "descr"
        XCTAssertNoThrow(viewModel?.addToFavorite(item: gist), "Adicionado aos favoritos")
        XCTAssertNoThrow(viewModel?.removeFromFavorite(item: gist), "Removido dos favoritos")
    }
    
    func testDetailViewModel()throws{

        let expectation = self.expectation(description: "Teste DetailViewModel getGist")
        let gistCode = "35d5235c0f2e04ae16daeeac048e9fda"
        detailViewModel?.getGist(id: gistCode, { [weak self] in
            XCTAssertNotNil(self?.detailViewModel?.gistDetail,  "DetailViewModel getGist vazio")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFavoriteViewModel()throws{
        let expectation = self.expectation(description: "Teste FavoriteViewMode list favoritos")
        favoriteVideModel?.getFavorites({ [weak self] in
            XCTAssertNotNil( self?.favoriteVideModel?.favoriteList,  "Api de favoritos vazia")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGitService()throws{
        let expectation = self.expectation(description: "Teste GitService getGistDetail")
        let gistCode = "35d5235c0f2e04ae16daeeac048e9fda"
        gitService?.getGistDetail(id: gistCode, { ret, error in
            if let ret = ret {
                
            }else if let error = error{
                XCTAssertNotNil( error,  "GitService getGistDetail vazio")
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)

        let expectation2 = self.expectation(description: "Teste GitService nextPage")
        gitService?.nextPage({ ret, error in
            if let ret = ret {
        
            }else if let error = error{
                XCTAssertNotNil( error,  "GitService Next vazio")
            }
            expectation2.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
        
        
        let expectation3 = self.expectation(description: "Teste GitService getGists")
        gitService?.getGists({ ret, error in
            if let ret = ret {
        
            }else if let error = error{
                XCTAssertNotNil( error,  "GitService getGists vazio")
            }
            expectation3.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)

    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
