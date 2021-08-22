The web server is the presentation tier and provides the user interface. This is usually a web page or web site, such as an ecommerce site where the user adds products to the shopping cart, adds payment details or creates an account. The content can be static or dynamic, and is usually developed using HTML, CSS and Javascript .

The application server corresponds to the middle tier, housing the business logic used to process user inputs. To continue the ecommerce example, this is the tier that queries the inventory database to return product availability, or adds details to a customer's profile. This layer often developed using Python, Ruby or PHP and runs a framework such as e Django, Rails, Symphony or ASP.NET, for example.

The database server is the data or backend tier of a web application. It runs on database management software, such as MySQL, Oracle, DB2 or PostgreSQL, for example.


![Prasanna 3 Tier Azure Architecture ](https://user-images.githubusercontent.com/55081476/130340740-d0a67795-dca6-498c-8bc0-51b7f5a8297a.png)


Execute terraform script using below commands


Terraform Init
Terraform Plan -var-file="terraform.tfvars"
Terraform Apply -var-file="terraform.tfvars"
