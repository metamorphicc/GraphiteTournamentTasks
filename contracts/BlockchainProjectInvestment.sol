// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract BlockchainProjectRanking {
    address public admin;

    struct Project {
        string name;
        uint8 teamReliability; // 0-100
        uint8 roadmapCompletion; // 0-100
        uint8 marketAdoption; // 0-100
        uint8 reputationScore; // Итоговый рейтинг (0-100)
        uint8 collateralRequirement; // Залоговый процент (0-100)
        bool exists;
    }

    mapping(address => Project) public projects;

    event ProjectRegistered(address indexed project, string name);
    event ReputationUpdated(address indexed project, uint8 reputationScore, uint8 collateralRequirement);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerProject(address _project, string memory _name) external onlyAdmin {
        require(!projects[_project].exists, "Project already registered");

        projects[_project] = Project({
            name: _name,
            teamReliability: 50, // Среднее значение
            roadmapCompletion: 50,
            marketAdoption: 50,
            reputationScore: 50,
            collateralRequirement: 50,
            exists: true
        });

        emit ProjectRegistered(_project, _name);
    }

    function updateProjectData(
        address _project, 
        uint8 _teamReliability, 
        uint8 _roadmapCompletion, 
        uint8 _marketAdoption
    ) external onlyAdmin {
        require(projects[_project].exists, "Project not registered");
        require(_teamReliability <= 100 && _roadmapCompletion <= 100 && _marketAdoption <= 100, "Invalid values");

        projects[_project].teamReliability = _teamReliability;
        projects[_project].roadmapCompletion = _roadmapCompletion;
        projects[_project].marketAdoption = _marketAdoption;

        // Расчет репутационного рейтинга
        uint8 reputation = (_teamReliability + _roadmapCompletion + _marketAdoption) / 3;

        // Чем выше репутация – тем ниже залог
        uint8 collateral = reputation > 80 ? 10 : reputation > 60 ? 30 : 50; // 10%, 30% или 50% залога

        projects[_project].reputationScore = reputation;
        projects[_project].collateralRequirement = collateral;

        emit ReputationUpdated(_project, reputation, collateral);
    }

    function getProjectInfo(address _project) external view returns (string memory, uint8, uint8) {
        require(projects[_project].exists, "Project not registered");
        return (projects[_project].name, projects[_project].reputationScore, projects[_project].collateralRequirement);
    }
}
