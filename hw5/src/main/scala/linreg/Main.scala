package linreg

import breeze.linalg.{DenseMatrix, DenseVector}
import breeze.optimize.{DiffFunction, LBFGS}

object Main extends App {

  val n_rows = 100_000
  val n_cols = 3
  val model = Array(1.5, 0.3, -0.7)

  val X = DenseMatrix.rand[Double](n_rows, n_cols)
  val y =  X * DenseVector(model)

  val J = new DiffFunction[DenseVector[Double]] {
    def calculate(w: DenseVector[Double]) = {
      val e = X * w - y
      val loss = (e.t * e) / (2.0 * X.rows)
      val grad = (e.t * X) /:/ (2.0 * X.rows)
      (loss, grad.t)
    }
  }

  val optimizer = new LBFGS[DenseVector[Double]]()
  println(optimizer.minimize(J, DenseVector.zeros(n_cols)))
}
