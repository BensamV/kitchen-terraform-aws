Pre-requisites
==============

    #Terraform
    #Bundler => brew install bundler
    #Ruby => brew install ruby
    
Setup Environment
=================

    #Create a GEM file with the below contents
       
        > vim Gemfile
        source "https://rubygems.org/" do
          gem "kitchen-terraform", "~> 4.0"
        end
        
    #Install the gems via bundler
        
        > bundle install
      
Setup Test Kitchen
==================

    #Create a .kitchen.yml file
    
        > vim .kitchen.yml
        
    #Kitchen-Terraform provides three plugins for use with Test-Kitchen - 
    driver - Terraform (https://www.rubydoc.info/github/newcontext-oss/kitchen-terraform/Kitchen/Driver/Terraform)
    provisioner - Terraform (https://www.rubydoc.info/github/newcontext-oss/kitchen-terraform/Kitchen/Provisioner/Terraform)
    verifier - Terraform (https://www.rubydoc.info/github/newcontext-oss/kitchen-terraform/Kitchen/Verifier/Terraform)
    
Tests
=====

    #Create an inspec profile inside the test/integration/<profilename> directory
    
        > inspec init profile 08KTdemo2

    #Add controls inside the controls directory, which can be executed against the object under test
    
Run Tests via Kitchen Terraform
===============================
    
    #Kitchen Create - It will create the terraform workspace, <suite-name> - <platform>
    
        > bundle exec kitchen create
    
    #Kitchen Converge - Create and apply plan
    
        > bundle exec kitchen converge
        
    #Kitchen verify - The controls created are executed against the object under test.
    
        > bundle exec kitchen verify
        
    #Kitchen destroy - Will destroy the resources created and also the workspace.
    
        > bundle exec kitchen destroy
        
    #Kitchen test - The above 4 meta-actions create, converge, verify, destroy can be combined and run against a single
    command.
    
        > bundle exec kitchen test
        
**Note**: 
When we do a kitchen test, if a test fails, destruction of resources will not happen as it will leave the system
for us to examine. However, if we still want to destroy the resources, we can use the --destroy flag.
    
    