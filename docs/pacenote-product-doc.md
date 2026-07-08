# pacenote — Product Document

> **Status:** Concept & MVP Planning
> **Last updated:** 2026-07-07

---

## 1. Product Overview

### 1.1 What is pacenote?

**pacenote** is a mobile-first rally racing information app. It provides real-time stage results, championship standings, driver profiles, and historical data for WRC (World Rally Championship) and ERC (European Rally Championship) — all in a fast, native iOS experience with **full Chinese language support**.

Think of it as **Flashscore / FotMob for rally racing**.

### 1.2 Why does this exist?

The rally information app market is a desert:

| Existing Product | Type | Problem |
|---|---|---|
| **Rally TV** (Official WRC) | Video streaming + overlay | Buggy, castration of features, $14.99/mo, no stand-alone info mode |
| **Rally4NOW** | Results/stats | Tiny user base, bare-bones UI, no Chinese |
| **eWRC results** | Historical DB | Just launched, no polish, no live push |
| **Flashscore (WRC)** | Generic sports | WRC is a sub-sub-category, zero rally-specific UX |
| **Rally Fans** | Community | Dead — server offline |

**Gap:** No app combines (a) polished native iOS design, (b) real-time rally data, (c) Chinese language, (d) spoiler-free mode.

### 1.3 Target Audience

- **Primary:** Chinese-speaking rally fans (mainland China, Taiwan, HK, overseas diaspora)
- **Secondary:** Global rally fans who want a clean, fast information app (not video streaming)
- **Tertiary:** Sim racing enthusiasts who follow real-world rally stats

Estimated addressable market: 5M+ global rally viewers, ~100K-500K Chinese-speaking rally fans.

### 1.4 Key Differentiators

1. **Chinese-first** — zero rally information apps support Chinese
2. **No video, no streaming** — pure information, zero bandwidth cost
3. **Spoiler-free mode** — essential for rally (4-day events, timezone gaps)
4. **Native iOS** — SwiftUI, Lock Screen widgets, Dynamic Island, Live Activities
5. **Data density** — split times, gap charts, historical comparisons

---

## 2. Competitive Landscape

### 2.1 Direct Competition

| App | Platform | Language | Live Results | Historic Data | Price | Rating |
|---|---|---|---|---|---|---|
| Rally TV | iOS/Android/Web/TV | EN/FR/DE/ES | ✅ (overlay) | Archive video only | $14.99/mo | ⭐⭐ |
| Rally4NOW | iOS/Android | EN | ✅ | ❌ | Free | ⭐⭐⭐ |
| eWRC results | iOS/Android | EN | ❌ | ✅ (massive) | Free | new |
| RallySafe | iOS/Android | EN | ✅ (live tracking) | ❌ | Free | ⭐⭐⭐ |
| ARARally | iOS/Android | EN | ✅ (ARA only) | ❌ | Free | ⭐⭐ |
| Rally Results | iOS | EN | ✅ (NL/BE/DE) | ❌ | Free | ⭐⭐ |
| Rally Fans | iOS/Android | EN | ❌ | ❌ | Free | 💀 dead |

### 2.2 Rally TV User Complaints (Reddit r/WRC)

Aggregated from multiple megathreads and App Store reviews:

- **Functional degradation:** Onboard cameras removed, live timing gutted, commentary audio track dropped, post-event media disappears after Monday
- **Technical issues:** "Literally unwatchable" — streams freeze, AirPlay/Cast broken, 720p max on many platforms, TV apps non-functional (Sony, Xbox, Fire TV)
- **UX failures:** Spoilers not hidden despite promises, no resume-position memory, navigation confusion
- **User sentiment:** "I cancelled my subscription... It's pathetic and barely works"

### 2.3 Opportunity

Rally TV owns video. Nobody owns **information consumption**. pacenote is the second screen — complementary, not competitive.

---

## 3. Data Architecture

### 3.1 Data Sources

> **Last updated:** 2026-07-08 — Full data source research completed.

| Source | Type | Auth | Coverage | Cost | Status |
|---|---|---|---|---|---|
| **Sportradar Rally API** | REST JSON | API Key (`x-api-key` header) | Seasons, schedules, event summaries (66 competitors), competitor profiles, venue coordinates | Trial → Commercial | ✅ Active (trial key, `rally/trial/v2/en`) |
| **eWRC-results.com** | HTML scraping | None | 1979–present: all WRC/ERC/national events, drivers, standings, stage results | Free | ⚠️ Fallback (community scrapers exist) |
| **WRC Live Timing API** (`api.wrc.com`) | JSON (reverse-engineered) | None (was open) | WRC full season (stage results, split times, entries, penalties, championships) | Was free | ❌ Dead (2026-07 verified: CloudFront DNS blocked globally) |
| **Red Bull WRC API** | Unknown (likely JSON) | Unknown | Referenced in RallyDataJunkie repo (`newRedBullAPI.ipynb`) — Red Bull is WRC media rights holder | Unknown | 🔍 Discovered, not yet investigated |
| **Enetpulse** | REST API | Commercial | Motorsport data (WRC results, standings, schedules) | Commercial | 🔍 Not tested |
| **RallySafe** (`results-api.statusas.com`) | REST (Swagger UI visible) | Unknown | RallySafe live tracking data | Unknown | 🔍 Swagger accessible, endpoints undocumented |

#### Data Source Strategy

```
Primary:   Sportradar trial → use until expiry
Fallback:  eWRC HTML scraping → free, permanent, community-maintained
Monitor:   Red Bull WRC API (potential new official data source)
```

### 3.2 WRC API Endpoints (community-documented)

```
Season calendar:
  GET https://api.wrc.com/contel-page/83388/calendar/active-season/

Itinerary:
  GET https://api.wrc.com/results-api/rally-event/{eventId}/itinerary

Entries:
  GET https://api.wrc.com/results-api/rally-event/{eventId}/entries

Stage result:
  GET https://api.wrc.com/results-api/rally-event/{eventId}/stage-result/{stageId}

Overall:
  GET https://api.wrc.com/results-api/rally-event/{eventId}/overall

Split times:
  GET https://api.wrc.com/results-api/rally-event/{eventId}/stage-result/{stageId}/split-times

Championship:
  GET https://api.wrc.com/results-api/season/{year}/championship

Retirements & Penalties:
  GET https://api.wrc.com/results-api/rally-event/{eventId}/retirements
  GET https://api.wrc.com/results-api/rally-event/{eventId}/penalties
```

### 3.3 China Connectivity Issue

**Verified July 2026:** `api.wrc.com` (CloudFront-backed) is **DNS-blocked in mainland China**. Neither direct connection nor proxy CONNECT works — GFW performs SNI-level blocking.

**Solution: Cloudflare Worker as proxy layer**

```
iOS App (Chinese user)
       │ HTTPS
       ▼
┌─────────────────────────────┐
│  Cloudflare Worker           │  ← CF edge (not blocked in China)
│  - Proxy to api.wrc.com      │
│  - Inject Chinese translations│
│  - Add CORS headers           │
│  - Cache responses            │
└──────────┬──────────────────┘
           │ HTTPS (never touches GFW)
           ▼
     api.wrc.com ✅
```

**Cost:** Cloudflare Workers free tier: 100,000 requests/day. More than sufficient.

### 3.4 Refresh Cadence

| Data Type | Off-season | Race day | During live stage |
|---|---|---|---|
| Season calendar | 1/day | 1/hour | — |
| Itinerary / stage list | — | 1/5 min | — |
| Live stage results | — | — | 1/30 sec |
| Overall standings | — | 1/5 min | 1/5 min |
| Championship standings | 1/day | 1/hour | — |
| Entries | — | Once pre-rally | — |

### 3.5 Chinese Translation Layer

All WRC data (names, surfaces, countries, terms) are in English from the API. A local JSON mapping file translates:

```json
{
  "rallyNames": {
    "WRC Rallye Monte-Carlo": "蒙特卡洛拉力赛",
    "WRC Arctic Rally Finland": "芬兰北极拉力赛",
    "WRC Safari Rally Kenya": "肯尼亚野生动物园拉力赛"
  },
  "surfaceTypes": {
    "Gravel": "砂石路面",
    "Tarmac": "柏油路面",
    "Snow": "冰雪路面"
  },
  "groups": {
    "Rally1": "Rally1 (混合动力)",
    "Rally2": "Rally2",
    "Rally3": "Rally3"
  },
  "countries": {
    "Finland": "芬兰",
    "Estonia": "爱沙尼亚",
    "Belgium": "比利时"
  }
}
```

---

## 4. Feature Plan

### 4.1 MVP (v1.0) — 6-8 weeks

| # | Feature | Priority | Complexity |
|---|---|---|---|
| 1 | **Season Calendar** — past + upcoming rally schedule with status | P0 | Low |
| 2 | **Live Event Card** — current rally with top 3, stage progress bar | P0 | Medium |
| 3 | **Event Detail** — overall standings + stage list + stage results | P0 | Medium |
| 4 | **Championship Standings** — drivers, codrivers, manufacturers, per-event breakdown | P0 | Low |
| 5 | **Driver Profile** — bio, career stats, current season results grid | P1 | Low |
| 6 | **Spoiler-Free Mode** — blur overlay, tap-to-reveal, default ON | P0 | Medium |
| 7 | **Chinese UI** — full localization via mapping layer | P0 | Medium |
| 8 | **Settings** — spoiler toggle, notification preferences, about | P1 | Low |

### 4.2 V2 (v1.5) — differentiation layer

| # | Feature | Monetization |
|---|---|---|
| 9 | **Lock Screen Live Activities** — current leader + stage time on lock screen | Pro |
| 10 | **Dynamic Island** — compact stage progress | Pro |
| 11 | **Home Screen Widget** — next rally countdown / standings | Pro |
| 12 | **Push Notifications** — stage start/end, leader change, power stage, champion | Pro |
| 13 | **Split Times Detail** — per-driver split times with comparison | Pro |
| 14 | **Data Visualization** — gap charts, rally progression, stage time heatmaps | Pro |
| 15 | **Multi-Driver Tracking** — follow specific drivers, personalized notifications | Pro |
| 16 | **Stage Detail Page** — stage map, weather, historical fastest time | Free/Pro |

### 4.3 V3 (future) — community + expansion

| # | Feature |
|---|---|
| 17 | Rally Encyclopedia — rules, car specs, pacenotes system, terminology (Chinese) |
| 18 | WRC Predictor Game — match Rally TV's predictor |
| 19 | Light Social — stage comments, driver following |
| 20 | Second Screen Mode — sync with Rally TV live stream |
| 21 | CRC (Chinese Rally Championship) integration |
| 22 | Sim Racing bridge — compare real vs sim stage times |

---

## 5. Page Information Architecture

### 5.1 Tab Structure

```
Tab 1: Home — Calendar + Live Event
Tab 2: Standings — Championship points
Tab 3: Discover — Drivers / Teams / Encyclopedia
Tab 4: Settings — Preferences
```

### 5.2 Screen Flow

```
Home
├── Season calendar list (scrollable)
│   └── Tap → Event Detail
└── Live event card (when rally is active)
    └── Tap → Event Detail

Event Detail
├── [Overall] tab — full standings with times, gaps, retirements
├── [Stages] tab — stage list with status, tap → Stage Detail
├── [Entries] tab — full entry list by group
└── [Schedule] tab — day-by-day itinerary

Stage Detail
├── Full stage results
├── Split times (per driver) — Pro
└── Stage metadata (distance, surface, weather)

Standings
├── [Drivers] tab — points table with position movement
├── [Codrivers] tab
├── [Manufacturers] tab
└── Tap driver → Driver Profile

Driver Profile
├── Hero section (name, nationality, age, team, group)
├── Career stats (championships, rally starts, stage wins)
├── Current season — per-event points grid
├── Career highlights timeline
└── Historical results table

Discover
├── Driver list → Driver Profile
├── Team pages → Team detail
└── Rally Encyclopedia (V2)

Settings
├── Spoiler-free toggle (default ON)
├── Push notification preferences (5 types)
├── Language (Chinese only in V1)
├── Data source credits
└── About / Version
```

### 5.3 Spoiler-Free Mode

**Default behavior:**
- When navigating to any completed rally or stage result, content is hidden behind a blur overlay
- User must explicitly tap "显示成绩" (Show Results) to reveal
- The setting is global — toggle once in Settings to permanently disable

**Why it matters:**
- Rally events span 3-4 days across multiple timezones
- Chinese fans often watch replays hours or days after live broadcast
- Existing apps (including Rally TV) routinely spoil results
- This is a core differentiator and trust-builder

---

## 6. Technical Stack

### 6.1 iOS App

| Layer | Technology | Rationale |
|---|---|---|
| **UI Framework** | SwiftUI | Modern, fast iteration, native iOS features |
| **Minimum iOS** | iOS 17+ | Covers 90%+ active devices |
| **Architecture** | MVVM + Swift Concurrency (async/await) | Clean, Apple-native |
| **Networking** | URLSession + async/await | Zero dependencies |
| **Persistence** | SwiftData (Core Data wrapper) | Offline support, caching |
| **Live Activities** | ActivityKit | Lock Screen / Dynamic Island |
| **Widgets** | WidgetKit | Home Screen widgets |
| **Push Notifications** | APNs via Cloudflare Worker | Free tier sufficient |

### 6.2 Backend / Middleware

| Component | Technology | Cost |
|---|---|---|
| **API Proxy** | Cloudflare Worker (TypeScript) | Free tier (100K req/day) |
| **Caching** | Cloudflare Cache API | Free |
| **Push Trigger** | Cloudflare Worker + APNs | Free |
| **Chinese Translation Map** | Static JSON file in app bundle | N/A |

### 6.3 Why Cloudflare Worker?

- Solves the GFW blocking problem (CF edge nodes are not blocked)
- Adds CORS headers (WRC API doesn't provide them)
- Request batching and response trimming (mobile-friendly payloads)
- Zero server cost at MVP scale
- Scales automatically

### 6.4 Development Tools

| Tool | Purpose |
|---|---|
| Xcode 16+ | IDE |
| Git + GitHub | Version control |
| TestFlight | Beta distribution |
| Fastlane (optional) | CI/CD, screenshots |
| `wrangler` CLI | Cloudflare Worker deployment |

---

## 7. Monetization

### 7.1 Strategy: Freemium + Subscription

**Free Tier:** All MVP information, with a non-intrusive banner ad.

**Pro Subscription:**
- $2.99/month
- $19.99/year ($1.67/month equivalent)

### 7.2 Pro Features

| Feature | Free | Pro |
|---|---|---|
| Season calendar, live results | ✅ | ✅ |
| Overall standings, championship | ✅ | ✅ |
| Spoiler-free mode | ✅ | ✅ |
| Stage results (top-level) | ✅ | ✅ |
| Driver profiles (1 season) | ✅ | ✅ |
| **Split times (detailed)** | ❌ | ✅ |
| **Driver history (full career)** | ❌ | ✅ |
| **Live Activities + Dynamic Island** | ❌ | ✅ |
| **Home Screen Widget** | ❌ | ✅ |
| **Push notifications (all 5 types)** | Champion only | ✅ All |
| **Data visualization (charts)** | ❌ | ✅ |
| **Multi-driver tracking** | ❌ | ✅ |
| **Ad-free** | Banner ad | ✅ |

### 7.3 China Pricing (Separate Tier)

| Tier | Price |
|---|---|
| Pro — Lifetime (one-time purchase) | ¥48 |
| Pro — Monthly | ¥8/mo |
| Pro — Yearly | ¥58/yr |

Rationale: Chinese App Store users strongly prefer one-time purchases over subscriptions. ¥48 is "one less coffee + a sticker" territory.

### 7.4 Revenue Estimation

**Assumptions:**
- Global rally core audience: ~5-8M
- Addressable app users: ~1M
- Conversion to Pro: 2-3%

```
1,000,000 × 2.5% × $19.99/yr = ~$500,000 ARR
```

Conservative estimate factoring in niche market and early-stage growth: **$50K-$200K ARR within 18 months.**

### 7.5 Cost Structure

| Item | Annual Cost |
|---|---|
| Apple Developer Program | $99 |
| Cloudflare Workers (free tier) | $0 |
| Domain (`pacenote.app`) | ~$20 |
| GitHub (free) | $0 |
| **Total fixed costs** | **~$119/year** |

Near-zero marginal cost per user. This is a pure-margin product at scale.

---

## 8. Development Roadmap

### Week 1-2: Data Layer

- [ ] Cloudflare Worker setup — proxy `api.wrc.com` endpoints
- [ ] Worker route design: `/api/calendar`, `/api/event/:id/itinerary`, etc.
- [ ] Response trimming (remove unused fields from WRC JSON)
- [ ] Chinese translation map JSON
- [ ] Cache headers and stale-while-revalidate strategy
- [ ] Test all endpoints from mainland China via proxy

### Week 3-4: Home + Calendar

- [ ] iOS project scaffolding (SwiftUI + SwiftData)
- [ ] API client layer (async/await URLSession)
- [ ] Data models (RallyEvent, Stage, Driver, Standing, etc.)
- [ ] Season calendar view with status indicators
- [ ] Live event card with top-3 + progress bar
- [ ] Navigation to event detail (stub)

### Week 5-6: Event Detail + Standings

- [ ] Event detail — overall standings tab
- [ ] Stage list with status icons
- [ ] Stage results page
- [ ] Championship standings — 3-tab (drivers/codrivers/manufacturers)
- [ ] Per-event points breakdown on driver tap

### Week 7-8: Driver Profiles + Settings

- [ ] Driver profile — stats, career highlights, current season grid
- [ ] Spoiler-free system — blur overlay + global toggle
- [ ] Settings page
- [ ] Push notification permission flow (stub)

### Week 9-10: Polish + TestFlight

- [ ] UI polish — animations, transitions, empty/error states
- [ ] Offline caching (SwiftData persistence)
- [ ] TestFlight internal beta
- [ ] Bug fixing
- [ ] App Store submission prep (screenshots, description, keywords)

---

## 9. Brand

### 9.1 Name

**pacenote** — named after the rally pace note system that guides drivers through each stage.

| Variant | Usage |
|---|---|
| `pacenote` | App name (primary) |
| `pace·note` | Logo / display form |
| `pacenote.app` | Domain |
| 拉速 (Lāsù) | Chinese market alias |

### 9.2 Brand Positioning

"pacenote is your co-driver for rally information — fast, precise, and spoiler-free."

### 9.3 Visual Identity (Draft)

- **Color:** Deep dark background (#0A0D14), accent orange (#FF6B35), live red (#FF3B30)
- **Typography:** SF Pro / PingFang SC (native iOS typefaces)
- **Aesthetic:** Racing instrumentation, data-dense, no decoration
- **Tone:** Technical, enthusiast-friendly, not casual-gaming

---

## 10. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| WRC API changes / breaks | Medium | High | Worker layer isolates change; community monitors (RallyDataJunkie, OpenWRC) |
| WRC legal action (unauthorized API use) | Low | High | Data is public JSON; no video/audio content; non-commercial scale initially |
| Tiny market — insufficient revenue | Medium | Medium | $119/yr cost = low downside; treat as side project initially |
| App Store rejection (scraped data) | Low | Medium | Present as curated rally information, not a scraper; many similar apps exist |
| GFW blocks Cloudflare Workers domain | Low | Medium | Custom domain on Cloudflare with alternative routing |
| WRC Promoter releases competing info app | Low | Low | They already failed with Rally TV's information features |

---

## 11. Appendix

### A. Wireframes

`/home/orangepi/rally-app-mvp-wireframes.html` — 6-screen MVP mockup, open in any browser.

### B. References

**Data Sources:**
- Sportradar Rally API: https://developer.sportradar.com/racing/reference/rally-overview
- eWRC results: https://ewrc-results.com
- Rally-Maps: https://www.rally-maps.com
- RallySafe Results API: https://results-api.statusas.com

**Community Projects:**
- RallyDataJunkie (WRC API docs): https://rallydatajunkie.com/
- wrc-rallydj (Python package): https://pypi.org/project/wrc-rallydj/ (GitHub: `RallyDataJunkie/wrc-shinylive`)
- WRC-API (Express eWRC wrapper): https://github.com/nathanjliu/WRC-API
- eWRC Python scraper: `psychemedia/WRC_sketches` (ewrc_api.ipynb)
- wrc-timing (Python): https://github.com/ouseful-datasupply/wrc-timing

**Commercial:**
- Sportradar Rally (marketplace): https://marketplace.sportradar.com/products/652fcd54604a88e96bd784f0
- Enetpulse Motorsport: https://enetpulse.com/motorsports-data/

### C. App Store Keywords (preliminary)

`rally, rally sport, rally calendar, rally results, WRC, World Rally Championship, ERC, rally standings, rally live timing, rally driver, rally championship, stage rally, rally racing, pacenote, 拉力赛, WRC拉力, 拉力锦标赛, 拉力成绩, 拉力积分`
