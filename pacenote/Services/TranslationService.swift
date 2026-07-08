import Foundation

final class TranslationService {
    static let shared = TranslationService()

    private var rallyNames: [String: String] = [:]
    private var surfaceTypes: [String: String] = [:]
    private var groups: [String: String] = [:]
    private var countries: [String: String] = [:]

    private init() {
        loadTranslations()
    }

    private func loadTranslations() {
        guard let url = Bundle.main.url(forResource: "translations", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]]
        else {
            loadFallbackTranslations()
            return
        }

        rallyNames = json["rallyNames"] ?? [:]
        surfaceTypes = json["surfaceTypes"] ?? [:]
        groups = json["groups"] ?? [:]
        countries = json["countries"] ?? [:]
    }

    private func loadFallbackTranslations() {
        rallyNames = [
            "WRC Rallye Monte-Carlo": "蒙特卡洛拉力赛",
            "Rally de Monte-Carlo": "蒙特卡洛拉力赛",
            "WRC Arctic Rally Finland": "芬兰北极拉力赛",
            "WRC Safari Rally Kenya": "肯尼亚野生动物园拉力赛",
            "Rally Kenya": "肯尼亚拉力赛",
            "WRC Rally Sweden": "瑞典拉力赛",
            "Rally Sweden": "瑞典拉力赛",
            "WRC Rally Portugal": "葡萄牙拉力赛",
            "Rally de Portugal": "葡萄牙拉力赛",
            "WRC Rally Italia Sardegna": "意大利撒丁岛拉力赛",
            "Rally Italia": "意大利拉力赛",
            "WRC Rally Estonia": "爱沙尼亚拉力赛",
            "Rally Estonia": "爱沙尼亚拉力赛",
            "WRC Rally Finland": "芬兰拉力赛",
            "Rally Finland": "芬兰拉力赛",
            "WRC Acropolis Rally Greece": "希腊卫城拉力赛",
            "Rally Greece": "希腊拉力赛",
            "WRC Rally Chile": "智利拉力赛",
            "Rally Chile": "智利拉力赛",
            "WRC Central European Rally": "中欧拉力赛",
            "Rally de Paraguay": "巴拉圭拉力赛",
            "Rally Islas Canarias": "加那利群岛拉力赛",
            "Rally Croatia": "克罗地亚拉力赛",
            "Rally Japan": "日本拉力赛",
            "Rally Saudi Arabia": "沙特阿拉伯拉力赛",
            "World Rally Championship 2026": "世界拉力锦标赛 2026",
            "WRC Rally Japan": "日本拉力赛"
        ]

        surfaceTypes = [
            "Gravel": "砂石路面",
            "Tarmac": "柏油路面",
            "Snow": "冰雪路面",
            "Ice": "冰面",
            "Mixed": "混合路面"
        ]

        groups = [
            "Rally1": "Rally1 (混合动力)",
            "Rally2": "Rally2",
            "Rally3": "Rally3",
            "Rally4": "Rally4",
            "Rally5": "Rally5",
            "WRC": "WRC",
            "WRC2": "WRC2",
            "WRC3": "WRC3",
            "Junior WRC": "Junior WRC"
        ]

        countries = [
            "Finland": "芬兰",
            "Sweden": "瑞典",
            "Portugal": "葡萄牙",
            "Italy": "意大利",
            "Estonia": "爱沙尼亚",
            "Greece": "希腊",
            "Chile": "智利",
            "Japan": "日本",
            "Kenya": "肯尼亚",
            "France": "法国",
            "Croatia": "克罗地亚",
            "Poland": "波兰",
            "Latvia": "拉脱维亚",
            "Belgium": "比利时",
            "Spain": "西班牙",
            "Germany": "德国",
            "Austria": "奥地利",
            "Czech Republic": "捷克",
            "Hungary": "匈牙利",
            "Monaco": "摩纳哥",
            "Great Britain": "英国",
            "Ireland": "爱尔兰"
        ]
    }

    func translateRallyName(_ english: String) -> String {
        rallyNames[english] ?? english
    }

    func translateSurface(_ english: String) -> String {
        surfaceTypes[english] ?? english
    }

    func translateGroup(_ english: String) -> String {
        groups[english] ?? english
    }

    func translateCountry(_ english: String) -> String {
        countries[english] ?? english
    }
}
