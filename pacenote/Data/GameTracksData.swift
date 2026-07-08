import Foundation

struct RallyGame: Identifiable {
    let id: String
    let name: String
    let developer: String
    let year: Int
    let platforms: String
    let description: String

    var trackMatches: [TrackMatch]
}

struct TrackMatch: Identifiable {
    let id = UUID()
    let stageNameInGame: String
    let realStageName: String
    let realEventName: String
    let country: String
    let surface: String
}

enum GameTracksData {
    static let games: [RallyGame] = [
        RallyGame(
            id: "ea-wrc",
            name: "EA Sports WRC",
            developer: "Codemasters",
            year: 2023,
            platforms: "PS5, Xbox Series, PC",
            description: "官方 WRC 授权游戏。基于 Unreal Engine 5，包含 2023 赛季全部 13 个分站、78 个赛段。拥有有史以来最完整的 WRC 赛段库。",
            trackMatches: [
                TrackMatch(stageNameInGame: "Col de Braus", realStageName: "Col de Braus", realEventName: "蒙特卡洛拉力赛", country: "摩纳哥/法国", surface: "柏油"),
                TrackMatch(stageNameInGame: "Mosinee", realStageName: "Mosinee", realEventName: "瑞典拉力赛", country: "瑞典", surface: "冰雪"),
                TrackMatch(stageNameInGame: "Fafe", realStageName: "Fafe", realEventName: "葡萄牙拉力赛", country: "葡萄牙", surface: "砂石"),
                TrackMatch(stageNameInGame: "Sleeping Warrior", realStageName: "Sleeping Warrior", realEventName: "肯尼亚拉力赛", country: "肯尼亚", surface: "砂石"),
                TrackMatch(stageNameInGame: "Mamaia", realStageName: "Mamaia", realEventName: "撒丁岛拉力赛", country: "意大利", surface: "砂石"),
                TrackMatch(stageNameInGame: "Kakaristo", realStageName: "Kakaristo", realEventName: "芬兰拉力赛", country: "芬兰", surface: "砂石"),
                TrackMatch(stageNameInGame: "Bauxites", realStageName: "Bauxites", realEventName: "希腊拉力赛", country: "希腊", surface: "砂石"),
                TrackMatch(stageNameInGame: "Elva", realStageName: "Elva", realEventName: "爱沙尼亚拉力赛", country: "爱沙尼亚", surface: "砂石"),
                TrackMatch(stageNameInGame: "Bio Bio", realStageName: "Bio Bío", realEventName: "智利拉力赛", country: "智利", surface: "砂石"),
                TrackMatch(stageNameInGame: "Okazaki", realStageName: "Okazaki", realEventName: "日本拉力赛", country: "日本", surface: "柏油"),
                TrackMatch(stageNameInGame: "Sturec", realStageName: "Šturec", realEventName: "中欧拉力赛", country: "捷克/奥地利/德国", surface: "柏油"),
            ]
        ),
        RallyGame(
            id: "dirt-rally-2",
            name: "DiRT Rally 2.0",
            developer: "Codemasters",
            year: 2019,
            platforms: "PS4, Xbox One, PC",
            description: "被广泛认为是最优秀的拉力模拟游戏之一。虽然没有 WRC 官方授权，但赛段设计极佳。物理引擎在模拟和可玩性之间找到完美平衡。",
            trackMatches: [
                TrackMatch(stageNameInGame: "Route de Turini", realStageName: "Col de Turini", realEventName: "蒙特卡洛拉力赛", country: "摩纳哥/法国", surface: "柏油/冰雪"),
                TrackMatch(stageNameInGame: "Pra d'Alart", realStageName: "Pra d'Alart", realEventName: "蒙特卡洛拉力赛", country: "摩纳哥/法国", surface: "柏油"),
                TrackMatch(stageNameInGame: "Hamra", realStageName: "Hamra", realEventName: "瑞典拉力赛", country: "瑞典", surface: "冰雪"),
                TrackMatch(stageNameInGame: "Kontinjärvi", realStageName: "Kontinjärvi", realEventName: "芬兰拉力赛", country: "芬兰", surface: "砂石"),
                TrackMatch(stageNameInGame: "Järvenkylä", realStageName: "Järvenkylä", realEventName: "芬兰拉力赛", country: "芬兰", surface: "砂石"),
                TrackMatch(stageNameInGame: "Waimarama", realStageName: "Waimarama", realEventName: "新西兰拉力赛", country: "新西兰", surface: "砂石"),
                TrackMatch(stageNameInGame: "Fuller Mountain", realStageName: "Fuller Mountain", realEventName: "威尔士拉力赛", country: "英国", surface: "砂石"),
                TrackMatch(stageNameInGame: "Pant Mawr", realStageName: "Pant Mawr", realEventName: "威尔士拉力赛", country: "英国", surface: "砂石"),
            ]
        ),
        RallyGame(
            id: "wrc-generations",
            name: "WRC Generations",
            developer: "KT Racing / Nacon",
            year: 2022,
            platforms: "PS5, PS4, Xbox Series, Xbox One, PC, Switch",
            description: "WRC 授权系列的收官之作。包含 2022 赛季全部 13 个分站和混合动力 Rally1 赛车。是 KT Racing 时代最完善的一代。",
            trackMatches: [
                TrackMatch(stageNameInGame: "La Bollène-Vésubie", realStageName: "La Bollène-Vésubie", realEventName: "蒙特卡洛拉力赛", country: "摩纳哥/法国", surface: "柏油"),
                TrackMatch(stageNameInGame: "Vargasen", realStageName: "Vargasen", realEventName: "瑞典拉力赛", country: "瑞典", surface: "冰雪"),
                TrackMatch(stageNameInGame: "Ponte de Lima", realStageName: "Ponte de Lima", realEventName: "葡萄牙拉力赛", country: "葡萄牙", surface: "砂石"),
                TrackMatch(stageNameInGame: "Ypres", realStageName: "Ypres", realEventName: "比利时拉力赛", country: "比利时", surface: "柏油"),
                TrackMatch(stageNameInGame: "Shinshiro", realStageName: "Shinshiro", realEventName: "日本拉力赛", country: "日本", surface: "柏油"),
            ]
        ),
        RallyGame(
            id: "rbr",
            name: "Richard Burns Rally",
            developer: "Warthog / RallySimFans",
            year: 2004,
            platforms: "PC（RBR RSF 社区持续更新中）",
            description: "2004 年的传奇。凭借 RSF（RallySimFans）社区插件，RBR 至今仍是物理模拟最真实的拉力游戏。社区持续添加现代赛车和全球赛段。如果你想体验最接近真实的拉力驾驶，这是唯一的选择。",
            trackMatches: [
                TrackMatch(stageNameInGame: "几乎全部 WRC 赛段", realStageName: "全部（社区插件）", realEventName: "各分站", country: "全球", surface: "砂石/柏油/冰雪"),
            ]
        ),
    ]
}
