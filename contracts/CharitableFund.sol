// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityReputation {
    struct Recipient {
        uint256 reputationScore;
        uint256 receivedFunds;
        bool isApproved;
    }
    
    mapping(address => Recipient) public recipients;
    address public admin;

    event FundsAllocated(address indexed recipient, uint256 amount);
    event ReputationUpdated(address indexed recipient, uint256 newScore);
    event RecipientApproved(address indexed recipient);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function approveRecipient(address _recipient) external onlyAdmin {
        recipients[_recipient].isApproved = true;
        emit RecipientApproved(_recipient);
    }

    function updateReputation(address _recipient, uint256 _score) external onlyAdmin {
        require(recipients[_recipient].isApproved, "Recipient not approved");
        recipients[_recipient].reputationScore = _score;
        emit ReputationUpdated(_recipient, _score);
    }

    function allocateFunds(address payable _recipient) external payable {
        require(recipients[_recipient].isApproved, "Recipient not approved");
        require(recipients[_recipient].reputationScore > 50, "Low reputation");
        require(msg.value > 0, "No funds sent");
        
        _recipient.transfer(msg.value);
        recipients[_recipient].receivedFunds += msg.value;
        emit FundsAllocated(_recipient, msg.value);
    }
}
