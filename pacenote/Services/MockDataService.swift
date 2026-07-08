import Foundation

actor MockDataService {
    static let shared = MockDataService()

    func seasonCalendar() -> [RallyEvent] {
        let translation = TranslationService.shared
        let cal = Calendar.current
        let year = cal.component(.year, from: Date())

        func date(_ month: Int, _ day: Int) -> Date {
            DateComponents(calendar: cal, year: year, month: month, day: day).date ?? Date()
        }

        return [
            RallyEvent(eventId: "monte-carlo-\(year)", name: "WRC Rallye Monte-Carlo", nameCN: translation.translateRallyName("WRC Rallye Monte-Carlo"), country: "Monaco", countryCN: translation.translateCountry("Monaco"), surface: "Mixed", surfaceCN: translation.translateSurface("Mixed"), startDate: date(1, 22), endDate: date(1, 25), statusRaw: "completed", season: year, roundNumber: 1),
            RallyEvent(eventId: "sweden-\(year)", name: "WRC Rally Sweden", nameCN: translation.translateRallyName("WRC Rally Sweden"), country: "Sweden", countryCN: translation.translateCountry("Sweden"), surface: "Snow", surfaceCN: translation.translateSurface("Snow"), startDate: date(2, 13), endDate: date(2, 16), statusRaw: "completed", season: year, roundNumber: 2),
            RallyEvent(eventId: "kenya-\(year)", name: "WRC Safari Rally Kenya", nameCN: translation.translateRallyName("WRC Safari Rally Kenya"), country: "Kenya", countryCN: translation.translateCountry("Kenya"), surface: "Gravel", surfaceCN: translation.translateSurface("Gravel"), startDate: date(3, 20), endDate: date(3, 23), statusRaw: "completed", season: year, roundNumber: 3),
            RallyEvent(eventId: "portugal-\(year)", name: "WRC Rally Portugal", nameCN: translation.translateRallyName("WRC Rally Portugal"), country: "Portugal", countryCN: translation.translateCountry("Portugal"), surface: "Gravel", surfaceCN: translation.translateSurface("Gravel"), startDate: date(5, 15), endDate: date(5, 18), statusRaw: "completed", season: year, roundNumber: 4),
            RallyEvent(eventId: "sardegna-\(year)", name: "WRC Rally Italia Sardegna", nameCN: translation.translateRallyName("WRC Rally Italia Sardegna"), country: "Italy", countryCN: translation.translateCountry("Italy"), surface: "Gravel", surfaceCN: translation.translateSurface("Gravel"), startDate: date(6, 5), endDate: date(6, 8), statusRaw: "completed", season: year, roundNumber: 5),
            RallyEvent(eventId: "greece-\(year)", name: "WRC Acropolis Rally Greece", nameCN: translation.translateRallyName("WRC Acropolis Rally Greece"), country: "Greece", countryCN: translation.translateCountry("Greece"), surface: "Gravel", surfaceCN: translation.translateSurface("Gravel"), startDate: date(6, 25), endDate: date(6, 28), statusRaw: "live", season: year, roundNumber: 6),
            RallyEvent(eventId: "estonia-\(year)", name: "WRC Rally Estonia", nameCN: translation.translateRallyName("WRC Rally Estonia"), country: "Estonia", countryCN: translation.translateCountry("Estonia"), surface: "Gravel", surfaceCN: translation.translateSurface("Gravel"), startDate: date(7, 17), endDate: date(7, 20), statusRaw: "upcoming", season: year, roundNumber: 7),
            RallyEvent(eventId: "finland-\(year)", name: "WRC Rally Finland", nameCN: translation.translateRallyName("WRC Rally Finland"), country: "Finland", countryCN: translation.translateCountry("Finland"), surface: "Gravel", surfaceCN: translation.translateSurface("Gravel"), startDate: date(7, 31), endDate: date(8, 3), statusRaw: "upcoming", season: year, roundNumber: 8),
            RallyEvent(eventId: "chile-\(year)", name: "WRC Rally Chile", nameCN: translation.translateRallyName("WRC Rally Chile"), country: "Chile", countryCN: translation.translateCountry("Chile"), surface: "Gravel", surfaceCN: translation.translateSurface("Gravel"), startDate: date(9, 11), endDate: date(9, 14), statusRaw: "upcoming", season: year, roundNumber: 9),
            RallyEvent(eventId: "cer-\(year)", name: "WRC Central European Rally", nameCN: translation.translateRallyName("WRC Central European Rally"), country: "Austria", countryCN: translation.translateCountry("Austria"), surface: "Tarmac", surfaceCN: translation.translateSurface("Tarmac"), startDate: date(10, 16), endDate: date(10, 19), statusRaw: "upcoming", season: year, roundNumber: 10),
            RallyEvent(eventId: "japan-\(year)", name: "WRC Rally Japan", nameCN: translation.translateRallyName("WRC Rally Japan"), country: "Japan", countryCN: translation.translateCountry("Japan"), surface: "Tarmac", surfaceCN: translation.translateSurface("Tarmac"), startDate: date(11, 13), endDate: date(11, 16), statusRaw: "upcoming", season: year, roundNumber: 11),
        ]
    }

    func stages(for eventId: String) -> [Stage] {
        [
            Stage(stageId: "ss1", eventId: eventId, name: "Eko Stage", stageNumber: 1, distance: 22.47, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "completed"),
            Stage(stageId: "ss2", eventId: eventId, name: "Dafni", stageNumber: 2, distance: 21.67, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "completed"),
            Stage(stageId: "ss3", eventId: eventId, name: "Loutraki", stageNumber: 3, distance: 19.33, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "completed"),
            Stage(stageId: "ss4", eventId: eventId, name: "Pissia", stageNumber: 4, distance: 16.82, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "live"),
            Stage(stageId: "ss5", eventId: eventId, name: "Agioi Theodoroi", stageNumber: 5, distance: 25.14, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "upcoming"),
            Stage(stageId: "ss6", eventId: eventId, name: "Thiva", stageNumber: 6, distance: 20.89, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "upcoming"),
            Stage(stageId: "ss7", eventId: eventId, name: "Almyra", stageNumber: 7, distance: 18.45, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "upcoming"),
            Stage(stageId: "ss8", eventId: eventId, name: "Eleftherohori", stageNumber: 8, distance: 28.31, surface: "Gravel", surfaceCN: "砂石路面", statusRaw: "upcoming"),
        ]
    }

    func stageMeta(stageId: String) -> StageMetadata {
        let all: [String: StageMetadata] = [
            "ss1": StageMetadata(weather: "sunny", temperature: 28, historicalFastest: "12:18.3", historicalDriver: "Sébastien Ogier (2024)", elevationGain: 420, elevationLoss: 380, startAltitude: 680, finishAltitude: 720),
            "ss2": StageMetadata(weather: "cloudy", temperature: 24, historicalFastest: "11:45.1", historicalDriver: "Kalle Rovanperä (2024)", elevationGain: 310, elevationLoss: 350, startAltitude: 510, finishAltitude: 470),
            "ss3": StageMetadata(weather: "sunny", temperature: 30, historicalFastest: "10:22.7", historicalDriver: "Thierry Neuville (2023)", elevationGain: 280, elevationLoss: 240, startAltitude: 340, finishAltitude: 380),
            "ss4": StageMetadata(weather: "rain", temperature: 20, historicalFastest: "9:05.4", historicalDriver: "Ott Tänak (2024)", elevationGain: 190, elevationLoss: 210, startAltitude: 420, finishAltitude: 400),
        ]
        return all[stageId] ?? StageMetadata(weather: "sunny", temperature: 26, historicalFastest: "11:00.0", historicalDriver: "N/A", elevationGain: 300, elevationLoss: 280, startAltitude: 500, finishAltitude: 520)
    }

    func stageResults(stageId: String) -> [StageResult] {
        [
            StageResult(stageId: stageId, position: 1, driverName: "Kalle Rovanperä", driverId: "rovanpera", carNumber: 69, group: "Rally1", stageTime: "12:34.5", diffFirst: "—", diffPrev: "—", speed: 107.3),
            StageResult(stageId: stageId, position: 2, driverName: "Thierry Neuville", driverId: "neuville", carNumber: 11, group: "Rally1", stageTime: "12:37.2", diffFirst: "+2.7", diffPrev: "+2.7", speed: 106.8),
            StageResult(stageId: stageId, position: 3, driverName: "Ott Tänak", driverId: "tanak", carNumber: 8, group: "Rally1", stageTime: "12:38.9", diffFirst: "+4.4", diffPrev: "+1.7", speed: 106.5),
            StageResult(stageId: stageId, position: 4, driverName: "Elfyn Evans", driverId: "evans", carNumber: 33, group: "Rally1", stageTime: "12:40.1", diffFirst: "+5.6", diffPrev: "+1.2", speed: 106.2),
            StageResult(stageId: stageId, position: 5, driverName: "Takamoto Katsuta", driverId: "katsuta", carNumber: 18, group: "Rally1", stageTime: "12:42.8", diffFirst: "+8.3", diffPrev: "+2.7", speed: 105.8),
            StageResult(stageId: stageId, position: 6, driverName: "Adrien Fourmaux", driverId: "fourmaux", carNumber: 16, group: "Rally1", stageTime: "12:45.0", diffFirst: "+10.5", diffPrev: "+2.2", speed: 105.4),
            StageResult(stageId: stageId, position: 7, driverName: "Esapekka Lappi", driverId: "lappi", carNumber: 4, group: "Rally1", stageTime: "12:47.3", diffFirst: "+12.8", diffPrev: "+2.3", speed: 104.9),
            StageResult(stageId: stageId, position: 8, driverName: "Grégoire Munster", driverId: "munster", carNumber: 13, group: "Rally1", stageTime: "12:52.6", diffFirst: "+18.1", diffPrev: "+5.3", speed: 104.1),
            StageResult(stageId: stageId, position: 9, driverName: "Sami Pajari", driverId: "pajari", carNumber: 5, group: "Rally2", stageTime: "13:01.2", diffFirst: "+26.7", diffPrev: "+8.6", speed: 103.0),
            StageResult(stageId: stageId, position: 10, driverName: "Oliver Solberg", driverId: "solberg", carNumber: 20, group: "Rally2", stageTime: "13:04.8", diffFirst: "+30.3", diffPrev: "+3.6", speed: 102.5),
        ]
    }

    func overallStandings() -> [StageResult] {
        [
            StageResult(stageId: "overall", position: 1, driverName: "Kalle Rovanperä", driverId: "rovanpera", carNumber: 69, group: "Rally1", stageTime: "1:28:34.5", diffFirst: "—", diffPrev: "—"),
            StageResult(stageId: "overall", position: 2, driverName: "Thierry Neuville", driverId: "neuville", carNumber: 11, group: "Rally1", stageTime: "1:28:47.2", diffFirst: "+12.7", diffPrev: "+12.7"),
            StageResult(stageId: "overall", position: 3, driverName: "Ott Tänak", driverId: "tanak", carNumber: 8, group: "Rally1", stageTime: "1:28:59.9", diffFirst: "+25.4", diffPrev: "+12.7"),
            StageResult(stageId: "overall", position: 4, driverName: "Elfyn Evans", driverId: "evans", carNumber: 33, group: "Rally1", stageTime: "1:29:15.1", diffFirst: "+40.6", diffPrev: "+15.2"),
            StageResult(stageId: "overall", position: 5, driverName: "Takamoto Katsuta", driverId: "katsuta", carNumber: 18, group: "Rally1", stageTime: "1:29:38.8", diffFirst: "+1:04.3", diffPrev: "+23.7"),
            StageResult(stageId: "overall", position: 6, driverName: "Adrien Fourmaux", driverId: "fourmaux", carNumber: 16, group: "Rally1", stageTime: "1:30:05.0", diffFirst: "+1:30.5", diffPrev: "+26.2"),
            StageResult(stageId: "overall", position: 7, driverName: "Esapekka Lappi", driverId: "lappi", carNumber: 4, group: "Rally1", stageTime: "1:30:32.3", diffFirst: "+1:57.8", diffPrev: "+27.3"),
            StageResult(stageId: "overall", position: 8, driverName: "Grégoire Munster", driverId: "munster", carNumber: 13, group: "Rally1", stageTime: "1:31:15.6", diffFirst: "+2:41.1", diffPrev: "+43.3"),
            StageResult(stageId: "overall", position: 9, driverName: "Sami Pajari", driverId: "pajari", carNumber: 5, group: "Rally2", stageTime: "1:33:01.2", diffFirst: "+4:26.7", diffPrev: "+1:45.6"),
            StageResult(stageId: "overall", position: 10, driverName: "Oliver Solberg", driverId: "solberg", carNumber: 20, group: "Rally2", stageTime: "1:33:28.8", diffFirst: "+4:54.3", diffPrev: "+27.6"),
        ]
    }

    func driverStandings() -> [Standing] { /* existing implementation keeps working */ driverStandingsImpl() }
    func codriverStandings() -> [Standing] { codriverStandingsImpl() }
    func manufacturerStandings() -> [Standing] { manufacturerStandingsImpl() }

    func driverProfile(_ driverId: String) -> DriverProfileData? {
        profiles[driverId]
    }

    func driverSeasonResults(_ driverId: String, season: Int) -> [DriverEventResult] {
        seasonResultsData[driverId] ?? []
    }

    func driverCareerHighlights(_ driverId: String) -> [CareerHighlight] {
        careerData[driverId] ?? []
    }

    private func driverStandingsImpl() -> [Standing] {
        let season = Calendar.current.component(.year, from: Date())
        return [
            Standing(standingId: "\(season)-drivers-rovanpera", season: season, category: "drivers", position: 1, previousPosition: 1, driverName: "Kalle Rovanperä", driverId: "rovanpera", team: "Toyota Gazoo Racing", carName: "Toyota GR Yaris Rally1", points: 156, eventPoints: "25+5+3"),
            Standing(standingId: "\(season)-drivers-neuville", season: season, category: "drivers", position: 2, previousPosition: 2, driverName: "Thierry Neuville", driverId: "neuville", team: "Hyundai Shell Mobis", carName: "Hyundai i20 N Rally1", points: 138, eventPoints: "18+4"),
            Standing(standingId: "\(season)-drivers-tanak", season: season, category: "drivers", position: 3, previousPosition: 4, driverName: "Ott Tänak", driverId: "tanak", team: "Hyundai Shell Mobis", carName: "Hyundai i20 N Rally1", points: 125, eventPoints: "15+2"),
            Standing(standingId: "\(season)-drivers-evans", season: season, category: "drivers", position: 4, previousPosition: 3, driverName: "Elfyn Evans", driverId: "evans", team: "Toyota Gazoo Racing", carName: "Toyota GR Yaris Rally1", points: 118, eventPoints: "12+1"),
            Standing(standingId: "\(season)-drivers-katsuta", season: season, category: "drivers", position: 5, previousPosition: 5, driverName: "Takamoto Katsuta", driverId: "katsuta", team: "Toyota Gazoo Racing", carName: "Toyota GR Yaris Rally1", points: 82, eventPoints: "10"),
            Standing(standingId: "\(season)-drivers-fourmaux", season: season, category: "drivers", position: 6, previousPosition: 6, driverName: "Adrien Fourmaux", driverId: "fourmaux", team: "M-Sport Ford", carName: "Ford Puma Rally1", points: 68, eventPoints: "8"),
            Standing(standingId: "\(season)-drivers-lappi", season: season, category: "drivers", position: 7, previousPosition: 7, driverName: "Esapekka Lappi", driverId: "lappi", team: "Hyundai Shell Mobis", carName: "Hyundai i20 N Rally1", points: 55, eventPoints: "6"),
            Standing(standingId: "\(season)-drivers-munster", season: season, category: "drivers", position: 8, previousPosition: 8, driverName: "Grégoire Munster", driverId: "munster", team: "M-Sport Ford", carName: "Ford Puma Rally1", points: 42, eventPoints: "4"),
        ]
    }

    private func codriverStandingsImpl() -> [Standing] {
        let season = Calendar.current.component(.year, from: Date())
        return [
            Standing(standingId: "\(season)-codrivers-halttunen", season: season, category: "codrivers", position: 1, driverName: "Jonne Halttunen", driverId: "halttunen", team: "Toyota Gazoo Racing", carName: "Toyota GR Yaris Rally1", points: 156, eventPoints: ""),
            Standing(standingId: "\(season)-codrivers-wydaeghe", season: season, category: "codrivers", position: 2, driverName: "Martijn Wydaeghe", driverId: "wydaeghe", team: "Hyundai Shell Mobis", carName: "Hyundai i20 N Rally1", points: 138, eventPoints: ""),
            Standing(standingId: "\(season)-codrivers-jarveoja", season: season, category: "codrivers", position: 3, driverName: "Martin Järveoja", driverId: "jarveoja", team: "Hyundai Shell Mobis", carName: "Hyundai i20 N Rally1", points: 125, eventPoints: ""),
        ]
    }

    private func manufacturerStandingsImpl() -> [Standing] {
        let season = Calendar.current.component(.year, from: Date())
        return [
            Standing(standingId: "\(season)-mfg-toyota", season: season, category: "manufacturers", position: 1, driverName: "Toyota Gazoo Racing WRT", driverId: "toyota", team: "", carName: "Toyota GR Yaris Rally1", points: 274, eventPoints: ""),
            Standing(standingId: "\(season)-mfg-hyundai", season: season, category: "manufacturers", position: 2, driverName: "Hyundai Shell Mobis WRT", driverId: "hyundai", team: "", carName: "Hyundai i20 N Rally1", points: 263, eventPoints: ""),
            Standing(standingId: "\(season)-mfg-m-sport", season: season, category: "manufacturers", position: 3, driverName: "M-Sport Ford WRT", driverId: "m-sport", team: "", carName: "Ford Puma Rally1", points: 110, eventPoints: ""),
        ]
    }
}

struct StageMetadata {
    let weather: String
    let temperature: Int
    let historicalFastest: String
    let historicalDriver: String
    let elevationGain: Int
    let elevationLoss: Int
    let startAltitude: Int
    let finishAltitude: Int

    var weatherIcon: String {
        switch weather {
        case "sunny": return "sun.max"
        case "cloudy": return "cloud"
        case "rain": return "cloud.rain"
        case "snow": return "snowflake"
        default: return "cloud.sun"
        }
    }

    var weatherLabel: String {
        switch weather {
        case "sunny": return "晴天"
        case "cloudy": return "多云"
        case "rain": return "雨天"
        case "snow": return "雪天"
        default: return "多云"
        }
    }
}

struct DriverProfileData {
    let driverId: String
    let firstName: String
    let lastName: String
    let nationality: String
    let birthDate: String
    let team: String
    let group: String
    let carName: String
    let carNumber: Int
    let codriver: String
    let bio: String
    let careerStarts: Int
    let careerWins: Int
    let careerPodiums: Int
    let championshipTitles: Int
}

struct DriverEventResult: Identifiable {
    var id: String { "\(driverId)-\(eventName)" }
    let driverId: String
    let eventName: String
    let position: Int
    let points: Double
}

struct CareerHighlight: Identifiable {
    var id: String { "\(driverId)-\(year)-\(title)" }
    let driverId: String
    let year: Int
    let title: String
    let description: String
}

private let profiles: [String: DriverProfileData] = [
    "rovanpera": DriverProfileData(driverId: "rovanpera", firstName: "Kalle", lastName: "Rovanperä", nationality: "芬兰", birthDate: "2000-10-01", team: "Toyota Gazoo Racing", group: "Rally1", carName: "Toyota GR Yaris Rally1", carNumber: 69, codriver: "Jonne Halttunen", bio: "WRC 历史上最年轻的世界冠军。8 岁时漂移视频就在 YouTube 上爆红。父亲 Harri Rovanperä 也是 WRC 车手。2022 年以 22 岁打破 McRae 保持的最年轻冠军记录。", careerStarts: 78, careerWins: 15, careerPodiums: 28, championshipTitles: 2),
    "neuville": DriverProfileData(driverId: "neuville", firstName: "Thierry", lastName: "Neuville", nationality: "比利时", birthDate: "1988-06-16", team: "Hyundai Shell Mobis", group: "Rally1", carName: "Hyundai i20 N Rally1", carNumber: 11, codriver: "Martijn Wydaeghe", bio: "Hyundai 厂队的绝对核心。2024 年首夺世界冠军，终结了长达十年的「无冕之王」标签。以稳定的积分策略著称，在柏油路面尤其强大。", careerStarts: 168, careerWins: 21, careerPodiums: 69, championshipTitles: 1),
    "tanak": DriverProfileData(driverId: "tanak", firstName: "Ott", lastName: "Tänak", nationality: "爱沙尼亚", birthDate: "1987-10-15", team: "Hyundai Shell Mobis", group: "Rally1", carName: "Hyundai i20 N Rally1", carNumber: 8, codriver: "Martin Järveoja", bio: "2019 年世界冠军。风格激进，在高速砂石赛段无人能敌。2024 年从 M-Sport 回归 Hyundai。爱沙尼亚的国宝级运动员，推动了整个波罗的海地区的拉力文化。", careerStarts: 157, careerWins: 19, careerPodiums: 47, championshipTitles: 1),
    "evans": DriverProfileData(driverId: "evans", firstName: "Elfyn", lastName: "Evans", nationality: "英国", birthDate: "1988-12-28", team: "Toyota Gazoo Racing", group: "Rally1", carName: "Toyota GR Yaris Rally1", carNumber: 33, codriver: "Scott Martin", bio: "英国最顶级的拉力车手。以流畅精确的驾驶风格闻名，在威尔士和芬兰的砂石路上尤其出色。多次接近世界冠军但功亏一篑。", careerStarts: 142, careerWins: 9, careerPodiums: 37, championshipTitles: 0),
    "katsuta": DriverProfileData(driverId: "katsuta", firstName: "Takamoto", lastName: "Katsuta", nationality: "日本", birthDate: "1993-03-17", team: "Toyota Gazoo Racing", group: "Rally1", carName: "Toyota GR Yaris Rally1", carNumber: 18, codriver: "Aaron Johnston", bio: "丰田 WRC 挑战计划的产物，从零开始培养的日本拉力车手。2023 年初次登上领奖台。代表了日本拉力运动的复兴希望。", careerStarts: 65, careerWins: 0, careerPodiums: 4, championshipTitles: 0),
    "fourmaux": DriverProfileData(driverId: "fourmaux", firstName: "Adrien", lastName: "Fourmaux", nationality: "法国", birthDate: "1995-05-03", team: "M-Sport Ford", group: "Rally1", carName: "Ford Puma Rally1", carNumber: 16, codriver: "Alexandre Coria", bio: "法国新生代车手的代表。2024 年取得显著进步，多次进入前五。在柏油路面有很强的竞争力，被 M-Sport 视为未来核心。", careerStarts: 42, careerWins: 0, careerPodiums: 1, championshipTitles: 0),
    "lappi": DriverProfileData(driverId: "lappi", firstName: "Esapekka", lastName: "Lappi", nationality: "芬兰", birthDate: "1991-01-17", team: "Hyundai Shell Mobis", group: "Rally1", carName: "Hyundai i20 N Rally1", carNumber: 4, codriver: "Janne Ferm", bio: "芬兰传统拉力精神的传承者。2017 年在芬兰拉力赛上取得首胜，震惊车坛。以砂石路的速度和幽默的性格深受车迷喜爱。", careerStarts: 89, careerWins: 2, careerPodiums: 15, championshipTitles: 0),
    "munster": DriverProfileData(driverId: "munster", firstName: "Grégoire", lastName: "Munster", nationality: "卢森堡", birthDate: "1998-12-24", team: "M-Sport Ford", group: "Rally1", carName: "Ford Puma Rally1", carNumber: 13, codriver: "Louis Louka", bio: "卢森堡历史上第一位全职 WRC Rally1 车手。2024 年升入顶级组别，在学习和积累阶段。潜力巨大但需要时间。", careerStarts: 22, careerWins: 0, careerPodiums: 0, championshipTitles: 0),
]

private let seasonResultsData: [String: [DriverEventResult]] = [
    "rovanpera": [
        DriverEventResult(driverId: "rovanpera", eventName: "蒙特卡洛", position: 1, points: 30),
        DriverEventResult(driverId: "rovanpera", eventName: "瑞典", position: 2, points: 24),
        DriverEventResult(driverId: "rovanpera", eventName: "肯尼亚", position: 1, points: 28),
        DriverEventResult(driverId: "rovanpera", eventName: "葡萄牙", position: 4, points: 15),
        DriverEventResult(driverId: "rovanpera", eventName: "撒丁岛", position: 1, points: 33),
        DriverEventResult(driverId: "rovanpera", eventName: "希腊", position: 2, points: 26),
    ],
    "neuville": [
        DriverEventResult(driverId: "neuville", eventName: "蒙特卡洛", position: 4, points: 15),
        DriverEventResult(driverId: "neuville", eventName: "瑞典", position: 1, points: 30),
        DriverEventResult(driverId: "neuville", eventName: "肯尼亚", position: 3, points: 17),
        DriverEventResult(driverId: "neuville", eventName: "葡萄牙", position: 1, points: 30),
        DriverEventResult(driverId: "neuville", eventName: "撒丁岛", position: 2, points: 24),
        DriverEventResult(driverId: "neuville", eventName: "希腊", position: 3, points: 22),
    ],
    "tanak": [
        DriverEventResult(driverId: "tanak", eventName: "蒙特卡洛", position: 3, points: 17),
        DriverEventResult(driverId: "tanak", eventName: "瑞典", position: 4, points: 15),
        DriverEventResult(driverId: "tanak", eventName: "肯尼亚", position: 2, points: 24),
        DriverEventResult(driverId: "tanak", eventName: "葡萄牙", position: 3, points: 17),
        DriverEventResult(driverId: "tanak", eventName: "撒丁岛", position: 5, points: 12),
        DriverEventResult(driverId: "tanak", eventName: "希腊", position: 1, points: 28),
    ],
    "evans": [
        DriverEventResult(driverId: "evans", eventName: "蒙特卡洛", position: 2, points: 24),
        DriverEventResult(driverId: "evans", eventName: "瑞典", position: 3, points: 17),
        DriverEventResult(driverId: "evans", eventName: "肯尼亚", position: 5, points: 12),
        DriverEventResult(driverId: "evans", eventName: "葡萄牙", position: 2, points: 24),
        DriverEventResult(driverId: "evans", eventName: "撒丁岛", position: 4, points: 15),
        DriverEventResult(driverId: "evans", eventName: "希腊", position: 4, points: 15),
    ],
    "katsuta": [
        DriverEventResult(driverId: "katsuta", eventName: "蒙特卡洛", position: 6, points: 8),
        DriverEventResult(driverId: "katsuta", eventName: "瑞典", position: 5, points: 12),
        DriverEventResult(driverId: "katsuta", eventName: "肯尼亚", position: 4, points: 15),
        DriverEventResult(driverId: "katsuta", eventName: "葡萄牙", position: 7, points: 6),
        DriverEventResult(driverId: "katsuta", eventName: "撒丁岛", position: 3, points: 17),
        DriverEventResult(driverId: "katsuta", eventName: "希腊", position: 6, points: 8),
    ],
]

private let careerData: [String: [CareerHighlight]] = [
    "rovanpera": [
        CareerHighlight(driverId: "rovanpera", year: 2022, title: "最年轻 WRC 世界冠军", description: "22 岁 1 个月，打破 Colin McRae 保持 27 年的记录。全年 6 场胜利。"),
        CareerHighlight(driverId: "rovanpera", year: 2023, title: "卫冕世界冠军", description: "在最后一场比赛以微弱优势击败 Elfyn Evans，成功卫冕。"),
        CareerHighlight(driverId: "rovanpera", year: 2021, title: "首场 WRC 胜利", description: "在爱沙尼亚拉力赛取得职业生涯首胜，时年 20 岁。"),
    ],
    "neuville": [
        CareerHighlight(driverId: "neuville", year: 2024, title: "首夺 WRC 世界冠军", description: "十年磨一剑，在年末的日本拉力赛锁定冠军。"),
        CareerHighlight(driverId: "neuville", year: 2013, title: "首场 WRC 胜利", description: "在德国拉力赛取得首胜，成为比利时第一位 WRC 分站冠军。"),
    ],
    "tanak": [
        CareerHighlight(driverId: "tanak", year: 2019, title: "WRC 世界冠军", description: "驾驶 Toyota Yaris WRC 以六场胜利夺得世界冠军。"),
        CareerHighlight(driverId: "tanak", year: 2017, title: "首场 WRC 胜利", description: "在撒丁岛拉力赛取得首胜，成为爱沙尼亚第一位 WRC 分站冠军。"),
    ],
]
