//
//  MapQueryModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/30.
//

import Foundation
struct MapQueryModel:Codable{
    let documents: [MapQueryItem]?
    let meta: MapQueryMeta?
    enum CodingKeys: String, CodingKey{
        case documents
        case meta
    }
}

struct MapQueryItem:Codable{
    let address: Address?
    let addressName, addressType: String?
    let roadAddress: RoadAddress?
    let x, y: String?

    enum CodingKeys: String, CodingKey {
        case address
        case addressName = "address_name"
        case addressType = "address_type"
        case roadAddress = "road_address"
        case x, y
    }
}
struct Address: Codable {
    let addressName, bCode, hCode, mainAddressNo: String
    let mountainYn, region1DepthName, region2DepthName, region3DepthHName: String
    let region3DepthName, subAddressNo, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case bCode = "b_code"
        case hCode = "h_code"
        case mainAddressNo = "main_address_no"
        case mountainYn = "mountain_yn"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthHName = "region_3depth_h_name"
        case region3DepthName = "region_3depth_name"
        case subAddressNo = "sub_address_no"
        case x, y
    }
}

struct RoadAddress: Codable {
    let addressName, buildingName, mainBuildingNo, region1DepthName: String?
    let region2DepthName, region3DepthName, roadName, subBuildingNo: String?
    let undergroundYn, x, y, zoneNo: String?

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case buildingName = "building_name"
        case mainBuildingNo = "main_building_no"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case subBuildingNo = "sub_building_no"
        case undergroundYn = "underground_yn"
        case x, y
        case zoneNo = "zone_no"
    }
}
struct MapQueryMeta:Codable{
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
