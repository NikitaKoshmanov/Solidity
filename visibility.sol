pragma solidity 0.8.7;

contract helloWorld{
    struct Company{
        string name;
        uint age;
        uint workers;
        string status;
    }
    
    mapping(address => Company) private companies;
    
    function addCompany(string memory name, uint age, uint workers) public{
        Company memory newCompany;
        newCompany.name = name;
        newCompany.age = age;
        newCompany.workers = workers;
        if(workers <= 10){
            newCompany.status = 'small';
        }else if(workers > 10 && workers <= 30){
            newCompany.status = 'medium';
        }else{
            newCompany.status = 'huge';
        }
        insertCompany(newCompany);
    }
    
    function insertCompany(Company memory newCompany) private{
        address sender = msg.sender;
        companies[sender] = newCompany;
    }
    
    function getCompany() public view returns(string memory name, uint age, uint workers, string memory status){
        address sender = msg.sender;
        return(companies[sender].name, companies[sender].age, companies[sender].workers, companies[sender].status);
    }
}
