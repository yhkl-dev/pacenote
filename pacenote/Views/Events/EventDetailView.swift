import SwiftUI

struct EventDetailView: View {
    let eventId: String
    @State private var viewModel = EventViewModel()
    @State private var selectedTab = 0

    private let tabs = [L10n.Event.overall, L10n.Event.stages, L10n.Event.entries, L10n.Event.schedule]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { i in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = i }
                    } label: {
                        Text(tabs[i])
                            .font(MagazineFont.monoMedium(12))
                            .foregroundColor(selectedTab == i ? MagazineColors.textPrimary : MagazineColors.textTertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .overlay(alignment: .bottom) {
                                if selectedTab == i {
                                    Rectangle().fill(MagazineColors.accent).frame(height: 2)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 16)

            TabView(selection: $selectedTab) {
                overallTab.tag(0)
                stagesTab.tag(1)
                entriesTab.tag(2)
                scheduleTab.tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadEventDetail(eventId: eventId) }
    }

    private var overallTab: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView().padding(60).tint(MagazineColors.accent)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.overallStandings.enumerated()), id: \.offset) { i, r in
                        GapResultRow(position: i + 1, result: r, maxTotal: viewModel.maxGapSeconds, viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .animation(.easeInOut(duration: 0.2), value: viewModel.overallStandings.count)
            }
        }
    }

    private var stagesTab: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.stages) { stage in
                    NavigationLink(destination: StageDetailView(eventId: eventId, stage: stage)) {
                        StageListItem(stage: stage)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .animation(.easeInOut(duration: 0.2), value: viewModel.stages.count)
        }
    }

    private var entriesTab: some View {
        placeholderView(icon: "person.2", text: L10n.Loading.entries)
    }

    private var scheduleTab: some View {
        placeholderView(icon: "clock", text: L10n.Loading.schedule)
    }

    private func placeholderView(icon: String, text: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon).font(.title).foregroundColor(MagazineColors.textTertiary)
            Text(text).font(MagazineFont.serifRegular(15)).foregroundColor(MagazineColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GapResultRow: View {
    let position: Int
    let result: StageResult
    let maxTotal: Double
    let viewModel: EventViewModel

    var gapRatio: Double {
        viewModel.gapRatio(for: result.diffFirst)
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 14) {
                Text("\(position)")
                    .font(MagazineFont.position)
                    .foregroundColor(position <= 3 ? MagazineColors.accent : MagazineColors.textTertiary)
                    .frame(width: 24, alignment: .leading)

                VStack(alignment: .leading, spacing: 2) {
                    Text(result.driverName)
                        .font(MagazineFont.body.weight(.medium))
                        .foregroundColor(MagazineColors.textPrimary)
                    HStack(spacing: 6) {
                        Text("#\(result.carNumber)")
                            .font(MagazineFont.timingSmall)
                            .foregroundColor(MagazineColors.textTertiary)
                        Text(result.group)
                            .font(MagazineFont.caption)
                            .foregroundColor(MagazineColors.textTertiary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(result.stageTime)
                        .font(MagazineFont.timing)
                        .foregroundColor(MagazineColors.textPrimary)
                    Text(result.diffFirst == "—" ? "—" : "+\(result.diffFirst.replacingOccurrences(of: "+", with: ""))")
                        .font(MagazineFont.timingSmall)
                        .foregroundColor(MagazineColors.live)
                }
            }

            if position > 1 && gapRatio > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(MagazineColors.divider)
                            .frame(height: 2)
                        Rectangle()
                            .fill(MagazineColors.live.opacity(0.5))
                            .frame(width: max(geo.size.width * gapRatio, 4), height: 2)
                    }
                }
                .frame(height: 2)
            }
        }
        .padding(.vertical, 12)
        .background(position <= 3 ? MagazineColors.accentMuted : Color.clear)
    }
}

struct StageListItem: View {
    let stage: Stage

    var body: some View {
        HStack(spacing: 14) {
            Text("SS\(stage.stageNumber)")
                .font(MagazineFont.monoBold(13))
                .foregroundColor(MagazineColors.accent)
                .frame(width: 44, alignment: .leading)

            VStack(alignment: .leading, spacing: 3) {
                Text(stage.name)
                    .font(MagazineFont.body.weight(.medium))
                    .foregroundColor(MagazineColors.textPrimary)
                HStack(spacing: 8) {
                    Text(stage.surfaceCN.isEmpty ? stage.surface : stage.surfaceCN)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textSecondary)
                    if stage.distance > 0 {
                        Text(String(format: "%.1f km", stage.distance))
                            .font(MagazineFont.timingSmall)
                            .foregroundColor(MagazineColors.textTertiary)
                    }
                }
            }

            Spacer()

            StatusDot(status: stage.status)
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
    }
}
