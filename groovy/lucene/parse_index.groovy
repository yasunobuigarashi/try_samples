@Grab('org.apache.lucene:lucene-core:6.2.1')
import org.apache.lucene.index.DirectoryReader
import org.apache.lucene.store.FSDirectory

import java.nio.file.Paths

def dataDir = args[0]

def dir = FSDirectory.open(Paths.get(dataDir))

DirectoryReader.open(dir).withCloseable { reader ->
	println '[Document]'
	println "numDocs = ${reader.numDocs()}"

	// Document
	(0..<reader.numDocs()).each {
		def doc = reader.document(it)

		println "----- <doc> ${it} -----"

		doc.fields.each { f -> 
			def value = f.binaryValue()? f.binaryValue().utf8ToString(): f.stringValue()

			println "<field> name=${f.name}, value=${value}, class=${f.class}"
		}
	}

	println ''

	println '[Term]'
	// Term
	reader.leaves().each { ctx ->
		def leafReader = ctx.reader()

		leafReader.fields().each { name ->
			def termsEnum = leafReader.terms(name).iterator()

			println "----- <term> name=${name}, freq=${termsEnum.docFreq()}, total=${termsEnum.totalTermFreq()} -----"

			try {
				while(termsEnum.next() != null) {
					println termsEnum.term().utf8ToString()
				}
			} catch(e) {
			}
		}
	}
}