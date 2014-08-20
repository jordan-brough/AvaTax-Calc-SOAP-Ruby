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

cancelTaxRequest = {
    # Required Request Parameters
    :companycode => "APITrialCompany",
    :doctype => "SalesInvoice",
    :doccode => "INV001",
    :cancelcode => "DocVoided"
    }

cancelTaxResult = taxSvc.canceltax(cancelTaxRequest)

# Print Results
puts "CancelTaxTest ResultCode: "+cancelTaxResult[:result_code]
if cancelTaxResult[:result_code] != "Success"
  cancelTaxResult[:messages].each { |message| puts message[:details] }
end