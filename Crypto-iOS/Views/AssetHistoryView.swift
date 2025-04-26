import SwiftUI
import Charts

struct AssetHistoryView: View {
    
    @State var viewModel: AssetHistoryViewModel
    
    var body: some View {
        VStack {
            assetInfo
            chart
        }
        .navigationTitle(viewModel.asset.name)
        .task {
            await viewModel.fetchAssetHistory()
        }
    }
    
    @ViewBuilder
    var assetInfo: some View {
        HStack {
            AsyncImage(
                url: viewModel.assetViewState.iconUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image(systemName: "dollarsign.gauge.chart.lefthalf.righthalf")
                }
                .frame(width: 40, height: 40)

            
            VStack(alignment: .leading) {
                Text(viewModel.assetViewState.asset.symbol)
                    .font(.headline)
                Text(viewModel.assetViewState.asset.name)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text(viewModel.assetViewState.formattedPercentage)
                .foregroundStyle(viewModel.assetViewState.percentageColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
    }
    
    @ViewBuilder
    var chart: some View {
        Chart(viewModel.timelineData) { item in
            LineMark(
                x: .value("Date", item.date),
                y: .value("Price", item.priceUsd),
                series: .value("Asset", "A")
            )
            .position(by: .value("Asset", viewModel.asset.id))
            .lineStyle(StrokeStyle(lineWidth: 1, lineCap: .butt))
            .foregroundStyle(viewModel.assetViewState.percentageColor)
            
            AreaMark(
                x: .value("Date", item.date),
                yStart: .value("Baseline", viewModel.chartRange.lowerBound),
                yEnd: .value("Price", item.priceUsd)
            )
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [viewModel.assetViewState.percentageColor.opacity(0.4), viewModel.assetViewState.percentageColor.opacity(0)]),
                                            startPoint: .top,
                                            endPoint: .bottom))
            .position(by: .value("Asset", viewModel.asset.id))
        }
        .frame(maxHeight: 350)
        .chartYScale(domain: viewModel.chartRange)
        .padding()
    }
}
