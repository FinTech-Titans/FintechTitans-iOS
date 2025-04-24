import Foundation

// MARK: - Profile
struct Profile: Codable {
    let id, displayName, email: String
    let sharingAllowed: Bool
    let createdAt: Date
    let partitionKey, rid, profileSelf, etag: String
    let attachments: String
    let ts: Int

    enum CodingKeys: String, CodingKey {
        case id, displayName, email, sharingAllowed, createdAt
        case partitionKey = "_partitionKey"
        case rid = "_rid"
        case profileSelf = "_self"
        case etag = "_etag"
        case attachments = "_attachments"
        case ts = "_ts"
    }
}
