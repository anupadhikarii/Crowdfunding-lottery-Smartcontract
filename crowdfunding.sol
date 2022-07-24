// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract Crowdfunding{
    
    address  manager;  
    uint deadline;
    uint target;
    uint minimumcintribution;
    uint raisedAmount;
    uint no_of_contributtion;
    uint no_of_request;

    mapping(address => uint) public contributors;

    constructor(uint _deadline, uint _target){
        manager = msg.sender;
        deadline = block.timestamp + _deadline;
        target = _target;
        minimumcintribution = 100 wei;
    }

    struct fund_request{
        address  payable recipitant;
        string topic;
        uint request_amount;
        bool completed;
        uint no_of_votters;
        mapping(address => bool) voters;

    }
    mapping(uint => fund_request) public Requests;

    //contributing in fund transfer
    function sendether() public payable{
        require( block.timestamp < deadline,"Deadline have been finished");
        require(msg.value >= minimumcintribution ,"Minimum wei should be 100");
       
        if(contributors[msg.sender] == 0){
            no_of_contributtion++;
            }
        contributors[msg.sender] = msg.value;
        raisedAmount += msg.value;
    }

    //Refund option if date extend
    function refund() public {
        require(block.timestamp > deadline && raisedAmount > target,"not eligible for refund");
        require(contributors[msg.sender] > 0);
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }

    //voting by contributors
    function vote(uint index) public {
        require(contributors[msg.sender] > 0,"you cannot Vote");
        fund_request storage thisrequest = Requests[index];
        require(thisrequest.voters[msg.sender] == false,"we have already voted");
        thisrequest.voters[msg.sender] = true;
        thisrequest.no_of_votters++;

    }
    //Requesting for fund
    function request_fund(string memory _topic, uint _amount, address payable _recipitant) public {
        require(msg.sender == manager,"This function can only be called by manager");
        fund_request storage newrequest = Requests[no_of_request] ;
        no_of_request++;
        newrequest.recipitant = _recipitant;
        newrequest.topic = _topic;
        newrequest.request_amount = _amount;
        newrequest.completed = false;
        newrequest.no_of_votters = 0;

    }

    //transfering fund to address which have majority of votes
    function make_fund_transfer(uint _requestno) public {

        require(msg.sender == manager,"This function can only be called by manager");
        fund_request storage thisrequest = Requests[_requestno];
        require(thisrequest.completed == false,"fund already transfer");
        require(thisrequest.no_of_votters > no_of_contributtion/2,"not a majority support");
        thisrequest.completed = true;
        thisrequest.recipitant.transfer(thisrequest.request_amount);

  
    }

}
