// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainProjectRanking {

    struct Project {
        string name;
        uint8 teamReliability; 
        uint8 roadmapCompletion; 
        uint8 marketAdoption; 
        uint8 reputationScore; 
        uint8 collateralRequirement; 
        bool exists;
    }

    mapping(address => Project) public projects;

    event ProjectRegistered(address indexed project, string name);
    event ReputationUpdated(address indexed project, uint8 reputationScore, uint8 collateralRequirement);

    function registerProject(address _project, string memory _name) external {
        require(!projects[_project].exists, "Project already registered");
        projects[_project] = Project({
            name: _name,
            teamReliability: 50, 
            roadmapCompletion: 50,
            marketAdoption: 50,
            reputationScore: 50,
            collateralRequirement: 50,
            exists: true
        });

        emit ProjectRegistered(_project, _name);
    }

    function updateProjectData(address _project, uint8 _teamReliability, uint8 _roadmapCompletion, uint8 _marketAdoption) external {
        require(projects[_project].exists, "Project not registered");
        require(_teamReliability <= 100 && _roadmapCompletion <= 100 && _marketAdoption <= 100, "Invalid values");

        projects[_project].teamReliability = _teamReliability;
        projects[_project].roadmapCompletion = _roadmapCompletion;
        projects[_project].marketAdoption = _marketAdoption;

        uint8 reputation = (_teamReliability + _roadmapCompletion + _marketAdoption) / 3;

        uint8 collateral = reputation > 80 ? 10 : reputation > 60 ? 30 : 50; 

        projects[_project].reputationScore = reputation;
        projects[_project].collateralRequirement = collateral;

        emit ReputationUpdated(_project, reputation, collateral);
    }

    function getProjectInfo(address _project) external view returns (string memory, uint8, uint8) {
        require(projects[_project].exists, "Project not registered");
        return (projects[_project].name, projects[_project].reputationScore, projects[_project].collateralRequirement);
    }
}
