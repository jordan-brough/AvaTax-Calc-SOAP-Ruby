AvaTax-SOAP-Ruby
=====================
Ruby sample of the AvaTax Calc SOAP API demonstrating: ValidateAddress, Ping, GetTax, GetTaxHistory, PostTax, and CancelTax . This sample was written using Ruby 1.9.2. Although other ruby versions may work, they have not been tested.

This is a Ruby sample demonstrating the [AvaTax SOAP API](http://developer.avalara.com/api-docs/soap) methods:

For more information on the use of these methods and the AvaTax product, please visit our [developer site](http://developer.avalara.com/) or [homepage](http://www.avalara.com/)
 
Contents:
----------
 
<table>
<th colspan="2" align=left>Sample Files</th>
<tr><td>CancelTaxTest.rb</td><td>Demonstrates the CancelTax method used to <a href="http://developer.avalara.com/api-docs/api-reference/canceltax">void a document</a>.</td></tr>
<tr><td>GetTaxHistoryTest.rb</td><td>Demonstrates a GetTaxHistory call to retrieve document details for a saved transaction.</td></tr>
<tr><td>GetTaxTest.rb</td><td>Demonstrates the GetTax method used for product- and line- specific <a href="http://developer.avalara.com/api-docs/api-reference/gettax">calculation</a>.</td></tr>
<tr><td>PingTest.rb</td><td>Demonstrates a ping call to verify connectivity and credentials.</td></tr>
<tr><td>PostTaxTest.rb</td><td>Demonstrates the PostTax method used to <a href="http://developer.avalara.com/api-docs/api-reference/posttax-and-committax">commit</a> a previously recorded document.</td></tr>
<tr><td>Program.rb</td><td>Provides and entry point to call the actual samples.</td></tr>
<tr><td>ValidateAddressTest.rb</td><td>Demonstrates the ValidateAddress method to <a href="http://developer.avalara.com/api-docs/api-reference/address-validation">normalize an address</a>.</td></tr>
<th colspan="2" align=left>Other Files</th>
<tr><td>.gitignore</td><td>-</td></tr>
<tr><td>Gemfile</td><td>-</td></tr>
<tr><td>LICENSE.md</td><td>-</td></tr>
<tr><td>README.md</td><td>-</td></tr>
</table>

Dependencies:
-----------
- Ruby version 1.9.2 or later
- Make sure to install the required gems specified in the gemfile:
--- Using a command prompt, navigate to the root directory of the sample.
--- Run "gem install bundler" to ensure that dependencies can be automatically installed.
--- Run "bundle install" to automatically install the required dependencies.


Requirements:
----------
- Authentication requires an valid **Account Number** and **License Key**, which should be entered in the test file (e.g. GetTaxTest.rb) you would like to run.
- If you do not have an AvaTax account, a free trial account can be acquired through our [developer site](http://developer.avalara.com/api-get-started)
 