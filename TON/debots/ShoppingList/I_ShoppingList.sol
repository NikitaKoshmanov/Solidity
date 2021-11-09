pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

struct Purchase{
    uint32 id;
    string name;
    uint32 amount;
    uint64 createdAt;
    bool isDone;  
    uint32 price;  
}

struct ShoppingSummary {
    uint32 completeCount;
    uint32 incompleteCount;
    uint32 totalPrice;
}

interface I_ShoppingList {
    function createPurchase(string title, uint32 count) external;
    function updatePurchase(uint32 id, uint32 price) external;
    function deletePurchase(uint32 id) external;
    function getPurchases() external returns (Purchase[] purchases);
    function getShoppingSummary() external returns (ShoppingSummary);
}

interface Transactable {
    function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload) external;
}

abstract contract AShoppingList {
   constructor(uint256 pubkey) public {}
}
