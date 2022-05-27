pragma solidity ^0.4.16;
interface IERC20 {
    function transfer(address, uint) external returns (bool);

    function transferFrom(
        address, 
        address,
        uint
    ) external returns (bool);
}

contract CrowndFund {
    event Launch (
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endArt
    );
    event Cancel (uint id);
    event pledge (uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim (uint id);
    event Refund(uint id, address indexed caller, uint amount);

    struct Campaign {
        //Create of campaign
        address creator;
        //Amount of tokens  to raise 
        uint goal;
        //Total amount pledged
        uint32 startAt;
        //Timestamp of end of campaign 
        uint32 endAt;
        //True if goal was reached and creator has claimed the tokens.
        bool claimded;
    }

    IERC20 public immutable token;
    //Total count of compaigns created.
    //It is also used to generate id for new campaigns.
    uint public count;
    //Map from id to Campaign
    mapping(uint => Campaign) public campaigns; 
    //Mapping from campaign id => pledge => amount pledge
    mapping(uint => mapping(address => uint)) public pledgeAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }
    
    function launch(
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt, "end at < start at");
        require(_endAt <= block.timestamp + 90 days,"end at > maxduration");

        count += 1;
        campaigns[count] = Campaign ({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            start: _startAt,
            endAt: _endAt,
            claimed: false
         });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp < campaign.startAt, "not started");
        
        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.ended, "ended");
        
        campaign.pledge += amount;
        pledgeAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), amount);  

        emit Pledge(_id, msg.sender, amount);
    }
}