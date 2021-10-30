pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObj.sol";

contract BaseStation is GameObj{

    constructor() public{
        //tvm.accept();
        //require(msg.pubkey() == 0, 102);
        callerAddress = address(msg.pubkey());
        addUnit("Station");
    }

    function addUnit(string newObj) public checkOwnerAndAccept override{
        //callerAddress = msg.sender;
        objects[callerAddress].unitType = newObj;
        objects[callerAddress].money = 5;
    }

    function deleteUnit(address delObj) public checkOwnerAndAccept{
        delete objects[delObj];
    }
}