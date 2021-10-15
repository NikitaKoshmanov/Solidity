pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract task3_1 { 

	string[] public queue;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	function pushIn(string line) public checkOwnerAndAccept {
        queue.push(line);
	}

    function popOut() public checkOwnerAndAccept {
        require(!queue.empty(), 54);
        for(uint i = 0; i < queue.length - 1; i++)
            queue[i] = queue [i + 1];
        queue.pop();
    }
}
