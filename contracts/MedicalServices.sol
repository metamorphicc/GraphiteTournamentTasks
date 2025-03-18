// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalServices {

    struct Patient {
        string name;
        uint256 id;
        uint256 reputationScore;
        bool isInsured;
        uint256 insuranceCoverage;
        bool isEligibleForDiscount;
    }

    mapping(address => Patient) public patients;
    
    uint256 public maxReputationScore = 100;
    uint256 public minReputationScoreForDiscount = 75;
    uint256 public minReputationScoreForInsuranceCoverage = 50;
    uint256 public discountPercentage = 10;
    uint256 public maxInsuranceCoverage = 100000; 

    event PatientRegistered(address indexed patientAddress, string name, uint256 id);
    event ReputationUpdated(address indexed patientAddress, uint256 newReputationScore);
    event InsuranceUpdated(address indexed patientAddress, uint256 coverageAmount);
    event DiscountEligibilityUpdated(address indexed patientAddress, bool isEligible);

    function registerPatient(address patientAddress, string memory name, uint256 id) public {
        require(bytes(patients[patientAddress].name).length == 0, "Patient already registered");
        
        patients[patientAddress] = Patient({
            id: id,
            name: name,
            reputationScore: 0,
            isInsured: false,
            insuranceCoverage: 0,
            isEligibleForDiscount: false
        });
        
        emit PatientRegistered(patientAddress, name, id);
    }

    function updateReputation(address patientAddress, uint256 newReputationScore) public {
        require(newReputationScore <= maxReputationScore, "Reputation score exceeds maximum");
        
        patients[patientAddress].reputationScore = newReputationScore;
        emit ReputationUpdated(patientAddress, newReputationScore);

        if (newReputationScore >= minReputationScoreForDiscount) {
            patients[patientAddress].isEligibleForDiscount = true;
            emit DiscountEligibilityUpdated(patientAddress, true);
        } else {
            patients[patientAddress].isEligibleForDiscount = false;
            emit DiscountEligibilityUpdated(patientAddress, false);
        }

        if (newReputationScore >= minReputationScoreForInsuranceCoverage) {
            patients[patientAddress].isInsured = true;
            uint256 coverageAmount = maxInsuranceCoverage * (newReputationScore / 100);
            patients[patientAddress].insuranceCoverage = coverageAmount;
            emit InsuranceUpdated(patientAddress, coverageAmount);
        }
    }

    function getPatientInfo(address patientAddress) public view returns (Patient memory) {
        return patients[patientAddress];
    }

    function calculateDiscount(address patientAddress) public view returns (uint256) {
        require(patients[patientAddress].isEligibleForDiscount, "Patient is not eligible for a discount");
        return (patients[patientAddress].insuranceCoverage * discountPercentage) / 100;
    }

    function updateMaxInsuranceCoverage(uint256 newMaxCoverage) public {
        maxInsuranceCoverage = newMaxCoverage;
    }

    function updateDiscountPercentage(uint256 newDiscountPercentage) public {
        discountPercentage = newDiscountPercentage;
    }
}
