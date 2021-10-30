pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameInt.sol";

contract GameObj is GameInt{

    struct Object{
        string unitType;
        int armor;
        uint power;
        uint money;
        //uint lifes;
    }

    address public callerAddress;
    mapping(address => Object) objects;
    //uint public reward;

    modifier checkOwnerAndAccept() {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    function addUnit(string unitType) virtual public checkOwnerAndAccept{
        //callerAddress = msg.sender;
        objects[callerAddress].unitType = unitType;
        objects[callerAddress].money = 5;
    }

    function getObj(address addr) public view returns(Object){
        tvm.accept();
        return objects[addr];
    }

    function getAddress() public view returns(address){
        tvm.accept();
        return callerAddress;
    }

    function getArmor (int _armor) virtual external {
        tvm.accept();
        objects[callerAddress].armor = _armor;
    }

    function getDamage(address receiver, uint damage) virtual external override returns(uint reward) {
        tvm.accept();
        objects[receiver].armor -= int(damage);
        if(objects[receiver].armor <= 0){
            reward = objects[receiver].money;
            objects[receiver].money = 0;
            delete objects[receiver];
        }
    }    
}
