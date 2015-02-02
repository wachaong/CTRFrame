import org.apache.spark.SparkContext._
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.log4j._

import org.apache.spark.storage.StorageLevel

class feature_join(rawSample:RDD[(String,String)]) extends scala.Serializable{
	private def joinByFeature(input:RDD[String]):RDD[(String,String)]={
                val rst = input.filter(arr => arr.length > 36).map({arr =>
                        val pos = arr.indexOf('\t')
                        (arr.substring(0, pos), arr.substring(pos + 1))
                })
		rawSample.count
		rst.count
		rawSample.join(rst).map(arr => (arr._1, arr._2._1 + "\t" +arr._2._2))
        }

        def featureJoinByCookie(input:RDD[String]):RDD[(String,String)]={
                joinByFeature(input)
        }

        def featureJoinByPageUrl(input:RDD[String]):RDD[(String,String)]={
		null
        }

        def featureJoinByCreativeId(input:RDD[String]):RDD[(String,String)]={
		null
        }
}

object feature_join{
	def featureJoin(sc:SparkContext, key:String, input:String, rawSample:RDD[(String,String)]):RDD[(String,String)]={
		val data = sc.textFile(input)cache//.persist(StorageLevel.MEMORY_AND_DISK)
                val so = new feature_join(rawSample)

                val rst = key match{
                        case "cookie" => so.featureJoinByCookie(data)
                        case "pageUrl" => so.featureJoinByPageUrl(data)
                        case "creativeId" => so.featureJoinByCreativeId(data)
                        case _ => throw new IllegalArgumentException(s"Did not match methon to handle features")
                }
		rst
	}
}
