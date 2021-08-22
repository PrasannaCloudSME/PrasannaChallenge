**Web Tier:**
The web server is the presentation tier and provides the user interface. This is usually a web page or web site, such as an ecommerce site where the user adds products to the shopping cart, adds payment details or creates an account. The content can be static or dynamic, and is usually developed using HTML, CSS and Javascript .

**Application Tier**
The application server corresponds to the middle tier, housing the business logic used to process user inputs. To continue the ecommerce example, this is the tier that queries the inventory database to return product availability, or adds details to a customer's profile. This layer often developed using Python, Ruby or PHP and runs a framework such as e Django, Rails, Symphony or ASP.NET, for example.

**Database Tier**
The database server is the data or backend tier of a web application. It runs on database management software, such as MySQL, Oracle, DB2 or PostgreSQL, for example.


![Prasanna 3 Tier Azure Architecture ](https://user-images.githubusercontent.com/55081476/130340740-d0a67795-dca6-498c-8bc0-51b7f5a8297a.png)


**I have Used the Terraform Open source tool create the azure Infrastructure, please find the details about terraform and commands to execute the above code**


**Terraform**
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

**The key features of Terraform are:**

**Infrastructure as Code:** Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your datacenter to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.

**Execution Plans:** Terraform has a "planning" step where it generates an execution plan. The execution plan shows what Terraform will do when you call apply. This lets you avoid any surprises when Terraform manipulates infrastructure.

**Execute terraform script using below commands**


Terraform Init

Terraform validate

Terraform Plan 

Terraform Apply 


**I have created the code and tested it on my trail tenant, it is working without any issue. Due to the trai account limitations, im able create only 5 virtual machines now. Please find the resource visualizer diagram based upon the output**


<img width="957" alt="Prasanna Visual studio Code" src="https://user-images.githubusercontent.com/55081476/130367803-a391c771-451d-4d08-93ff-750393c14193.PNG">





<img width="953" alt="Azure 3 tier Resource visualizer" src="https://user-images.githubusercontent.com/55081476/130367340-efda5d50-f9af-4e1d-bb78-5dc31e23e438.PNG">

