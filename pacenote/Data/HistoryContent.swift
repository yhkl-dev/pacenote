import Foundation

struct HistoryEvent: Identifiable {
    let id: String
    let year: Int
    let title: String
    let subtitle: String
    let description: String
    let imageLabel: String
}

enum HistoryData {
    static let events: [HistoryEvent] = [
        HistoryEvent(
            id: "group-b-1986",
            year: 1986,
            title: "Group B 的终结",
            subtitle: "拉力史上最疯狂时代的落幕",
            description: "Group B 是拉力赛的黄金年代。不受限制的马力、极致的轻量化、粉丝涌上赛道。1986 年葡萄牙站观众卷入事故后，FIA 在赛季结束后永远禁止了 Group B。这个时代的赛车——Lancia Delta S4、Audi Sport Quattro S1、Peugeot 205 T16——至今仍是拉力史上最令人敬畏的机器。",
            imageLabel: "Group B"
        ),
        HistoryEvent(
            id: "mcrae-1995",
            year: 1995,
            title: "科林·麦克雷加冕",
            subtitle: "苏格兰飞人成为最年轻的 WRC 世界冠军",
            description: "驾驶 Subaru Impreza 555，Colin McRae 以激情四溢、无所畏惧的驾驶风格征服了全世界。他在 1995 年 RAC 拉力赛最后阶段从队友 Carlos Sainz 手中夺走胜利和世界冠军，成为 WRC 历史上最年轻的世界冠军。他的风格定义了一代拉力迷。",
            imageLabel: "McRae"
        ),
        HistoryEvent(
            id: "loeb-era-2004",
            year: 2004,
            title: "勒布王朝的开始",
            subtitle: "9 连冠，拉力史上最长的统治",
            description: "Sébastien Loeb 在 2004 年赢得第一个世界冠军，随后连续 9 年统治 WRC（2004-2012）。法国人的精准驾驶风格与 McRae 的狂野形成鲜明对比。他证明了在拉力赛中，稳定性和精确性比冒险更重要。9 连冠的记录不太可能被打破。",
            imageLabel: "Loeb"
        ),
        HistoryEvent(
            id: "ogier-era-2013",
            year: 2013,
            title: "奥吉尔的 VW 时代",
            subtitle: "四年四冠，一个完美的王朝",
            description: "Sébastien Ogier 在大众车队实现四连冠（2013-2016），随后在 M-Sport 私人车队再次夺冠（2017-2018），证明他不需要厂队资源也能赢。他的职业生涯总计 8 次世界冠军，仅次于 Loeb 的 9 次。",
            imageLabel: "Ogier"
        ),
        HistoryEvent(
            id: "rovanpera-2022",
            year: 2022,
            title: "新的王者诞生",
            subtitle: "22 岁的 Kalle Rovanperä 打破 Loeb 的最年轻冠军记录",
            description: "芬兰神童 Kalle Rovanperä 以 22 岁的年龄成为 WRC 史上最年轻的世界冠军，打破了 Colin McRae 保持了 27 年的记录。他的父亲 Harri 也是一位拉力车手。Kalle 在 8 岁时的漂移视频就在 YouTube 上广为流传。天赋与训练的结合创造了一个不可击败的赛季。",
            imageLabel: "Rovanperä"
        ),
        HistoryEvent(
            id: "hybrid-2022",
            year: 2022,
            title: "混合动力时代的开始",
            subtitle: "Rally1 规则拉开 WRC 新篇章",
            description: "2022 年，WRC 引入全新的 Rally1 技术规则。赛车首次搭载 100kW 混合动力单元，可以在纯电模式下穿越城镇。新规则被设计为更可持续、成本更低、对新车队更友好。这是 1986 年 Group B 结束后最大的一次规则变革。",
            imageLabel: "Hybrid"
        ),
    ]
}
