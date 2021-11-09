pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "I_ShoppingList.sol";

contract ShoppingList is I_ShoppingList{

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    uint32 m_count;
    mapping(uint32 => Purchase) m_purchase;
    uint256 m_ownerPubkey;

    constructor( uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    function createPurchase(string name, uint32 count) public onlyOwner override {
        tvm.accept();
        m_count++;
        m_purchase[m_count] = Purchase(m_count, name, count, now, false, 0);
    }

    function updatePurchase(uint32 id, uint32 price) public onlyOwner override{
        optional(Purchase) purchase = m_purchase.fetch(id);
        require(purchase.hasValue(), 102);
        tvm.accept();
        Purchase thisPurchase = purchase.get();
        thisPurchase.isDone = true;
        thisPurchase.price = price;
        m_purchase[id] = thisPurchase;
    }

    function deletePurchase(uint32 id) public onlyOwner override{
        require(m_purchase.exists(id), 102);
        tvm.accept();
        delete m_purchase[id];
    }

    function getPurchases() public override returns (Purchase[] purchases) {
        string name;
        uint32 count;
        uint32 price;
        uint64 createdAt;
        bool isDone;
        for((uint32 id, Purchase purchase) : m_purchase) {
            name = purchase.name;
            count = purchase.amount;
            createdAt = purchase.createdAt;
            isDone = purchase.isDone;
            price = purchase.price;
            purchases.push(Purchase(id, name, count, createdAt, isDone, price));
       }
    }

    function getShoppingSummary() public override returns (ShoppingSummary shoppingSummary) {
        uint32 completeCount;
        uint32 incompleteCount;
        uint32 totalPrice;
        for((, Purchase purchase) : m_purchase) {
            if  (purchase.isDone) {
                completeCount += purchase.amount;
            } else {
                incompleteCount += purchase.amount;
            }
            totalPrice += purchase.price * purchase.amount;
        }
        shoppingSummary = ShoppingSummary(completeCount, incompleteCount, totalPrice);
    }
}