import TipKit

struct CarTip {
    static let createRecurringItem = CreateRecurringItem()
    static let explainSafeToSpend = ExplainSafeToSpend()
    static let explainFund = ExplainFund()
    
    struct ExplainFund: Tip {
        var title: Text {
            Text("Creating a fund")
        }
        
        var message: Text? {
            Text("Funds help you save for specific things. Enter a name, then how much the fund goal should be. Transactions can add money or be expensed from the fund.")
        }
        
        var image: Image? {
            Image(systemName: "dollarsign.square")
        }
    }
    
    struct CreateRecurringItem: Tip {
        var title: Text {
            Text("Add your income and bills")
        }

        var message: Text? {
            Text("Input your income and bills by creating recurring items.")
        }
    }
    
    struct ExplainSafeToSpend: Tip {
        var title: Text {
            Text("Safe to spend")
        }
        
        var message: Text? {
            Text("Safe to spend is how much money is left over after paying your bills and saving the desired amount.")
        }
    }
}
