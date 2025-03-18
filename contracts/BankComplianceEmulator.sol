// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankComplianceEmulator {

    struct Client {
        string fullName;
        bool kycVerified;
        bool amlClearance;
        uint8 fatfRiskLevel; 
        bool exists;
    }

    mapping(address => Client) public clients;

    event ClientRegistered(address indexed client, string fullName);
    event ComplianceUpdated(address indexed client, bool kyc, bool aml, uint8 fatfRisk);

    function registerClient(address _client, string memory _fullName) external {
        require(!clients[_client].exists, "Client already registered");

        clients[_client] = Client({
            fullName: _fullName,
            kycVerified: false,
            amlClearance: false,
            fatfRiskLevel: 0,
            exists: true
        });

        emit ClientRegistered(_client, _fullName);
    }

    function updateCompliance(
        address _client, 
        bool _kycVerified, 
        bool _amlClearance, 
        uint8 _fatfRiskLevel
    ) external {
        require(clients[_client].exists, "Client not registered");
        require(_fatfRiskLevel <= 10, "Invalid FATF risk level");

        clients[_client].kycVerified = _kycVerified;
        clients[_client].amlClearance = _amlClearance;
        clients[_client].fatfRiskLevel = _fatfRiskLevel;

        emit ComplianceUpdated(_client, _kycVerified, _amlClearance, _fatfRiskLevel);
    }

    function checkCompliance(address _client) external view returns (bool) {
        require(clients[_client].exists, "Client not registered");
        
        return clients[_client].kycVerified && clients[_client].amlClearance && clients[_client].fatfRiskLevel <= 3;
    }
}

