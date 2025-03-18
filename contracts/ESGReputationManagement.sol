// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracle {
    function getESGData(address company) external view returns (uint8, uint8, uint8);
}

contract ESGCompliance {
    IOracle public oracle;

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

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function registerCompany(address _company, string memory _name) external {
        require(!companies[_company].exists, "Company already registered");

        companies[_company] = Company({
            name: _name,
            environmentalScore: 50,
            socialScore: 50,
            governanceScore: 50,
            esgRating: 50,
            exists: true
        });

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
