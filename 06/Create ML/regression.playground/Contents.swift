import CreateML
import Cocoa

func classify(path: String) {
    do {
        let url = URL(fileURLWithPath: "/Users/sonson/Downloads/winequality-white.csv")
        let data = try MLDataTable(contentsOf: url)
        let (trainingData, testData) = data.randomSplit(by: 0.8, seed: 0)
        
        do {
            let regressor = try MLClassifier(trainingData: trainingData, targetColumn: "quality")
            let metrics = regressor.evaluation(on: testData)
            print(metrics)
        }
        
    } catch {
        print(error)
    }
}

func regress(path: String) {
    do {
        let url = URL(fileURLWithPath: "/Users/sonson/Downloads/winequality-white.csv")
        let data = try MLDataTable(contentsOf: url)
        let (trainingData, testData) = data.randomSplit(by: 0.8, seed: 0)
        
        do {
            let regressor = try MLRegressor(trainingData: trainingData, targetColumn: "quality")
            let metrics = regressor.evaluation(on: testData)
            print(metrics)
        }
        
    } catch {
        print(error)
    }
}

regress(path: "/Users/sonson/Library/Mobile Documents/com~apple~CloudDocs/code/coremlSample/boston.csv")
classify(path: "/Users/sonson/Library/Mobile Documents/com~apple~CloudDocs/code/coremlSample/winequality-white.csv")
classify(path: "/Users/sonson/Library/Mobile Documents/com~apple~CloudDocs/code/coremlSample/winequality-red.csv")

