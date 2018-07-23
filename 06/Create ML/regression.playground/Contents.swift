import CreateML
import Cocoa

func classify(path: String) {
    do {
        let url = URL(fileURLWithPath: path)
        let data = try MLDataTable(contentsOf: url)
        let (trainingData, testData) = data.randomSplit(by: 0.8, seed: 0)

        let regressor = try MLClassifier(trainingData: trainingData, targetColumn: "quality")
        let metrics = regressor.evaluation(on: testData)
        print(metrics)

    } catch {
        print(error)
    }
}

func regress(path: String) {
    do {
        let url = URL(fileURLWithPath: path)
        let data = try MLDataTable(contentsOf: url)
        let (trainingData, testData) = data.randomSplit(by: 0.8, seed: 0)
        let regressor = try MLRegressor(trainingData: trainingData, targetColumn: "quality")
        let metrics = regressor.evaluation(on: testData)
        print(metrics)
    } catch {
        print(error)
    }
}

regress(path: "/Users/sonson/Documents/code/iOS12samplecode/06/dataset/boston.csv")
classify(path: "/Users/sonson/Documents/code/iOS12samplecode/06/dataset/winequality-white.csv")
classify(path: "/Users/sonson/Documents/code/iOS12samplecode/06/dataset/winequality-red.csv")

