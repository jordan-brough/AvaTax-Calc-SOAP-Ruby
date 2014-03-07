require 'Avatax_TaxService'
require 'yaml'

#Create an instance of the service class
credentials = YAML::load(File.open('credentials.yml'))
svc = AvaTax::TaxService.new(:username => credentials['username'], 
      :password => credentials['password'],  
      :clientname => credentials['clientname'],
      :use_production_url => credentials['production']) 
  
  #Create the request
  request = {
    :doccode=>"MyDocCode",    #Required
    :companycode=> credentials['companycode'],      #Required
    :doctype=>"SalesInvoice", #Required
    :docid=> "",              #Optional
    :detaillevel=>"Tax",      #Optional
    :debug => false           #Optional
    }
  #Call the service
result = svc.gettaxhistory(request)
#print result
#Display the result
puts "GetTaxHistory ResultCode: "+result[:result_code]
#If we encountered an error
if result[:result_code] != "Success"
  puts result[:details]
else
  puts "DocCode: " + result[:get_tax_result][:doc_code]+ " Total Tax Calculated: " + result[:get_tax_result][:total_tax].to_s
  puts "Jurisdiction Breakdown:"
  #Show the tax amount calculated at each jurisdictional level
  result[:get_tax_result][:tax_lines][:tax_line].each do |line|
    puts "   "+ "Line Number " + line[:no] + ": Tax: " + line[:tax]
    #This will display the jurisdiction name and tax at each jurisdiction for the line.
    line[:tax_details][:tax_detail].each do |key,value| 
      puts "       " + key.to_s+ ": " + value.to_s
    end
  end
end