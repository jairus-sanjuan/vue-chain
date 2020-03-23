pragma solidity ^0.6.1;
import "./SupplyChainStorage.sol";

contract SupplyChainLogic is SupplyChainStorage {
    address target;

    constructor(address _target) public {
        target = _target;
    }

    function invoke_create_participant(
        string memory _name,
        string memory _pass,
        address _pAdd,
        string memory _pType
    ) public returns (bool, bytes memory) {
        bytes memory payload = abi.encodeWithSignature(
            "createParticipant(string,string,address,string)",
            _name,
            _pass,
            _pAdd,
            _pType
        );

        (bool ok, bytes memory res) = target.call(payload);
        if (!ok) {
            return (false, res);
        } else {
            return (true, res);
        }
    }

    function createParticipant(
        string memory _name,
        string memory _pass,
        address _pAdd,
        string memory _pType
    ) public returns (address) {
        participants[tx.origin].userName = _name;
        participants[tx.origin].password = _pass;
        participants[tx.origin].participantAddress = _pAdd;
        participants[tx.origin].participantType = _pType;
        participant_counter++;
        return _pAdd;
    }

    function invoke_get_participant_details(address _p_address)
        public
        returns (bool, bytes memory)
    {
        bytes memory payload = abi.encodeWithSignature(
            "getParticipantDetails(address)",
            _p_address
        );

        (bool ok, bytes memory res) = target.call(payload);
        if (!ok) {
            return (false, res);
        } else {
            return (true, res);
        }
    }

    function getParticipantDetails(address _p_address)
        public
        view
        returns (string memory, address, string memory)
    {
        return (
            participants[_p_address].userName,
            participants[_p_address].participantAddress,
            participants[_p_address].participantType
        );
    }

    function invoke_create_product(
        string memory _modelNumber,
        string memory _partNumber,
        string memory _serialNumber,
        uint32 _productCost
    ) public returns (bool, bytes memory) {
        bytes memory payload = abi.encodeWithSignature(
            "createProduct(string,string,string,uint32)",
            _modelNumber,
            _partNumber,
            _serialNumber,
            _productCost
        );

        (bool ok, bytes memory res) = target.call(payload);
        if (!ok) {
            return (false, res);
        } else {
            return (true, res);
        }
    }

    function createProduct(
        string memory _modelNumber,
        string memory _partNumber,
        string memory _serialNumber,
        uint32 _productCost
    ) public returns (uint32) {
        if (
            keccak256(
                abi.encodePacked(participants[tx.origin].participantType)
            ) ==
            keccak256("Manufacturer")
        ) {
            uint32 productId = product_counter++;
            uint32 registration_id = registration_counter++;
            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[tx.origin]
                .participantAddress;
            products[productId].mfgTimeStamp = uint32(now);

            registrations[registration_id].productId = productId;
            registrations[registration_id].productOwner = tx.origin;
            registrations[registration_id].ownerAddress = tx.origin;
            registrations[registration_id].trxTimeStamp = uint32(now);
            productTrack[productId].push(registration_id);

            return productId;
        }

        return 0;
    }

    modifier onlyProductOwner(uint32 _productId) {
        require(tx.origin == products[_productId].productOwner);
        _;
    }
    function invoke_get_product_details(uint32 _productId)
        public
        returns (bool, bytes memory)
    {
        bytes memory payload = abi.encodeWithSignature(
            "getProductDetails(uint32)",
            _productId
        );

        (bool ok, bytes memory res) = target.call(payload);
        if (!ok) {
            return (false, res);
        } else {
            return (true, res);
        }
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
            uint32
        )
    {
        return (
            products[_productId].modelNumber,
            products[_productId].partNumber,
            products[_productId].serialNumber,
            products[_productId].cost,
            products[_productId].productOwner,
            products[_productId].mfgTimeStamp
        );
    }

    function invoke_transfer_to_owner(
        address _user1Address,
        address _user2Address,
        uint32 _prodId
    ) public returns (bool, bytes memory) {
        bytes memory payload = abi.encodeWithSignature(
            "transferToOwner(address,address,uint32)",
            _user1Address,
            _user2Address,
            _prodId
        );

        (bool ok, bytes memory res) = target.call(payload);
        if (!ok) {
            return (false, res);
        } else {
            return (true, res);
        }
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

    function invoke_get_product_track(uint32 _productId)
        public
        returns (bool, bytes memory)
    {
        bytes memory payload = abi.encodeWithSignature(
            "getProductTrack(uint32)",
            _productId
        );

        (bool ok, bytes memory res) = target.call(payload);
        if (!ok) {
            return (false, res);
        } else {
            return (true, res);
        }
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
