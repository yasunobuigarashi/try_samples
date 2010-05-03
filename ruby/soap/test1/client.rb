
require 'soap/wsdlDriver'

wsdl = 'http://localhost:1099/SimpleTest/Service.asmx?wsdl'

service = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

#SOAP と Ruby の型変換を有効にする
service.generate_explicit_type = true


p service.methods

puts service.helloWorld(nil).helloWorldResult

