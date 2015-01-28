import scala.xml._

object parse_xml{
	private def formatData(node:Node):String = {
		var rst:String = ""
		val experiment = (node \\ "experiment")
		experiment.map(exp => {
			val typeNode = (node \\ "@type").map(node => node.text)
			if(!typeNode.isEmpty){
				if(typeNode(0).contains("feature")){
	                        	rst += "type:"+"feature"+"\t"
				}else{
					rst += "type:"+typeNode(0)+"\t"
				}
			}
		        val className = (exp \\  "class").map(node => node.text)
			if(!className.isEmpty)
				rst += "className:"+className.reduce(_+"\t"+_)+"\t"
	        	val parameter = (exp \\ "parameters").map(node => node.text)
			if(!parameter.isEmpty)
                	        rst += "param:"+parameter.reduce(_+"\t"+_)+"\t"
		        val bucket_num = (exp \\ "@bucket_num").map(node => node.text)
			if(!bucket_num.isEmpty)
                	        rst += "bucketNum:"+bucket_num.reduce(_+"\t"+_)+"\t"
	        	val bucket_bin = (exp \\ "experiment" \\ "@bucket_bin").map(node => node.text)
			if(!bucket_bin.isEmpty)
                	        rst += "bucketBin:"+bucket_bin.reduce(_+"\t"+_)+"\t"
			val tp = (exp \\ "type").map(node => node.text)
			if(!tp.isEmpty){
				rst += "experimentType:"+tp(0)+"\t"
			}
			val name = (exp \\ "@name").map(node => node.text)
			if(!name.isEmpty){
				rst+="experimentName:"+name(0)+"\t"
			}
			val experimentKey=(exp \\ "key").map(node => node.text)
			if(!experimentKey.isEmpty)
				rst += "experimentKey:"+experimentKey.reduce(_+"\t"+_)+"\t"
			val experimentPath=(exp \\ "path").map(node => node.text)
			if(!experimentPath.isEmpty)
                	        rst += "experimentPath:"+experimentPath.reduce(_+"\t"+_)+"\t"
			rst += "\n"
		})
	        rst
	}

	def main(args: Array[String]){
		val xmlFile = args(0)

		val xml = XML.loadFile(xmlFile)
		val layer = xml \\ "layer"
		layer.foreach(node => {
			val items = formatData(node)
			print(items)
		})
	}
}
