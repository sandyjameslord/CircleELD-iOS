
import Foundation
import UIKit


struct APIResponse: Codable {
    let id: APIID?
    let abQuestion: String?
    let abQuestionDomain: String?
    let abSentence: String?
    let bcQuestion: String?
    let bcQuestionDomain: String?
    let bcSentence: String?
    let imageName: String?
    let numSyll: APIUnit?
    let photo: String?
    let progName: String?
    let syllStructure: String?
    let theme: String?
    let unit: APIUnit?
    let vocabulary: String?
    let v: APIUnit?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case abQuestion, abQuestionDomain, abSentence, bcQuestion, bcQuestionDomain, bcSentence, imageName, numSyll,
             photo, progName, syllStructure, theme, unit, vocabulary
    }
}

struct APIUnit: Codable {
    let numberInt: String
    
    enum CodingKeys: String, CodingKey {
        case numberInt = "$numberInt"
    }
}

struct APIID: Codable {
    let oid: String
    
    enum CodingKeys: String, CodingKey {
        case oid = "$oid"
    }
}

struct CircleImage: Codable {
    let id: String?, unit: Int?, abQuestion: String?, abQuestionDomain: String?, abSentence: String?, bcQuestion: String?
    let bcQuestionDomain: String?, bcSentence: String?, imageName: String?, photo: String?, progName: String?, syllStructure: String?
    let theme: String?, vocabulary: String?
}
