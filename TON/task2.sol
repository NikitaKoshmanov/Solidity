pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract task2 {

	uint public mul = 1;

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

	function multiply(uint value) public checkOwnerAndAccept {
        require(value >= 1 && value <=10, 65);
		mul *= value;
	}
}
