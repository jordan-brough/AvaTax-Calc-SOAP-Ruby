require 'Avatax_TaxService'
require 'yaml'

credentials = YAML::load(File.open('credentials.yml'))

# Header Level Parameters
taxSvc = AvaTax::TaxService.new(

# Required Header Parameters
  :username => credentials['account_number'], 
  :password => credentials['license_key'],  
  :use_production_account => credentials['use_production_account'],
  :clientname => "AvaTaxSample",

# Optional Header Parameters  
  :name => "Development") 

postTaxRequest = {  
  # Required Request Parameters
  :companycode => "APITrialCompany",
  :doctype => "SalesInvoice",
  :doccode => "INV001",
  :commit => "false",
  :docdate => "2014-01-01",
  :totaltax => "14.27",
  :totalamount => "175",

  # Optional Request Parameters
  :newdoccode => "INV001-1"
}
  
postTaxResult = taxSvc.posttax(postTaxRequest)

# Print Results
puts "PostTaxTest ResultCode: " + postTaxResult[:result_code]
if postTaxResult[:result_code] != "Success"
  if postTaxResult[:messages][0].nil? 
    puts postTaxResult[:messages][:message][:details]
  else
    postTaxResult[:messages].each { |message| puts message[:details] }
  end
end