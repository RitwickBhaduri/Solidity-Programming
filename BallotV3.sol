pragma solidity v0.4.0;

contract Ballot {
    
    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
        address delegate;
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
    
    modifier validStage(Stage reqStage)
    { require(stage == reqStage);
    _;
    }
    
    event votingCompleted;
    
    fuction Ballot(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        proposals.length = _numProposals;
        Stage = Stage.Reg;
        startTime = now;
    }
    
    function register(address tovoter) public validStage(Stage.Reg){
        if (msg.sender != chairperson || voters[tovoter].voted) return;
        voters[tovoter].weight = 1;
        voters[tovoter].voted = false;
        if (now > ( startTime+ 20 seconds)) {stage = Stage.Vote;}
    }
    
    function vote(uint8 toProposal) public validStage(Stage.Vote){
        voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
        if (now > ( startTime+ 20 seconds)) {stage = Stage.Done; voitingCompleted();}
    }
    
    funtion winningProposal() public validStage(Stage.Done) constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
            assert(winningVoteCount > 0);
    }
}
