////
////  FakeServer.swift
////  DISBYU
////
////  Created by Trevor Schmidt on 11/17/20.
////
//
//import Foundation
//
//// Base url's
//enum EndPoint: String {
//    case allBathrooms = "selectAllBathrooms/"
//    case allBuildings = "selectAllBuildings/"
//    case allDislikes = "selectAllDislikes/"
//    case allLikes = "selectAllLikes/"
//    case allRatings = "selectAllRatings/"
//    case allReviews = "selectAllReviews/"
//    // I don't add a '/' to the end of these because they will all have parameters
//    case leaders = "selectLeaders"
//    case bathroomsInBuilding = "selectBathroomsInBuilding"
//    case infoOfBathroom = "selectInfoOfBathroom"
//    case infoOfUser = "selectInfoOfUser"
//    case reviewsInBathroom = "selectReviewsInBathroom"
//    case reviewsOfUser = "selectReviewsOfUser"
//    case insertDislike = "insertDislike"
//    case insertLike = "insertLike"
//    case insertRating = "insertRating"
//    case insertReview = "insertReview"
//    case insertUser = "insertUser"
//    case checkUsername = "checkUsername"
//}
//
//struct FakeServer {
//    
////    Global type variables to change based on who is hosting the server
//    private static let ipAddress = "127.0.0.1"//10.0.0.41"
//    private static let port = "8000"
//    private static let baseURLString = "http://" + ipAddress + ":" + port + "/"
////    private static let baseURLString = "https://doesitstinkbyu.herokuapp.com/"
//    
//    
//    // Creates the request url based on the endPoint and parameters
//    private static func serverURL(endPoint: EndPoint, parameters: [String]?) -> URL {
//        
//        var returnURL = baseURLString
//        returnURL += endPoint.rawValue
//        
//        if let additionalParams = parameters {
//            if !additionalParams.isEmpty {
//                for value in additionalParams {
//                    returnURL += "/" + value
//                }
//            }
//        }
//        return URL(string: returnURL)!
//        
//    }
//    
//    // Get URL for selectAllBuildings
//    static func allBuildingsURL() -> URL {
//        return serverURL(endPoint: .allBuildings, parameters: nil)
//    }
//    // JSON decoding of selectAllBuildings
//    static func buildings(fromJSON data: Data) -> Result<[Building], Error> {
//        do {
//            let decoder = JSONDecoder()
//            let serverResponse = try decoder.decode(ServerBuildingsResponse.self, from: data)
//            return .success(serverResponse.buildings)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Get URL for bathroomsInBuilding
//    static func bathroomsInBuildingURL(buildingID: String) -> URL {
//        return serverURL(endPoint: .bathroomsInBuilding, parameters: [buildingID])
//    }
//    // JSON decoding of bathroomsInBuilding
//    static func bathrooms(fromJSON data: Data) -> Result<[Bathroom], Error> {
//        do {
//            let decoder = JSONDecoder()
//            let serverResponse = try decoder.decode(ServerBathroomsInBuildingResponse.self, from: data)
//            return .success(serverResponse.bathrooms)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Get URL for infoOfBathroom
//    static func infoOfBathroomURL(bathroomID: String, userID: String) -> URL {
//        return serverURL(endPoint: .infoOfBathroom, parameters: [bathroomID, userID])
//    }
//    // JSON decoding of infoOfBathroom
//    static func info(fromJSON data: Data) -> Result<Info, Error> {
//        do {
//            let decoder = JSONDecoder()
//            let serverResponse = try decoder.decode(ServerInfoOfBathroomResponse.self, from: data)
//            return .success(serverResponse.info)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Get URL for infoOfUser
//    static func infoOfUserURL(userID: String) -> URL {
//        return serverURL(endPoint: .infoOfUser, parameters: [userID])
//    }
//    static func userInfo(fromJSON data: Data) -> Result<UserInfo, Error> {
//        do {
//            let decoder = JSONDecoder()
//            let serverResponse = try decoder.decode(ServerInfoOfUserResponse.self, from: data)
//            return .success(serverResponse.userInfo)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Get URL for reviewsInBathroom
//    static func reviewsInBathroomURL(bathroomID: String, sort: String, userID: String) -> URL {
//        return serverURL(endPoint: .reviewsInBathroom, parameters: [bathroomID, sort, userID])
//    }
//    // JSON decoding of reviewsInBathroom
//    static func reviews(fromJSON data: Data) -> Result<[Review], Error> {
//        do {
//            let decoder = JSONDecoder()
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//            decoder.dateDecodingStrategy = .formatted(dateFormatter)
//            
//            let serverResponse = try decoder.decode(ServerReviewsInBathroomResponse.self, from: data)
//            return .success(serverResponse.reviews)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Get URL for reviewsOfUser
//    static func reviewsOfUserURL(userID: String, sort:String) -> URL {
//        return serverURL(endPoint: .reviewsOfUser, parameters: [userID, sort])
//    }
//    static func userReviews(fromJSON data: Data) -> Result<[UserReview], Error> {
//        do {
//            let decoder = JSONDecoder()
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//            decoder.dateDecodingStrategy = .formatted(dateFormatter)
//            
//            let serverResponse = try decoder.decode(ServerReviewsOfUserResponse.self, from: data)
//            return .success(serverResponse.userReviews)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Get URL for leaders
//    static func leadersURL(time: String) -> URL {
//        return serverURL(endPoint: .leaders, parameters: [time])
//    }
//    // JSON decoding of leaders
//    static func leaders(fromJSON data: Data) -> Result<[Leader], Error> {
//        do {
//            let decoder = JSONDecoder()
//            
//            let serverResponse = try decoder.decode(ServerLeadersResponse.self, from: data)
//            return .success(serverResponse.leaders)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Get URL for insertRating
//    static func insertRatingURL(bathroomID: String, userID: String, rating:String) -> URL {
//        return serverURL(endPoint: .insertRating, parameters: [bathroomID, userID, rating])
//    }
//    // Get URL for insertLike
//    static func insertLikeURL(ratingID: String, userID: String) -> URL {
//        return serverURL(endPoint: .insertLike, parameters: [ratingID, userID])
//    }
//    // Get URL for insertDislike
//    static func insertDislikeURL(ratingID: String, userID: String) -> URL {
//        return serverURL(endPoint: .insertDislike, parameters: [ratingID, userID])
//    }
//    // Get URL for insertReview
//    static func insertReviewURL(bathroomID: String, userID: String, rating: String, title: String, comments: String) -> URL {
//        return serverURL(endPoint: .insertReview, parameters: [bathroomID, userID, rating, title, comments])
//    }
//    static func insertUserURL(userID: String, login: String) -> URL {
//        return serverURL(endPoint: .insertUser, parameters: [userID, login])
//    }
//    static func checkUsernameURL(login: String) -> URL {
//        return serverURL(endPoint: .checkUsername, parameters: [login])
//    }
//    
//    // JSON decoding of all inserts
//    static func result(fromJSON data: Data) -> Result<InsertionResult, Error> {
//        do {
//            let decoder = JSONDecoder()
//            let serverResponse = try decoder.decode(ServerInsertionResponse.self, from: data)
//            return .success(serverResponse.result)
//        } catch {
//            return .failure(error)
//        }
//    }
//}
