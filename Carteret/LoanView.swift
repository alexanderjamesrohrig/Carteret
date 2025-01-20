import SwiftUI
import OSLog

struct LoanView: View {
    fileprivate let logger = Logger(subsystem: Constant.carteretSubsystem, category: "LoanView")
    
    var body: some View {
//        ProgressView(value: 0.08999832937)
        List {
            Section("Details") {
                HStack {
                    Text("$5,521.53 remaining")
                    Spacer()
                    Button {                        
                        logger.log("button press")
                    } label: {
                        CarteretImage.information
                    }

                }
                Text("$<PRINCIPLE> at 2.75%")
            }
            Section("Payments") {
                HStack {
                    Text("Jan 29")
                    Spacer()
                    Text("$92.99")
                }
            }
        }
    }
}

#Preview {
    LoanView()
}
