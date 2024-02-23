// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public owner;

    struct Candidate {
        uint id;
        string name;
        uint age;
        uint voteCount;
    }

    Candidate[] public candidates;

    mapping(address => bool) public voters;

    event NewCandidateAdded(uint indexed id, string name, uint age);

    event VoteCasted(address indexed voter, uint indexed candidateId);

    event WinnerDeclared(uint indexed winnerId, string name, uint voteCount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addCandidate(string memory _name, uint _age) public onlyOwner {
        uint candidateId = candidates.length; // Assign new ID for each candidate
        candidates.push(Candidate(candidateId, _name, _age, 0));
        emit NewCandidateAdded(candidateId, _name, _age);
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "You have already voted");
        require(_candidateId < candidates.length, "Invalid candidate ID");

        candidates[_candidateId].voteCount++;
        voters[msg.sender] = true;

        emit VoteCasted(msg.sender, _candidateId);
    }

    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }

    function declareWinner() public onlyOwner {
        uint winningVoteCount = 0;
        uint winningCandidateId;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = candidates[i].id;
            }
        }

        emit WinnerDeclared(winningCandidateId, candidates[winningCandidateId].name, winningVoteCount);
    }
}
