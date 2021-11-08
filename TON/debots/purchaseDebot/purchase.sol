pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

contract Purchases {
    /*
     * ERROR CODES
     * 100 - Unauthorized
     * 102 - task not found
     */

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    uint32 m_count;

    struct Purchase {
        uint32 id;
        string text;
        //uint32 amount;
        uint64 createdAt;
        bool isDone;
        uint32 sum;
    }

    struct Stat {
        uint32 completeCount;
        uint32 incompleteCount;
        //uint32 sum;
    }

    mapping(uint32 => Purchase) m_purchases;

    uint256 m_ownerPubkey;

    constructor( uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    function createTask(string text) public onlyOwner {
        tvm.accept();
        m_count++;
        m_purchases[m_count] = Purchase(m_count, text, now, false, 0);
    }

    /*function updatePurchase(uint32 id, bool done) public onlyOwner {
        optional(Purchase) task = m_purchases.fetch(id);
        require(task.hasValue(), 102);
        tvm.accept();
        Purchase thisTask = task.get();
        thisTask.isDone = done;
        m_purchases[id] = thisTask;
    }*/

    function deletePurchase(uint32 id) public onlyOwner {
        require(m_purchases.exists(id), 102);
        tvm.accept();
        delete m_purchases[id];
    }

    //
    // Get methods
    //

    function getTasks() public view returns (Purchase[] tasks) {
        string text;
        uint64 createdAt;
        bool isDone;
        uint32 amount;
        uint32 sum;

        for((uint32 id, Purchase task) : m_purchases) {
            text = task.text;
            isDone = task.isDone;
            createdAt = task.createdAt;
            //amount = task.amount;
            sum = task.sum;
            tasks.push(Purchase(id, text, createdAt, isDone, sum));
       }
    }

    function getStat() public view returns (Stat stat) {
        uint32 completeCount;
        uint32 incompleteCount;


        for((, Purchase task) : m_purchases) {
            if  (task.isDone) {
                completeCount ++;
            } else {
                incompleteCount ++;
            }
        }
        stat = Stat( completeCount, incompleteCount );
    }
}
