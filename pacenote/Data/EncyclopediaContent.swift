import Foundation

struct EncyclopediaArticle: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let category: ArticleCategory
    let readingTime: Int
    let body: String

    enum ArticleCategory: String, CaseIterable {
        case basics = "基础"
        case rules = "规则"
        case tech = "技术"
        case pacenotes = "路书"

        var displayName: String {
            switch self {
            case .basics: return L10n.Discover.basics
            case .rules: return L10n.Discover.rules
            case .tech: return L10n.Discover.tech
            case .pacenotes: return L10n.Discover.pacenotes
            }
        }

        var icon: String {
            switch self {
            case .basics: return "1.circle"
            case .rules: return "list.number"
            case .tech: return "wrench"
            case .pacenotes: return "arrow.triangle.turn.up.right.diamond"
            }
        }
    }
}

enum EncyclopediaData {
    static let articles: [EncyclopediaArticle] = [
        EncyclopediaArticle(
            id: "what-is-rally",
            title: "什么是拉力赛",
            subtitle: "从零开始理解这项最纯粹赛车运动的本质",
            category: .basics,
            readingTime: 5,
            body: """
            拉力赛（Rally）是赛车运动中最独特的形式。与场地赛不同，拉力赛在真实的公共道路上进行——砂石、雪地、柏油、泥泞——车手和领航员面对的不是重复的弯道，而是不断变化的自然地形。

            ## 核心概念

            拉力赛的竞赛单元叫「赛段」（Special Stage，简称 SS）。每个赛段是一条封闭的公共道路，车手们逐一出发，以最短时间完成赛段者为胜。所有赛段的累计时间决定最终排名。

            ## 与场地赛的关键区别

            - **没有并排发车**：车手单独出发，间隔 2-3 分钟，比拼的是时间而非位置
            - **路面不固定**：同一场拉力赛可能包含砂石、柏油、冰雪等多种路面
            - **领航员不可或缺**：副驾驶不是乘客，而是导航员，通过路书指导车手过弯
            - **赛段之间是开放道路**：车手必须驾驶赛车在公共道路上行驶到下一个赛段（称为「行驶路段」），必须遵守交通规则

            ## 拉力赛的一天

            典型的拉力赛日从凌晨开始。车手和领航员在天亮前出发，完成 4-6 个赛段，中间有轮胎更换区和维修时间。一天的比赛可以持续 12 小时以上。每一个弯道、每一次刹车、每一段砂石路都可能改变排名。

            ## 为什么拉力赛被称为「最纯粹的赛车运动」

            因为拉力赛手要面对的不是完美的赛道，而是真实世界的道路——狭窄、颠簸、不可预测。车手需要适应变化而非重复完美。正如一位车手所说：「在赛道上你超越对手，在拉力赛中你超越自己。」
            """
        ),
        EncyclopediaArticle(
            id: "wrc-groups",
            title: "WRC 组别详解",
            subtitle: "Rally1、Rally2、Rally3 到底有什么区别",
            category: .rules,
            readingTime: 4,
            body: """
            WRC（世界拉力锦标赛）目前有三个主要竞赛组别，每个组别有完全不同的技术规则和竞争格局。

            ## Rally1 — 顶级组别

            这是拉力赛的巅峰。Rally1 赛车是混合动力四驱车，搭载 1.6T 涡轮增压发动机 + 100kW 电机，综合功率超过 500 马力。2022 年引入的混合动力单元让这些赛车可以在纯电模式下行驶短距离。

            **参赛车队（2025）：**
            - Toyota Gazoo Racing WRT — GR Yaris Rally1
            - Hyundai Shell Mobis WRT — i20 N Rally1
            - M-Sport Ford WRT — Puma Rally1

            ## Rally2 — 进阶组别

            前身为 R5 组别。Rally2 赛车是基于量产车的四驱改装，1.6T 发动机，约 290 马力。成本约为 Rally1 的 1/4，是私人车队和年轻车手的主要战场。

            **特点：**
            - 更接近量产车
            - 维护成本可控
            - WRC2 锦标赛的车辆基础

            ## Rally3 — 入门四驱

            2021 年引入的最新组别。Rally3 是四驱入门级，1.5T 三缸发动机，约 215 马力。定位在 Rally2 和两驱的 Rally4 之间，为年轻车手提供更便宜的晋升路径。

            ## Junior WRC

            使用同一规格的 Ford Fiesta Rally3 赛车，车手年龄限制在 29 岁以下。这是 WRC 的「青训体系」，培养下一代冠军。
            """
        ),
        EncyclopediaArticle(
            id: "pacenotes-system",
            title: "路书系统详解",
            subtitle: "领航员口中那些数字和符号的真正含义",
            category: .pacenotes,
            readingTime: 6,
            body: """
            路书（Pacenotes）是拉力赛中最重要的工具。没有它，车手就像蒙着眼睛以 180km/h 的速度在未知的道路上行驶。

            ## 什么是路书

            路书是一套描述前方道路的符号和数字系统。领航员在赛段中不断念出路书，告诉车手前方弯道的方向、角度、路面状况和危险。

            ## 数字系统（1-6）

            主流使用 1-6 的数字系统描述弯道：
            - **1** = 接近发夹弯，极其锐利，必须最低速通过
            - **2** = 直角弯或接近直角的急弯
            - **3** = 中速弯，需要明显减速
            - **4** = 快速弯，轻微收油或点刹
            - **5** = 高速弯，几乎不需要刹车
            - **6** = 全油门通过

            实际使用中会有组合：「R3+」= 右弯、中速偏快；「L2-」= 左弯、急弯偏慢。

            ## 方向符号

            - **L** = Left（左弯）
            - **R** = Right（右弯）
            - **◁** = 锐角左弯
            - **▷** = 锐角右弯

            ## 距离标注

            数字紧跟方向之后表示距离：「R3 100」= 右 3 弯，然后 100 米直道。这让车手知道进入下一个弯道前的加速距离。

            ## 特殊标记

            - **!! / !!!** = 危险，需要格外小心
            - **→** = 保持当前方向，不需要转弯
            - **Cut** = 可以切弯（利用路肩内侧）
            - **Don't Cut** = 不能切弯（路肩内侧有危险物）
            - **Jump** = 路面有跳跃
            - **Crest** = 坡顶，之后路面不可见
            - **Caution** = 注意，前方有特殊状况

            ## 路书的制作过程

            赛前有专门的「勘路」（Recce）环节。车手和领航员驾驶普通车辆以低速跑赛段两遍：第一遍领航员写路书，第二遍车手确认和修改。比赛时使用经过这遍修改的最终版本。

            一位好领航员写的路书不是数据，是感受。它让车手在听到声音的同时看到弯道画面。
            """
        ),
        EncyclopediaArticle(
            id: "scoring-system",
            title: "WRC 计分规则",
            subtitle: "一场拉力赛到底怎么算分？为什么有那么多分数？",
            category: .rules,
            readingTime: 3,
            body: """
            WRC 从 2024 年开始启用了新的积分系统。一场比赛有三组不同的积分。

            ## 1. 总成绩积分（周六结算）

            按照全部赛段累积时间排名，前 10 名获得：
            25 - 18 - 15 - 12 - 10 - 8 - 6 - 4 - 2 - 1

            ## 2. 周日单独积分

            周日的赛段单独计算排名，前 7 名获得：
            7 - 6 - 5 - 4 - 3 - 2 - 1

            ## 3. Power Stage 积分

            每场比赛最后一个赛段为 Power Stage，前 5 名获得额外积分：
            5 - 4 - 3 - 2 - 1

            ## 为什么这样设计？

            旧系统的问题是：周六领先太多，周日变成无聊的巡游。新系统确保车手周末每一天都在竞争。即使总成绩已经拉开，周日积分和 Power Stage 积分仍然值得全力冲刺。

            这就是为什么你会在积分榜上看到「25+5+3」这样的表示法：总成绩 25 分 + 周日 5 分 + Power Stage 3 分 = 一场比赛最多可以获得 33 分。
            """
        ),
        EncyclopediaArticle(
            id: "car-tech",
            title: "拉力赛车的技术秘密",
            subtitle: "为什么一辆拉力赛车价值 100 万欧元",
            category: .tech,
            readingTime: 5,
            body: """
            一辆 Rally1 赛车的制造成本约为 100 万欧元。这笔钱买到了什么？

            ## 发动机

            1.6 升涡轮增压直喷发动机。看起来和你的家用车一样排量？区别在调校。拉力发动机在 1.6L 排量下输出约 380 马力（不含电机），比大部分 3.0L V6 都强。

            ## 混合动力单元

            Rally1 赛车搭载 100kW 电机 + 3.9kWh 电池组。在赛段中提供额外的 136 马力瞬时输出。电池在刹车和滑行时回收能量，利用类似 F1 的 MGU 技术。

            ## 悬挂系统

            拉力悬挂的行程远超你的想象。砂石路段悬挂行程超过 300mm，可以让赛车在飞跳后平稳落地。一套悬挂系统价值约 20 万欧元。

            ## 防滚架与安全

            拉力赛车内部是一个焊接的钢管结构（防滚架），即使车身完全翻转，车舱也不会变形。所有赛车配备自动灭火系统、紧急断电开关和 FIA 认证的赛车座椅。

            ## 轮胎

            一场拉力赛车队会带几百条轮胎。不同路面需要完全不同的配方和花纹。砂石轮胎的花纹深度和间距适合排泥，柏油轮胎则更接近场地赛的光头胎。雪地轮胎嵌有金属钉，每条约 400 颗。
            """
        ),
    ]

    static func articles(for category: EncyclopediaArticle.ArticleCategory?) -> [EncyclopediaArticle] {
        guard let category else { return articles }
        return articles.filter { $0.category == category }
    }
}
