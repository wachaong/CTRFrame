import org.apache.spark.SparkContext._
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.log4j._

class feature_join(sc:SparkContext, rawSample:RDD[String],outFile:String) extends scala.Serializable{
	private def joinByFeature(input:RDD[String]){
                val raw = rawSample.map({arr =>
                        val pos = arr.indexOf('\t')
                        (arr.substring(0, pos), arr.substring(pos + 1))
                })
                val result = input.map({arr =>
                        val pos = arr.indexOf('\t')
                        (arr.substring(0, pos), arr.substring(pos + 1))
                }).join(raw)
                result.saveAsTextFile(outFile)
        }

        def featureJoinByCookie(input:RDD[String]){
                joinByFeature(input)
        }

        def featureJoinByPageUrl(input:RDD[String]){
        }

        def featureJoinByCreativeId(input:RDD[String]){
        }
}

object feature_join{
	def featureJoin(sc:SparkContext, key:String, input:String, rawSample:RDD[String], out_file:String){
		val data = sc.textFile(input)
                val so = new feature_join(sc,rawSample,out_file)

                key match{
                        case "cookie" => so.featureJoinByCookie(data)
                        case "pageUrl" => so.featureJoinByPageUrl(data)
                        case "creativeId" => so.featureJoinByCreativeId(data)
                        case _ => throw new IllegalArgumentException(s"Did not match methon to handle features")
                }
	}
}
