pragma solidity 0.4.20;

contract Election {
    string public winner;
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    mapping(address => bool) private authenticate;
    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    function Election () public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
        authenticate[msg.sender] = true;
    }

    function addCandidate (string _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);
        
        //require that the manager cannot voter
        require(!authenticate[msg.sender]);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        votedEvent(_candidateId);
    }
    
    function winnerSelection() public returns (string) {
        
        require(authenticate[msg.sender]);
        if (candidates[1].voteCount > candidates[2].voteCount){
            winner = candidates[1].name;
        }
        else if(candidates[1].voteCount < candidates[2].voteCount){
            winner = candidates[2].name;
        }
        else{
            winner = "Tie";
        }
    }
}

