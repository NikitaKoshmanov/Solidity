pragma solidity 0.8.9;

import "./ownable.sol";
import "./IERC20.sol";

contract Wallet is Ownable{
    
    uint public comission = 0;
    uint constant percent = 100;
    address payable comissionAddress = payable(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db);
    
    function setComission(uint _value) public onlyOwner{
        require(_value <= 100, "Comission should be in range (0..100)"); 
        comission = _value;
    }
    
    function _comission(uint _value) private view returns (uint ) {
        return comission * _value / percent;        
    }
    
    function _valueWithComission(uint _value) private view returns (uint ) {
        return (percent - comission) * _value / percent;        
    }
    
    function transferToken(address tokenAddr, address recipient, uint256 _value) public onlyOwner{
        IERC20(tokenAddr).transfer(recipient, _valueWithComission(_value));
        IERC20(tokenAddr).transfer(comissionAddress, _comission(_value));
    }

    function transferTokenFrom(address tokenAddr, address sender, uint256 _value) public onlyOwner{
        IERC20(tokenAddr).transferFrom(sender, owner, _valueWithComission(_value));
        IERC20(tokenAddr).transferFrom(sender, comissionAddress, _comission(_value));
    }
    
    function approveToken(address tokenAddr, address _spender, uint _value) public onlyOwner{
        IERC20(tokenAddr).approve(_spender, _value);
    }

    function transferEther(address payable recipient, uint value) public payable onlyOwner {
        recipient.transfer(_valueWithComission(value));
        comissionAddress.transfer(_comission(value));
    }
}
