pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "BaseUnit.sol";

contract Archer is BaseUnit{

    constructor () public{
        tvm.accept();
        baseAddress = address(msg.pubkey());
        addUnit("Archer");    
    }   
}