// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IESGOracle {
    function getESGData(address company) external view returns (uint8, uint8, uint8);
}

contract ESGOracle is IESGOracle {
    struct ESGScores {
        uint8 environmental;
        uint8 social;
        uint8 governance;
    }

    mapping(address => ESGScores) public esgData;
    address public admin;

    event ESGDataUpdated(address indexed company, uint8 environmental, uint8 social, uint8 governance);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can update ESG data");
        _;
    }

    function updateESGData(address company, uint8 env, uint8 soc, uint8 gov) external onlyAdmin {
        require(env <= 100 && soc <= 100 && gov <= 100, "Invalid ESG values");
        esgData[company] = ESGScores(env, soc, gov);
        emit ESGDataUpdated(company, env, soc, gov);
    }

    function getESGData(address company) external view override returns (uint8, uint8, uint8) {
        ESGScores memory scores = esgData[company];
        return (scores.environmental, scores.social, scores.governance);
    }
}

contract ESGReputationManagement {
    IESGOracle public oracle;
    address oracleAddress = 0x0edbb9b3cD2b26230F5EbA6D1091270DF6425718;
    struct Company {
        string name;
        uint8 environmentalScore;
        uint8 socialScore;
        uint8 governanceScore;
        uint8 esgRating;
        bool exists;
    }

    mapping(address => Company) public companies;

    event CompanyRegistered(address indexed company, string name);
    event ESGUpdated(address indexed company, uint8 esgRating);

    constructor() {
        oracle = IESGOracle(oracleAddress);
    }

    function registerCompany(address _company, string memory _name) external {
        require(!companies[_company].exists, "Company already registered");
        companies[_company] = Company(_name, 50, 50, 50, 50, true);
        emit CompanyRegistered(_company, _name);
    }

    function fetchESGFromOracle(address _company) external {
        require(companies[_company].exists, "Company not registered");

        (uint8 _env, uint8 _soc, uint8 _gov) = oracle.getESGData(_company);
        updateESGData(_company, _env, _soc, _gov);
    }

    function getESGRating(address _company) external view returns (uint8) {
        require(companies[_company].exists, "Company not registered");
        return companies[_company].esgRating;
    }

    function updateESGData(address _company, uint8 _env, uint8 _soc, uint8 _gov) public {
        require(companies[_company].exists, "Company not registered");
        require(_env <= 100 && _soc <= 100 && _gov <= 100, "Invalid ESG values");

        companies[_company].environmentalScore = _env;
        companies[_company].socialScore = _soc;
        companies[_company].governanceScore = _gov;

        uint8 esgRating = (_env + _soc + _gov) / 3;
        companies[_company].esgRating = esgRating;

        emit ESGUpdated(_company, esgRating);
    }
}

