pragma solidity 0.8.7;

contract helloworld{
    string public greetings = "Greetings from CASH";
    function setGreetings(string memory newGreetings) public{
        greetings = newGreetings;
    }
    
    uint[] public nums = [1, 2, 3];
    function setNewElement(uint index, uint newElement) public{
        nums[index] = newElement;
    }
    
    function pushNewElement(uint newElement) public{
        nums.push(newElement);
    }
    
    function popLastElement() public{
        nums.pop();
    }
}
