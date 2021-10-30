pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface GameInt {
    function getDamage(address receiver, uint value) external returns(uint);
    }