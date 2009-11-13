require '../lib/cadenza'

parser = Cadenza::Parser.new
template = parser.parse( File.open('example.cadenza').read )

f = File.open('output.html','w')

f.write(template.render({'title'=>'This is a Cadenza Page!','test_variable'=>true,'values'=>['one','two','three','four']},''))

f.close