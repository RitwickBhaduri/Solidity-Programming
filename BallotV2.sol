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
    
    enum stage {Init,Reg,Vote,Done}
    Stage public stage = Stage.Init;
    
    address chairperson;
    mapping (address => voter) voters;
    Proposal[] proposals;
    
    uint startTime;
    
    fuction Ballot(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        proposals.length = _numProposals;
        Stage = Stage.Reg;
        startTime = now;
    }
    
    function register(address tovoter) public {
        if (stage != Stage.Reg) {return;}
        if (msg.sender != chairperson || voters[tovoter].voted) return;
        voters[tovoter].weight = 1;
        voters[tovoter].voted = false;
        if (now > ( startTime+ 10 seconds)) {stage = Stage.Vote; startTime = now;}
    }
    
    function vote(uint8 toProposal) public {
        if (stage != Stage.Vote) {return;}
        voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
        if (now > ( startTime+ 10 seconds)) {stage = Stage.Done;}
    }
    
    funtion winningProposal() public constant returns (uint8 _winningProposal) {
        if (stage != Stage.Done) {return;}
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}
