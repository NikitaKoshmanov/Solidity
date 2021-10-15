pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract task3_2 { 

	struct Task{
        string name;
        uint32 timestamp;
        bool isReady;
    }

    mapping(uint8 => Task) tasks;
    uint8 private index;
    mapping(uint8 => uint8) private indexes;

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

    function addTask(string name, bool isReady) public checkOwnerAndAccept{
        tasks[index].name = name;
        tasks[index].timestamp = now;
        tasks[index].isReady = isReady;
        indexes[index] = index;
        index++;
    }

	function countOfNonReady() public checkOwnerAndAccept returns(uint8) {
        uint8 count;
        for(uint8 i = 0; i < index; i++)
            if(i == indexes[i])
                if(tasks[i].isReady == false)
                    count++;
        return count;
	}

    function listOfTasks() public checkOwnerAndAccept returns(mapping(uint8 => Task)) {
            return tasks;
    }

    function getTask(uint8 key) public checkOwnerAndAccept returns(Task) {
        return tasks[key];
    }

    function deleteTask(uint8 key) public checkOwnerAndAccept{
        delete tasks[key];
        delete indexes[key];
    }

    function taskIsReady(uint8 key) public checkOwnerAndAccept {
        tasks[key].isReady = true;
    }

}
