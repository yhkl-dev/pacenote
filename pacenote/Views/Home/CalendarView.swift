import SwiftUI

struct CalendarView: View {
    @Bindable var viewModel: CalendarViewModel
    @AppStorage("spoilerFreeMode") private var spoilerFreeMode = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let error = viewModel.errorMessage {
                    ErrorBanner(message: error) {
                        Task { await viewModel.loadSeasonCalendar() }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }

                if viewModel.isLoading && viewModel.events.isEmpty {
                    VStack(spacing: 20) {
                        ForEach(0..<5, id: \.self) { _ in SkeletonCard() }
                    }
                    .padding(20)
                } else if viewModel.events.isEmpty && viewModel.errorMessage == nil {
                    emptyState
                } else {
                    if !viewModel.liveEvents.isEmpty {
                        liveSection
                            .padding(.bottom, 36)
                    }
                    upcomingSection
                        .padding(.bottom, 36)
                    completedSection
                        .padding(.bottom, 40)
                }
            }
        }
        .background(MagazineColors.background)
        .toolbar {
            ToolbarItem(placement: .principal) {
                PacenoteLogo()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await viewModel.loadSeasonCalendar()
        }
    }

    private var liveSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            MagazineSectionTitle(L10n.Section.live)

            ForEach(viewModel.liveEvents) { event in
                NavigationLink(destination: EventDetailView(eventId: event.eventId)) {
                    LiveEventCard(event: event, spoilerFree: spoilerFreeMode)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
    }

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            MagazineSectionTitle(L10n.Section.upcoming)

            ForEach(viewModel.upcomingEvents) { event in
                NavigationLink(destination: EventDetailView(eventId: event.eventId)) {
                    EventRow(event: event)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
    }

    private var completedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            MagazineSectionTitle(L10n.Section.completed)

            ForEach(viewModel.completedEvents) { event in
                NavigationLink(destination: EventDetailView(eventId: event.eventId)) {
                    EventRow(event: event)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 80)
            Text(L10n.Empty.calendar)
                .font(MagazineFont.serifRegular(18))
                .foregroundColor(MagazineColors.textSecondary)
            Button {
                Task { await viewModel.loadSeasonCalendar() }
            } label: {
                Text(L10n.Error.retry)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(MagazineColors.accent)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct EventRow: View {
    let event: RallyEvent

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(event.displayName)
                    .font(MagazineFont.eventName)
                    .foregroundColor(MagazineColors.textPrimary)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Text(event.countryCN.isEmpty ? event.country : event.countryCN)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textSecondary)
                    Text("·")
                        .foregroundColor(MagazineColors.textTertiary)
                    Text(event.surfaceCN.isEmpty ? event.surface : event.surfaceCN)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                }
                Text(formatDateRange(start: event.startDate, end: event.endDate))
                    .font(MagazineFont.timingSmall)
                    .foregroundColor(MagazineColors.textTertiary)
            }

            Spacer()

            StatusDot(status: event.status)
        }
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(MagazineColors.divider)
                .frame(height: 0.5)
        }
    }

    private func formatDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "MM/dd"
        return "\(formatter.string(from: start)) \(formatter.string(from: end))"
    }
}

struct StatusDot: View {
    let status: EventStatus

    var color: Color {
        switch status {
        case .live: return MagazineColors.live
        case .completed: return MagazineColors.completed
        case .upcoming: return MagazineColors.upcoming
        case .cancelled: return MagazineColors.textTertiary
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 5, height: 5)
            Text(status.displayName)
                .font(MagazineFont.monoMedium(10))
                .foregroundColor(color)
        }
        .padding(.top, 2)
    }
}

struct ErrorBanner: View {
    let message: String
    let onRetry: (() -> Void)?

    init(message: String, onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }

    var body: some View {
        HStack(spacing: 10) {
            Circle().fill(MagazineColors.live).frame(width: 6, height: 6)
            Text(message)
                .font(MagazineFont.caption)
                .foregroundColor(MagazineColors.textSecondary)
            Spacer()
            if let onRetry {
                Button(action: onRetry) {
                    Text(L10n.Error.retry)
                        .font(MagazineFont.monoMedium(11))
                        .foregroundColor(MagazineColors.accent)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(MagazineColors.liveMuted)
    }
}

struct SkeletonCard: View {
    @State private var phase: CGFloat = -1

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            skeletonLine(width: 220, height: 14)
            HStack(spacing: 12) {
                skeletonLine(width: 60, height: 10)
                skeletonLine(width: 50, height: 10)
            }
        }
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
    }

    private func skeletonLine(width: CGFloat, height: CGFloat) -> some View {
        Rectangle()
            .fill(MagazineColors.divider)
            .frame(width: width, height: height)
    }
}

struct PacenoteLogo: View {
    var body: some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(MagazineColors.accent)
                .frame(width: 3, height: 18)
            Text("PACENOTE")
                .font(.system(.headline, design: .serif).weight(.black))
                .foregroundColor(MagazineColors.textPrimary)
                .tracking(3)
        }
    }
}
