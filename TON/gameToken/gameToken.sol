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
    mapping(string => uint) reservedNames;
    uint private addressForSellings = 123456789;

    modifier checkOwnerOfTokenAndAccept(uint tokenID) {
        require(msg.pubkey() == tokenToOwner[tokenID], 101);
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

    function sellToken(uint tokenID, uint price) public checkOwnerOfTokenAndAccept(tokenID){
        tokenToOwner[tokenID] = addressForSellings;
        tokensArr[tokenID].price = price;
    }
}