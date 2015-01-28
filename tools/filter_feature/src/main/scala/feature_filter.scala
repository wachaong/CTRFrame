import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.spark.rdd.RDD

import org.apache.log4j._

object feature_filter{
	def main(args: Array[String]){
		val conf = new SparkConf().setAppName("feature_filter")
		val sc = new SparkContext(conf)
		val inputFile = args(0)
		val outFile = args(1)
		val filterThreshold = args(2).toInt
		
		val rawData = sc.wholeTextFiles(inputFile).cache
	
		val kvs = rawData.flatMap(items =>{
			val item = items.split("\t")
			val kvs = item.filter(kv => kv.contains(":"))
			kvs.map(kv => (kv.split(":")(0),1))
		}).reduceByKey(_+_)

		val vec = kvs.filter(_._2.toInt > filterThreshold).map(_._1).collect
		
		val bc = sc.broadcast(vec)
		
		val rst = rawData.map(items => {
			val item = items.split("\t")
			val kvs = item.filter(kv => bc.value.contains(kv.split(":")(0)))
			var rst = kvs.reduce(_ + "\t" + _)
			item.head + "\t" + rst
		})
		rst.saveAsTextFile(outFile)
	}
}
