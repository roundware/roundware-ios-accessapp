import Foundation
class GalleryViewModel: BaseViewModel  {
    let data: RWData
    let tag: Tag
    let assets: [Asset]

    init(data: RWData) {
        self.data = data
        //set room tags
        tag = data.getTagForIndexAndMode(2, mode: "listen")!
        assets = data.getAssetsForTagIdOfMediaType(tag.id, mediaType: .Photo)
    }
}
