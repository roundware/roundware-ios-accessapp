import Foundation
import RWFramework

struct Tag {
  var tagId: Int = 0
  var shortcode: String = ""
  var localDescription: String = ""
  var order: Int = 0
  var value: String = ""
  var tagDescription: String = ""
  var headerImageURL: String = ""

  init(json: JSON) {
    tagId = json["tag_id"].int ?? 0
    shortcode = json["shortcode"].string ?? ""
    localDescription = json["loc_description"].string ?? ""
    order = json["order"].int ?? 0
    value = json["value"].string ?? ""
    tagDescription = json["description"].string ?? ""

    // FIX: "data" is eventually going to change from a string to a dictionary
    headerImageURL = json["data"].string ?? ""
  }
}

struct TagGroup {
  var select: String = ""
  var order: Int = 0
  var code: String = ""
  var headerText: String = ""
  var name: String = ""
  var options: [Tag] = []

  init(json: JSON) {
    select = json["select"].string ?? ""
    order = json["order"].int ?? 0
    code = json["code"].string ?? ""
    headerText = json["header_text"].string ?? ""
    name = json["name"].string ?? ""
    options = json["options"].array?.map { Tag(json: $0) } ?? []
  }
}

//  {
//    "speak" : [
//    {
//    "select" : "single",
//    "order" : 1,
//    "code" : "gender",
//    "defaults" : [
//
//    ],
//    "header_text" : "What gender are you?",
//    "name" : "What gender are you?",
//    "options" : [
//    {
//    "tag_id" : 3,
//    "shortcode" : "male",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 2,
//    "value" : "male",
//    "description" : "male",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23
//    ]
//    },
//    {
//    "tag_id" : 4,
//    "shortcode" : "female",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 1,
//    "value" : "female",
//    "description" : "female",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23
//    ]
//    }
//    ]
//    },
//    {
//    "select" : "single",
//    "order" : 3,
//    "code" : "question",
//    "defaults" : [
//
//    ],
//    "header_text" : "What do you want to talk about?",
//    "name" : "What do you want to talk about?",
//    "options" : [
//    {
//    "tag_id" : 5,
//    "shortcode" : "Why RW?",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 1,
//    "value" : "Why are you using Roundware?",
//    "description" : "Why are you using Roundware?",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23
//    ]
//    },
//    {
//    "tag_id" : 22,
//    "shortcode" : "value: respond",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 2,
//    "value" : "Respond to something you've heard.",
//    "description" : "description: respond",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23,
//    30
//    ]
//    }
//    ]
//    },
//    {
//    "select" : "single",
//    "order" : 2,
//    "code" : "usertype",
//    "defaults" : [
//
//    ],
//    "header_text" : "Who are you?",
//    "name" : "Who are you?",
//    "options" : [
//    {
//    "tag_id" : 9,
//    "shortcode" : "Visitor",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 1,
//    "value" : "Visitor",
//    "description" : "Visitor",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23,
//    30
//    ]
//    },
//    {
//    "tag_id" : 8,
//    "shortcode" : "Artist",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 2,
//    "value" : "Artist",
//    "description" : "Artist",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23,
//    30
//    ]
//    }
//    ]
//    }
//    ],
//    "listen" : [
//    {
//    "select" : "multi_at_least_one",
//    "order" : 1,
//    "code" : "gender",
//    "defaults" : [
//    3,
//    4
//    ],
//    "header_text" : "What genders do you want to listen to?",
//    "name" : "What genders do you want to listen to?",
//    "options" : [
//    {
//    "tag_id" : 3,
//    "shortcode" : "male",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 2,
//    "value" : "male",
//    "description" : "male",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23
//    ]
//    },
//    {
//    "tag_id" : 4,
//    "shortcode" : "female",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 1,
//    "value" : "female",
//    "description" : "female",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23
//    ]
//    }
//    ]
//    },
//    {
//    "select" : "multi_at_least_one",
//    "order" : 3,
//    "code" : "question",
//    "defaults" : [
//    5,
//    22
//    ],
//    "header_text" : "What do you want to listen to?",
//    "name" : "What do you want to listen to?",
//    "options" : [
//    {
//    "tag_id" : 5,
//    "shortcode" : "Why RW?",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 1,
//    "value" : "Why are you using Roundware?",
//    "description" : "Why are you using Roundware?",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23
//    ]
//    },
//    {
//    "tag_id" : 22,
//    "shortcode" : "value: respond",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 2,
//    "value" : "Respond to something you've heard.",
//    "description" : "description: respond",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23,
//    30
//    ]
//    }
//    ]
//    },
//    {
//    "select" : "multi_at_least_one",
//    "order" : 2,
//    "code" : "usertype",
//    "defaults" : [
//    8,
//    9
//    ],
//    "header_text" : "Who do you want to hear?",
//    "name" : "Who do you want to hear?",
//    "options" : [
//    {
//    "tag_id" : 8,
//    "shortcode" : "Artist",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 1,
//    "value" : "Artist",
//    "description" : "Artist",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23,
//    30
//    ]
//    },
//    {
//    "tag_id" : 9,
//    "shortcode" : "Visitor",
//    "loc_description" : "",
//    "data" : "class=tag-one",
//    "order" : 2,
//    "value" : "Visitor",
//    "description" : "Visitor",
//    "relationships" : [
//    3,
//    4,
//    5,
//    8,
//    9,
//    22,
//    23,
//    30
//    ]
//    }
//    ]
//    }
//    ]
//  }
