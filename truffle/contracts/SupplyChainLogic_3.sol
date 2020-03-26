pragma solidity ^0.6.1;
import "./SupplyChainStorage.sol";

contract SupplyChainLogic_3 is SupplyChainStorage {
    function createParticipant(
        string memory _name,
        string memory _pass,
        address _pAdd,
        string memory _pType
    ) public virtual returns (address) {
        participants[msg.sender].userName = _name;
        participants[msg.sender].password = _pass;
        participants[msg.sender].participantAddress = _pAdd;
        participants[msg.sender].participantType = _pType;
        participant_counter++;
        return _pAdd;
    }

    function getParticipantDetails(address _p_address)
        public
        view
        returns (string memory, address, string memory, uint256[] memory)
    {
        return (
            participants[_p_address].userName,
            participants[_p_address].participantAddress,
            participants[_p_address].participantType,
            participants[_p_address].parts
        );
    }

    function createPart(
        string memory _partNumber,
        string memory _serialNumber,
        uint32 _productCost
    ) public returns (uint32) {
        if (
            keccak256(
                abi.encodePacked(participants[msg.sender].participantType)
            ) ==
            keccak256("Manufacturer")
        ) {
            uint32 partId = part_counter++;

            parts[partId].partNumber = _partNumber;
            parts[partId].serialNumber = _serialNumber;
            parts[partId].cost = _productCost;
            parts[partId].mfgTimeStamp = uint32(now);
            parts[partId].productId = -1;
            participants[msg.sender].parts.push(partId);

            return partId;
        }

        return 0;
    }

    function getPartDetails(uint32 _partId)
        public
        view
        returns (string memory, string memory, uint32, uint32, int32)
    {
        return (
            parts[_partId].partNumber,
            parts[_partId].serialNumber,
            parts[_partId].cost,
            parts[_partId].mfgTimeStamp,
            parts[_partId].productId
        );
    }

    function createProduct(
        string memory _modelNumber,
        string memory _partNumber,
        string memory _serialNumber,
        uint32 _productCost,
        uint32[] memory _parts
    ) public returns (uint32) {
        if (
            keccak256(
                abi.encodePacked(participants[msg.sender].participantType)
            ) ==
            keccak256("Manufacturer")
        ) {
            uint32 productId = product_counter++;
            uint32 registration_id = registration_counter++;

            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[msg.sender]
                .participantAddress;
            products[productId].mfgTimeStamp = uint32(now);
            products[productId].parts = _parts;

            for (uint32 i = 0; i < _parts.length; i++) {
                uint32 _id = _parts[i];
                parts[_id].productId = int32(productId);
            }

            registrations[registration_id].productId = productId;
            registrations[registration_id].productOwner = msg.sender;
            registrations[registration_id].ownerAddress = msg.sender;
            registrations[registration_id].trxTimeStamp = uint32(now);
            productTrack[productId].push(registration_id);

            return productId;
        }

        return 0;
    }

    modifier onlyProductOwner(uint32 _productId) {
        require(msg.sender == products[_productId].productOwner);
        _;
    }

    function getProductDetails(uint32 _productId)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint32,
            address,
            uint32,
            uint256[] memory
        )
    {
        return (
            products[_productId].modelNumber,
            products[_productId].partNumber,
            products[_productId].serialNumber,
            products[_productId].cost,
            products[_productId].productOwner,
            products[_productId].mfgTimeStamp,
            products[_productId].parts
        );
    }

    function transferToOwner(
        address _user1Address,
        address _user2Address,
        uint32 _prodId
    ) public onlyProductOwner(_prodId) returns (bool) {
        participant memory p1 = participants[_user1Address];
        participant memory p2 = participants[_user2Address];
        uint32 registration_id = registration_counter++;

        if (
            keccak256(abi.encodePacked(p1.participantType)) ==
            keccak256("Manufacturer") &&
            keccak256(abi.encodePacked(p2.participantType)) ==
            keccak256("Supplier")
        ) {
            registrations[registration_id].productId = _prodId;
            registrations[registration_id].productOwner = p2.participantAddress;
            registrations[registration_id].ownerAddress = _user2Address;
            registrations[registration_id].trxTimeStamp = uint32(now);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(registration_id);
            emit Transfer(_prodId);

            return (true);
        } else if (
            keccak256(abi.encodePacked(p1.participantType)) ==
            keccak256("Supplier") &&
            keccak256(abi.encodePacked(p2.participantType)) ==
            keccak256("Supplier")
        ) {
            registrations[registration_id].productId = _prodId;
            registrations[registration_id].productOwner = p2.participantAddress;
            registrations[registration_id].ownerAddress = _user2Address;
            registrations[registration_id].trxTimeStamp = uint32(now);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(registration_id);
            emit Transfer(_prodId);

            return (true);
        } else if (
            keccak256(abi.encodePacked(p1.participantType)) ==
            keccak256("Supplier") &&
            keccak256(abi.encodePacked(p2.participantType)) ==
            keccak256("Consumer")
        ) {
            registrations[registration_id].productId = _prodId;
            registrations[registration_id].productOwner = p2.participantAddress;
            registrations[registration_id].ownerAddress = _user2Address;
            registrations[registration_id].trxTimeStamp = uint32(now);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(registration_id);
            emit Transfer(_prodId);

            return (true);
        }

        return (false);
    }

    function getRegistrationDetails(uint32 _regId)
        public
        view
        returns (uint32, address, address, uint32)
    {
        registration memory r = registrations[_regId];

        return (r.productId, r.ownerAddress, r.productOwner, r.trxTimeStamp);
    }

    function authenticateParticipant(
        address _uAddress,
        string memory _uname,
        string memory _pass,
        string memory _utype
    ) public view returns (bool) {
        if (
            keccak256(
                abi.encodePacked(participants[_uAddress].participantType)
            ) ==
            keccak256(abi.encodePacked(_utype))
        ) {
            if (
                keccak256(abi.encodePacked(participants[_uAddress].userName)) ==
                keccak256(abi.encodePacked(_uname))
            ) {
                if (
                    keccak256(
                        abi.encodePacked(participants[_uAddress].password)
                    ) ==
                    keccak256(abi.encodePacked(_pass))
                ) {
                    return (true);
                }
            }
        }
        return (false);
    }
}
