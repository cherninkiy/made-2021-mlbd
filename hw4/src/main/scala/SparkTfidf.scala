import org.apache.spark.sql._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions.Window

object SparkTfidf {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder()
      .master("local[*]")
      .appName("tf-idf")
      .getOrCreate()

    val df = spark.read
      .option("header", "true")
      .option("inferSchema", "true")
      .csv("data/tripadvisor_hotel_reviews.csv")
      .withColumn("DocID", monotonically_increasing_id())
      .withColumn("Text", lower(col("Review")))
      .withColumn("Text", regexp_replace(col("Text"), "\\W", " "))
      .withColumn("Word", split(col("Text"), " "))
      .withColumn("Word", explode(col("Word")))
      .filter(length(col("Word")) > 0)
      .select("Word", "DocID")

    val words = df
      .groupBy("DocID","Word")
      .count()
      .groupBy("Word")
      .agg(sum("count"), count("DocID"))
      .withColumnRenamed("sum(count)", "TermCount")
      .withColumnRenamed("count(DocID)", "DocsCount")

    val tfidf = words
      .crossJoin(words.agg(sum("TermCount"), sum("DocsCount")))
      .sort(desc("TermCount"))
      .limit(100)
      .withColumnRenamed("sum(TermCount)","Tf")
      .withColumn("Tf", col("TermCount") / col("Tf"))
      .withColumnRenamed("sum(DocsCount)", "Idf")
      .withColumn("Idf", log(col("Idf") / (col("DocsCount") + 1)))
      .withColumn("TfIdf", col("Tf") * col("Idf"))
      .toDF()

    tfidf.write.csv("data/tfidf")
    tfidf.show()

    df
      .select("DocID","Word")
      .join(tfidf, "Word")
      .groupBy("DocID")
      .pivot("Word")
      .agg(first("TfIdf"))
      .write.csv("data/pivot")
  }
}
