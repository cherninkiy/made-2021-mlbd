package linreg

import breeze.linalg.{DenseVector, normalize, sum}
import breeze.stats.mean

class LinearRegression() {
  var w:Double = 0.0
  var b:Double = 0.0

  def fit(xTrain:Array[Double], yTrain:Array[Double], nEpochs:Int = 100, lr:Double = 0.001, normilezed:Boolean = false): LinearRegression = {
    assert(xTrain.length == yTrain.length)

    val size = xTrain.length
    val steps = size / 3;
    var alpha:Double = lr
    val tmp = DenseVector.create(xTrain, 0, 1, size)
    val x:DenseVector[Double] = if (!normilezed) normalize(tmp) else tmp
    val y:DenseVector[Double] = DenseVector.create(yTrain, 0, 1, size)

    for (i <- 0 to nEpochs) {

      val errors = y - x * this.w + this.b
      val loss = sum(errors * errors) / size

      val gradW = - 2.0 * mean(x * errors)
      val gradB = - 2.0 * mean(errors)

      this.w -= alpha * gradW
      this.b -= alpha * gradB

      if (i % (nEpochs / 10) == 0) {
        Console.println(f"Epoch: $i Loss: $loss")
      }

      if ((i + 1) % steps == 0) {
        alpha = alpha / 10.0
      }
    }
    return this
  }

  def predict(xTest:Array[Double]): Array[Double] = {
    return xTest.map(x => x* this.w + this.b).toArray
  }

  def score(yTest: Array[Double], yPred: Array[Double]): Double = {
    assert(yTest.length == yPred.length)
    val size = yTest.length
    val yDiff = yTest.zip(yPred).map(y => y._1 - y._2)
    val errors = DenseVector.create(yDiff, 0, 1, size)
    return sum(errors * errors) / size
  }

  def printStr : String = f"LinearRegression: w=$w b=$b"
}
