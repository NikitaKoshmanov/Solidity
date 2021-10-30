pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObj.sol";
import "GameInt.sol";

contract BaseUnit is GameObj{   

    address public baseAddress;

    function getPower(uint value) virtual public checkOwnerAndAccept{
        objects[callerAddress].power = value;
    }

    function getArmor(int value) virtual public checkOwnerAndAccept override{
        objects[callerAddress].armor = value;
    }

    function attack(GameInt attackAddr, address signer) public checkOwnerAndAccept{
        objects[callerAddress].money += attackAddr.getDamage(signer, objects[callerAddress].power);
        attackAddr.getDamage(signer, objects[callerAddress].power);
    }

    function death(address addr) public checkOwnerAndAccept{
        delete objects[addr];
    }
}