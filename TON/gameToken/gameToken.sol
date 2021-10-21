pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract gameToken{

    struct Token{
        string name;
        string weapon;
        uint power;
        string clothes;
        uint armor;
        uint price;
    }

    Token[] tokensArr;
    mapping(uint => uint) tokenToOwner;
    mapping(uint => uint) listedTokens;
    mapping(string => uint) reservedNames;

    modifier checkOwnerOfTokenAndAccept(uint tokenID) {
        require(msg.pubkey() == tokenToOwner[tokenID], 101);
		tvm.accept();
		_;
	}

    modifier checkOwnerOfListedTokenAndAccept(uint tokenID) {
        require(msg.pubkey() == listedTokens[tokenID], 101);
		tvm.accept();
		_;
	}

    function createToken(string name, string weapon, uint power, string clothes, uint armor) public {
        tvm.accept();
        require(!reservedNames.exists(name), 100);
        tokensArr.push(Token(name, weapon, power, clothes, armor, 0));
        uint keyAsLastNum = tokensArr.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
        reservedNames[name] = msg.pubkey();
    }

    function listToken(uint tokenID, uint price) public checkOwnerOfTokenAndAccept(tokenID){
        delete tokenToOwner[tokenID];
        listedTokens[tokenID] = msg.pubkey();
        tokensArr[tokenID].price = price;
    }

    function unlistToken(uint tokenID) public checkOwnerOfListedTokenAndAccept(tokenID){
        delete listedTokens[tokenID];
        tokenToOwner[tokenID] = msg.pubkey();
        tokensArr[tokenID].price = 0;
    }
}