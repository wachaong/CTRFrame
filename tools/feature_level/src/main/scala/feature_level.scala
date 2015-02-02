import org.apache.spark.{SparkContext, SparkConf}
import org.apache.spark.rdd.RDD

import org.apache.log4j._

import scala.io.Source

import org.apache.spark.storage.StorageLevel

class feature_level(sc:SparkContext, fileName:String){
	private def sampleFormat():RDD[(String,String)]={
		val data = sc.textFile(fileName).filter(_.contains("cookie"))
		val rst = data.map(arr => {
			val items = arr.split("\t")
			val label = items(0)
			val cookie= items(1)
			val pos1 = arr.indexOf("cookie")
			val pos2 = arr.substring(pos1).indexOf("\t")
			(cookie.split("@")(1),label + arr.substring(pos1+pos2))
		}).cache//persist(StorageLevel.DISK_ONLY)//MEMORY_AND_DISK)
		rst
	}
}

object feature_level{
	def main(args: Array[String]){
		val conf = new SparkConf().setAppName("feature_filter")
		conf.set("spark.rdd.compress","true")
		conf.set("spark.core.connection.ack.wait.timeout","600")
		conf.set("spark.akka.retry.wait","90000")
		conf.set("spark.akka.timeout","90000")
		conf.set("spark.storage.blockManagerHeartBeatMs", "90000")
		conf.set("spark.akka.frameSize","1000")
		conf.set("spark.storage.blockManagerTimeoutIntervalMs", "120000")
		conf.set("spark.storage.blockManagerSlaveTimeoutMs","300000")
		conf.set("spark.worker.timeout","600")
		conf.set( "spark.akka.timeout","200")

		val sc = new SparkContext(conf)
		val setFileName = args(0)
		val rawSampleFile = args(1)
		val outFile = args(2)
		val expType = "join"
		val expKey = "cookie"
		val path = "/ad_model/tmp/tmp/2014/11/29"
		
		val setFile = sc.textFile(setFileName).filter(arr => arr.contains("type:feature")).filter(arr=>arr.split("\t").length == 5).collect
		val fl = new feature_level(sc,rawSampleFile)
		//sc.setCheckpointDir(args(3))
		var rawSample = fl.sampleFormat()
		//rawSample.checkpoint()
		val tmp = sampleOperation.featureHandle(sc,expType,expKey,path,rawSample)
		//tmp.checkpoint()
		tmp.saveAsTextFile(outFile)
	
		/*	
		var out_file = outFile
		setFile.map(line =>{
			val items = line.toString.split("\t")
			val expType = items(1).split(":")(1)
			val name = items(2).split(":")(1)
			val expKey = items(3).split(":")(1)
			val path   = items(4).split(":")(1)
			
			rawSample = sampleOperation.featureHandle(sc,expType,expKey,path,rawSample)
			//rawSample.checkpoint()
		})
		rawSample.saveAsTextFile(outFile)
		*/
	}
}
