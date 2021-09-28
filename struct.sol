pragma solidity 0.8.7;

contract structs{
    struct Company{
        uint id;
        string name;
        uint age;
        uint numberOfWorkers;
        address companyWallet;
    }
    
    Company[] public companies;
    
    function newCompany(string memory name, uint age, uint numberOfWorkers, address companyWallet) public{
        companies.push(Company(companies.length + 1, name, age, numberOfWorkers, companyWallet));
    }
}
