require 'Avatax_TaxService'
require 'yaml'

credentials = YAML::load(File.open('credentials.yml'))

# Header Level Parameters
taxSvc = AvaTax::TaxService.new(

# Required Header Parameters
  :username => credentials['account_number'], 
  :password => credentials['license_key'],  
  :use_production_url => credentials['use_production_url'],
  :clientname => "AvaTaxSample",

# Optional Header Parameters  
  :name => "Development") 

commitTaxRequest = {  
  # Required Request Parameters
  :companycode => "APITrialCompany",
  :doctype => "SalesInvoice",
  :doccode => "INV001-1",

  # Optional Request Parameters
  :newdoccode => "INV001"
}
  
commitTaxResult = taxSvc.committax(commitTaxRequest)

# Print Results
puts "CommitTaxTest ResultCode: " + commitTaxResult[:result_code]
if commitTaxResult[:result_code] != "Success"
  if commitTaxResult[:messages][0].nil? 
    puts commitTaxResult[:messages][:message][:summary]
  else
    commitTaxResult[:messages].each { |message| puts message[:details] }
  end
end