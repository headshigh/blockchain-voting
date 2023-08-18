// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Voting{
    address public chairperson;
    Candidate[] candidates;
    // Voter[] private voters;//people allowed to vote
    mapping(address=>Voter) voters;
    mapping(address=>Voter) emptyvoters;
    eligiblityRequest[] eligiblityRequests;
    struct eligiblityRequest{
        address request;
        bool isDeleted;
    }
    struct Candidate
    {
        string name;
        address addr;
        uint id;
        uint voteCount;
        
    }
    struct Voter{
        bool hasVoted;
    }
    event addCandidateEvent(address recipient,address candId,string candidatename);
    function addCandidate(address id,string memory name) external {
        require(msg.sender==chairperson,'only chairperson is allowed to add candidate');
        candidates.push(Candidate(name,id,candidates.length==0?0:candidates.length-1,0));
        emit addCandidateEvent((msg.sender), id,name);
    }
    constructor(){
        chairperson=msg.sender;
    }
    function allowToVote(address id) external {
        require(msg.sender==chairperson,'only allowed for chairperson');
        voters[id]=Voter(false);//add to voters list
        for(uint i=0;i<eligiblityRequests.length;i++){
            if(eligiblityRequests[i].request==id){
                eligiblityRequests[i].isDeleted=true;
            }
        }
    }
    event voteEvent(uint candidateId,address voter);
    function vote(uint candidateId) external {
        Voter memory voter=voters[msg.sender];
        require(voter.hasVoted==false,'Voter has already voted');
        candidates[candidateId].voteCount++;
        voter.hasVoted=true;
        emit voteEvent(candidateId,msg.sender);
    }
    function getWinner() public view returns (uint,uint)  {
        uint maxVotes=0;
        uint id=0;
        for(uint i=0;i<candidates.length;i++){
            if(candidates[i].voteCount>maxVotes){
                maxVotes=candidates[i].voteCount;
                id=candidates[i].id;
            }
        }
        return (maxVotes,id);
    }
    function getAllCandidates()external view returns (Candidate[] memory){
        return candidates;
    }
    function requestEligiblity(address id) external {
        eligiblityRequests[eligiblityRequests.length]= eligiblityRequest(id,false);
    }
    function getAllRequests() external view returns (address[] memory) {
    uint256 validRequestCount = 0;

    // Count the number of valid requests
    for (uint256 i = 0; i < eligiblityRequests.length; i++) {
        if (!eligiblityRequests[i].isDeleted) {
            validRequestCount++;
        }
    }

    // Create a new memory array to store valid requests
    address[] memory requests = new address[](validRequestCount);

    // Populate the memory array with valid requests
    uint256 currentIndex = 0;
    for (uint256 i = 0; i < eligiblityRequests.length; i++) {
        if (!eligiblityRequests[i].isDeleted) {
            requests[currentIndex] = eligiblityRequests[i].request;
            currentIndex++;
        }
    }

    return requests;
}

}