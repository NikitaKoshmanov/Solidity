pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'D_ListInitialization.sol';

contract D_Shopping is D_ListInitialization{
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Shopping";
        version = "0.0.1";
        publisher = "Dadanik Interactive";
        key = "Shopping list manager";
        author = "dadanikita";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a Shopping DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }
    
    function _menu() public override{
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {} / {} / {} (completed purchases / incompleted purchases / total price)",
                    m_ShoppingSummary.completeCount,
                    m_ShoppingSummary.incompleteCount,
                    m_ShoppingSummary.totalPrice
            ),
            sep,
            [
                MenuItem("Show shopping list","",tvm.functionId(showPurchases)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase)),
                MenuItem("Make a purchase","",tvm.functionId(makePurchase))
            ]
        );
    }
    
    function showPurchases(uint32 index) public view {
        index = index;
        optional(uint256) none;
        I_ShoppingList(m_address).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showPurchases_),
            onErrorId: 0
        }();
    }

    function showPurchases_( Purchase[] purchases ) public {
        uint32 i;
        if (purchases.length > 0 ) {
            Terminal.print(0, "Your shopping list:");
            for (i = 0; i < purchases.length; i++) {
                Purchase purchase = purchases[i];
                string completed;
                if (purchase.isDone) {
                    completed = '✓';
                } else {
                    completed = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\" Quantity: {}, Price: {}  at {}", purchase.id, completed, purchase.name,purchase.amount,purchase.price, purchase.createdAt));
            }
        } else {
            Terminal.print(0, "Your shopping list is empty");
        }
        _menu();
    }

    function deletePurchase(uint32 index) public {
        index = index;
        if (m_ShoppingSummary.completeCount + m_ShoppingSummary.incompleteCount > 0) {
            Terminal.input(tvm.functionId(deletePurchase_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no purchases to delete");
            _menu();
        }
    }

    function deletePurchase_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        I_ShoppingList(m_address).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }     

    function makePurchase(uint32 index) public {
        index = index;
        if (m_ShoppingSummary.completeCount + m_ShoppingSummary.incompleteCount > 0) {
            Terminal.input(tvm.functionId(makePurchase_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, you don't have any scheduled purchases");
            _menu();
        }
    }

    function makePurchase_(string value) public {
        (uint256 num,) = stoi(value);
        m_purchaseId = uint32(num);
        Terminal.input(tvm.functionId(makePurchase__), "Enter the purchase price:", false);

    }
    function makePurchase__(string value) public {
        (uint256 num,) = stoi(value);
        m_purchasePrice = uint32(num);
        optional(uint256) pubkey = 0;
        I_ShoppingList(m_address).updatePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_purchaseId, m_purchasePrice);
    }  
} 