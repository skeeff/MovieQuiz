import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase{
    
    func testSuccessLoading() throws {
        //given
        let loader = MoviesLoader()
        
        //when
        let expectation = expectation(description: "Loading expectation")
        
        //then
        loader.loadMovies{ result in
            
            switch result{
            case .success(let movies):
                expectation.fulfill()
            case .failure(_):
                XCTFail("unexpectend fail")
            }
            
        }
        
        waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws {
        //given
        
        //when
        
        //then
    }
}
