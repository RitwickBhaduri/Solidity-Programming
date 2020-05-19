pragma solidity v0.4.0;

contract Ballot {
    
    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
    }
    
    struct Proposal {
        uint voteCounter;
    }
    
    address chairperson;
    mapping (address => voter) voters;
    Proposal[] proposals;
    
    fuction Ballot(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        proposals.length = _numProposals;
    }
    
    function register(address tovoter) public {
        if (msg.sender != chairperson || voters[tovoter].voted) return;
        voters[tovoter].weight = 1;
        voters[tovoter].voted = false;
    }
    
    function vote(uint8 toProposal) public {
        voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }
    
    funtion winningProposal() public constant returns (uint8 _winningProposal) {
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}
