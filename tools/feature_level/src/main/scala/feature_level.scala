import org.apache.spark.{SparkContext, SparkConf}
import org.apache.spark.rdd.RDD

import org.apache.log4j._

import scala.io.Source

object feature_level{
	def main(args: Array[String]){
		val conf = new SparkConf().setAppName("feature_filter")
		val sc = new SparkContext(conf)
		val setFileName = args(0)
		val rawSampleFile = args(1)
		val outFile = args(2)
		
		val setFile = sc.textFile(setFileName).filter(arr => arr.contains("type:feature")).filter(arr=>arr.split("\t").length == 5).collect
		//setFile.collect.foreach(Logger.getRootLogger().error)
		//val rawSample = sc.wholeTextFiles(rawSampleFile).map(kv => kv._2).cache
		val rawSample = sc.textFile(rawSampleFile).cache

		val test = sc.parallelize(0 until 100,100)

		setFile.map(line =>{
			val items = line.toString.split("\t")
			val expType = items(1).split(":")(1)
			val name = items(2).split(":")(1)
			val expKey = items(3).split(":")(1)
			val path   = items(4).split(":")(1)
			val out_file = outFile + expType + "_" + name + "_" + expKey

			test.saveAsTextFile(out_file)
			//sampleOperation.featureHandle(sc,expType,expKey,path,rawSample,out_file)
		})
	}
}
