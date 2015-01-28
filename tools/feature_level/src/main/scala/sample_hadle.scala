import org.apache.spark.SparkContext._
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.log4j._

object sampleOperation{
	def featureHandle(sc:SparkContext, value:String,key:String, input:String,rawData:RDD[String],out_file:String){
		value match{
			case "join" => feature_join.featureJoin(sc,key,input,rawData,out_file)
			case "replace" => feature_replace.featureReplace(sc,key,input,rawData,out_file)
			case _ => throw new IllegalArgumentException(s"Did not match methon to handle features")
		}
	}
}
