//Declaring the solidity version
pragma solidity ^0.4.16;
 
//Safe Math Interface
 
//calling the Safe Math interface to use math functions in our contract.
contract SafeMath {
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
//Just for one account accept
contract owned{

    address public owner;

    address public admin;

    constructor(){
        admin = msg.sender;
        owner = msg.sender;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
 
 
//ERC Token Standard #20 Interface
//Calling the ERC-20 interface to implement its functions.
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function Burn (uint256 tokens) public returns (bool success);
    function buy (uint256 buyPrice) payable returns (uint amount);


    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 
//Contract function to receive approval and execute function in one call
//A contract function to receive approval and excute a function in one all.
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

 
//Actual token contract
 
contract NNDToken is ERC20Interface, SafeMath, owned {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    string public sellPrice;
    string public buyPrice;
    address public contractss;
    

    //uint tokenPrice = 0.001 ether;
 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    constructor() public {
        symbol = "NND";
        name = "NND Coin";
        decimals = 2;
        _totalSupply = 10000000000;
        balances[0x3EA3CD06c72fB8c6DAc1c57Bb4A183c61e725318] = _totalSupply;
        emit Transfer(address(0), 0x3EA3CD06c72fB8c6DAc1c57Bb4A183c61e725318, _totalSupply);
    }
 
 // Returns the amount of tokens existence
    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

 //Returns the mount of tokens owned by account
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
 
 //Moves amount tokens from the caller's account to recipient, returns a boolean value indicating whether the operation succeeded
 //Emits a transfer event.
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool) {
        require(tokens <= balances[from]);
        require(tokens <= allowed[from][msg.sender]);

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
 
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    //mint function
    function mint(address target, uint256 value) onlyAdmin public {     
        balances[target] += value;
        _totalSupply += value;
    }
    
  
    //burn function
    //approve new burn
    function Burn (uint256 tokens) public returns (bool success){
        require(balances[msg.sender] >= tokens);
        balances[msg.sender]-= tokens;
        _totalSupply -= tokens;
        return true;
    }
     function Prices (uint256 SellPrice, uint256 BuyPrice) public onlyOwner{
        uint sellPrice = SellPrice;
        uint buyPrice = BuyPrice;   
    }
    //buy function
    function buy (uint256 buyPrice) payable returns (uint amount){
        
        amount=msg.value * buyPrice;
        transfer(0x2C71e6dC6251989E48A6b6104E809131Eb47e190, amount);
        return amount;
    }

      
     //sell function
     function sell(uint amount, uint sellPrice) returns (uint revenue){
        require(balances[msg.sender] >= amount);
         balances[this] += amount;
         balances[msg.sender] -= amount;
         revenue=amount*sellPrice;
         msg.sender.transfer(revenue);
         return revenue;
       }

      function () public payable {
        revert();
    }
}