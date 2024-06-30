const Migrations = artifacts.require


// All the mifrations that are there in the migration folder will get deployed
module.exports=function(deployer){
    deployer.deploy(Migrations);
}