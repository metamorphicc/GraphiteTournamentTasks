// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReputationByLoans {

    struct User {
        uint256 reputationScore;
        uint256 totalLoans;
        uint256 outstandingDebt;
        bool isRegistered;
    }

    mapping(address => User) public users;

    event UserRegistered(address user);
    event LoanIssued(address user, uint256 amount, uint256 interestRate);
    event LoanRepaid(address user, uint256 amount);
    event ReputationUpdated(address user, uint256 newScore);

    function calculateInterestRate(address _user) public view returns (uint256) {
        if (users[_user].reputationScore > 80) {
            return 5;  
        } else if (users[_user].reputationScore > 60) {
            return 10; 
        } else {
            return 15; 
        }
    }

    function registerUser(address _user) external {
        require(!users[_user].isRegistered, "User already registered");
        users[_user] = User(100, 0, 0, true); 
        emit UserRegistered(_user);
    }

    function issueLoan(address _user, uint256 amount) external {
        require(users[_user].isRegistered, "User not registered");
        require(users[_user].reputationScore >= 50, "Low reputation");

        uint256 interestRate = calculateInterestRate(_user);
        uint256 totalDebt = amount + (amount * interestRate / 100);

        users[_user].totalLoans++;
        users[_user].outstandingDebt += totalDebt;
        
        emit LoanIssued(_user, amount, interestRate);
    }

    function repayLoan(address _user, uint256 amount) external {
        require(users[_user].isRegistered, "User not registered");
        require(users[_user].outstandingDebt >= amount, "Repayment exceeds debt");

        users[_user].outstandingDebt -= amount;

        if (users[_user].outstandingDebt == 0) {
            updateReputation(_user, 10); 
        }

        emit LoanRepaid(_user, amount);
    }

    function updateReputation(address _user, int256 change) internal {
        require(users[_user].isRegistered, "User not registered");

        int256 newScore = int256(users[_user].reputationScore) + change;
        if (newScore < 0) {
            users[_user].reputationScore = 0;
        } else if (newScore > 100) {
            users[_user].reputationScore = 100;
        } else {
            users[_user].reputationScore = uint256(newScore);
        }

        emit ReputationUpdated(_user, users[_user].reputationScore);
    }

    
}
