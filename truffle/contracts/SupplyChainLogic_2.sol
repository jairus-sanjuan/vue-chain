pragma solidity ^0.6.1;
import "./SupplyChainStorage.sol";

contract SupplyChainLogic_2 is SupplyChainStorage {
    function createParticipant(
        string memory _name,
        string memory _pass,
        address _pAdd,
        string memory _pType
    ) public returns (address) {
        require(
            participants[msg.sender].participantAddress == address(0),
            "Shoudld not be registered yet."
        );
        require(
            bytes(participants[msg.sender].userName).length == 0,
            "Shoudld not be registered yet."
        );
        participants[msg.sender].userName = _name;
        participants[msg.sender].password = _pass;
        participants[msg.sender].participantAddress = _pAdd;
        participants[msg.sender].participantType = _pType;
        participant_counter++;
        return _pAdd;
    }

}
