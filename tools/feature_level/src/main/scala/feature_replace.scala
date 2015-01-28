import org.apache.spark.SparkContext._
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.log4j._

class feature_replace(sc:SparkContext, rawSample:RDD[String],outFile:String) extends scala.Serializable{
	//
}

object feature_replace{
	def featureReplace(sc:SparkContext, key:String, input:String, rawSample:RDD[String],out_file:String){
		val data = sc.textFile(input)
                val so = new feature_replace(sc,rawSample,out_file)
        }
}
