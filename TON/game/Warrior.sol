pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "BaseUnit.sol";

contract Warrior is BaseUnit{
    
    constructor () public{
        tvm.accept();
        callerAddress = address(msg.pubkey());
        addUnit("Warrior");    
    }  
}