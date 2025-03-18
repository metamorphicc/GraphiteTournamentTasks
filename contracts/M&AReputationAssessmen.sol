// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract CompanyReputation {
    address public admin;

    struct Company {
        string name;
        uint8 governanceScore; 
        uint8 legalDisputes; 
        uint8 reputationRating; 
        bool exists;
    }

    mapping(address => Company) public companies;

    event CompanyRegistered(address indexed company, string name);
    event ReputationUpdated(address indexed company, uint8 reputationRating);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerCompany(address _company, string memory _name) external onlyAdmin {
        require(!companies[_company].exists, "Company already registered");

        companies[_company] = Company({
            name: _name,
            governanceScore: 50, 
            legalDisputes: 0,
            reputationRating: 50, 
            exists: true
        });

        emit CompanyRegistered(_company, _name);
    }

    function updateCompanyData(
        address _company, 
        uint8 _governanceScore, 
        uint8 _legalDisputes
    ) external onlyAdmin {
        require(companies[_company].exists, "Company not registered");
        require(_governanceScore <= 100, "Invalid governance score");

        companies[_company].governanceScore = _governanceScore;
        companies[_company].legalDisputes = _legalDisputes;


        uint8 reputation = _governanceScore > _legalDisputes * 10 
            ? _governanceScore - (_legalDisputes * 10) 
            : 0; 

        companies[_company].reputationRating = reputation;

        emit ReputationUpdated(_company, reputation);
    }

    function getReputationRating(address _company) external view returns (uint8) {
        require(companies[_company].exists, "Company not registered");
        return companies[_company].reputationRating;
    }
}
