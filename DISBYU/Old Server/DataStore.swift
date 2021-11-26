////
////  DataStore.swift
////  DISBYU
////
////  Created by Trevor Schmidt on 11/17/20.
////
//
//import Foundation
//
//class DataStore {
//    
//    // Global URLSession variable
//    private let session: URLSession = {
//        let config = URLSessionConfiguration.default
//        return URLSession(configuration: config)
//    }()
//    
//    
//    func fetchAllBuildings(completion: @escaping (Result<[Building], Error>) -> Void) {
//        let url = FakeServer.allBuildingsURL()
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processAllBuildingsRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    private func processAllBuildingsRequest(data: Data?,
//                                            error: Error?) -> Result<[Building], Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.buildings(fromJSON: jsonData)
//    }
//    
//    func fetchAllBathroomsInBuilding(buildingID: String, completion: @escaping (Result<[Bathroom], Error>) -> Void) {
//        let url = FakeServer.bathroomsInBuildingURL(buildingID: buildingID)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processBathroomsInBuildingRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    private func processBathroomsInBuildingRequest(data: Data?,
//                                                   error: Error?) -> Result<[Bathroom], Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.bathrooms(fromJSON: jsonData)
//    }
//    
//    func fetchInfoOfBathroom(bathroomID: String, userID: String, completion: @escaping (Result<Info, Error>) -> Void) {
//        let url = FakeServer.infoOfBathroomURL(bathroomID: bathroomID, userID: userID)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInfoOfBathroomRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    private func processInfoOfBathroomRequest(data: Data?,
//                                              error: Error?) -> Result<Info, Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.info(fromJSON: jsonData)
//    }
//    
//    func fetchInfoOfUser(userID: String, completion: @escaping (Result<UserInfo, Error>) -> Void) {
//        let url = FakeServer.infoOfUserURL(userID: userID)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInfoOfUserRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    private func processInfoOfUserRequest(data: Data?,
//                                          error: Error?) -> Result<UserInfo, Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.userInfo(fromJSON: jsonData)
//    }
//    
//    func fetchReviewsInBathroom(bathroomID: String, sort: String, userID: String, completion: @escaping (Result<[Review], Error>) -> Void) {
//        let url = FakeServer.reviewsInBathroomURL(bathroomID: bathroomID, sort: sort, userID: userID)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processReviewsInBathroomRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    private func processReviewsInBathroomRequest(data: Data?,
//                                                 error: Error?) -> Result<[Review], Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.reviews(fromJSON: jsonData)
//    }
//    
//    func fetchReviewsOfUser(userID: String, sort: String, completion: @escaping (Result<[UserReview], Error>) -> Void) {
//        let url = FakeServer.reviewsOfUserURL(userID: userID, sort: sort)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processReviewsOfUserRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    private func processReviewsOfUserRequest(data: Data?,
//                                             error: Error?) -> Result<[UserReview], Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.userReviews(fromJSON: jsonData)
//    }
//    
//    func fetchLeaders(time: String, completion: @escaping (Result<[Leader], Error>) -> Void) {
//        let url = FakeServer.leadersURL(time: time)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processLeadersRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    private func processLeadersRequest(data: Data?,
//                                       error: Error?) -> Result<[Leader], Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.leaders(fromJSON: jsonData)
//    }
//    
//    func pushRating(bathroomID: String, userID: String, rating: String, completion: @escaping (Result<InsertionResult, Error>) -> Void) {
//        let url = FakeServer.insertRatingURL(bathroomID: bathroomID, userID: userID, rating: rating)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInsertionRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    func pushLike(ratingID: String, userID:String, completion: @escaping (Result<InsertionResult, Error>) -> Void) {
//        let url = FakeServer.insertLikeURL(ratingID: ratingID, userID: userID)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInsertionRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    func pushDislike(ratingID: String, userID:String, completion: @escaping (Result<InsertionResult, Error>) -> Void) {
//        let url = FakeServer.insertDislikeURL(ratingID: ratingID, userID: userID)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInsertionRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    func pushReview(bathroomID: String, userID: String, rating: String, title: String, comments: String, completion: @escaping (Result<InsertionResult, Error>) -> Void) {
//        let url = FakeServer.insertReviewURL(bathroomID: bathroomID, userID: userID, rating: rating, title: title, comments: comments)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInsertionRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    func pushUser(userID: String, login: String, completion: @escaping (Result<InsertionResult, Error>) -> Void) {
//        let url = FakeServer.insertUserURL(userID: userID, login: login)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInsertionRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    func checkUsername(login: String, completion: @escaping (Result<InsertionResult, Error>) -> Void) {
//        let url = FakeServer.checkUsernameURL(login: login)
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//            
//            let result = self.processInsertionRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
//    
//    private func processInsertionRequest(data: Data?,
//                                         error: Error?) -> Result<InsertionResult, Error> {
//        guard let jsonData = data else {
//            return .failure(error!)
//        }
//        return FakeServer.result(fromJSON: jsonData)
//    }
//}
