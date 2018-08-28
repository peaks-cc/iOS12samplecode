import CreateML
import CoreML
import Foundation

func classify(path: String) {
    do {
        // CSVファイルを開く
        let url = URL(fileURLWithPath: path)
        let data = try MLDataTable(contentsOf: url)
        // データを学習データとテストデータに分ける
        let (trainingData, testData) = data.randomSplit(by: 0.8, seed: 0)
        // 分類モデルにデータを入れて学習する
        print("-----------------------------learning-----------------------------")
        let regressor = try MLClassifier(trainingData: trainingData, targetColumn: "quality")
        // テストデータで評価する
        let metrics = regressor.evaluation(on: testData)
        print("-----------------------------result-----------------------------")
        print(metrics)
        // 選択された手法を確認
        print("-----------------------------model-----------------------------")
        print(regressor)
    } catch {
        print(error)
    }
}

func regress(path: String) {
    
    let mlmodelURL = URL(fileURLWithPath: "/Users/sonson/Documents/code/iOS12samplecode/06/dataset/regression/temp2.mlmodel")
    
    do {
        // CSVファイルを開く
        let url = URL(fileURLWithPath: path)
        let data = try MLDataTable(contentsOf: url)
        // データを学習データとテストデータに分ける
        let (trainingData, testData) = data.randomSplit(by: 0.8, seed: 0)
        // 回帰モデルにデータを入れて学習する
        print("-----------------------------learning-----------------------------")
        let regressor = try MLRegressor(trainingData: trainingData, targetColumn: "PRICE")
        // テストデータで評価する
        let metrics = regressor.evaluation(on: testData)
        print("-----------------------------result-----------------------------")
        print(metrics)
        // 選択された手法を確認
        print("-----------------------------model-----------------------------")
        print(regressor)
        
        try regressor.write(to: mlmodelURL, metadata: nil)
    } catch {
        print(error)
    }
    
//    do {
//        let url = try MLModel.compileModel(at: mlmodelURL)
//        let model = try MLModel(contentsOf: url)
//        print(model)
//    } catch {
//        print(error)
//    }
}

regress(path:  "/Users/sonson/Documents/code/iOS12samplecode/06/dataset/regression/boston.csv")
//classify(path: "/Users/sonson/Documents/code/iOS12samplecode/06/dataset/regression/winequality-white.csv")
//classify(path: "/Users/sonson/Documents/code/iOS12samplecode/06/dataset/regression/winequality-red.csv")

