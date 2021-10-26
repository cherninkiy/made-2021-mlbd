package linreg

import scala.io.Source

object Main extends App {

  val dataPath:String = this.args(0)
  val numEpochs = 50;
  val verboseNum = 5;
  val batchSize = 100;

  // load data
  val rawData = Source.fromFile(dataPath).getLines().drop(1).map(_.split(",")).toArray
  val rowsCount:Int = rawData.length
  Console.println(f"Total objects: $rowsCount")

  // extract features
  val power:Array[Double] = rawData.map(arr => arr(21)).map(_.toDouble)
  val price:Array[Double] = rawData.map(arr => arr(25)).map(_.toDouble)

  // train-test split
  val trainSize = 2*rowsCount/3
  val xTrain:Array[Double] = power.slice(0, trainSize)
  val xTest:Array[Double] = power.slice(trainSize, rowsCount)
  val yTrain:Array[Double]  = price.slice(0, trainSize)
  val yTest:Array[Double] = price.slice(trainSize, rowsCount)
  val testSize =  xTest.length
  Console.println(f"Train/Test: $trainSize / $testSize")

  var weight:Double = 0.0
  var bias:Double = 0.0

  var lr = 0.01

  var linReg = new LinearRegression()

  val yPred = linReg.fit(xTrain, yTrain).predict(xTest)
  Console.println(linReg.printStr)
  Console.print("Test MAE: " + linReg.score(yTest, yPred))
}
