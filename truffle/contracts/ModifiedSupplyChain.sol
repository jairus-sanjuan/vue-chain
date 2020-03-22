pragma solidity ^0.6.1;

contract ModifiedSupplyChain {
    uint32 public product_counter = 0; // Product ID
    uint32 public participant_counter = 0; // Participant ID
    uint32 public registration_counter = 0; // Registration ID
    constructor() public {}
    struct product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    mapping(uint32 => product) public products;

    struct participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }
    mapping(address => participant) public participants;

    struct registration {
        uint32 productId;
        address ownerAddress;
        uint32 trxTimeStamp;
        address productOwner;
    }
    mapping(uint32 => registration) public registrations; // Registrations by Registration ID (registration_counter)
    mapping(uint32 => uint32[]) public productTrack; // Registrations by Product ID (product_counter) / Movement track for a product

    event Transfer(uint32 productId);

    function createParticipant(
        string memory _name,
        string memory _pass,
        address _pAdd,
        string memory _pType
    ) public returns (address) {
        participants[msg.sender].userName = _name;
        participants[msg.sender].password = _pass;
        participants[msg.sender].participantAddress = _pAdd;
        participants[msg.sender].participantType = _pType;

        return msg.sender;
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

    function createProduct(
        string memory _modelNumber,
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
            uint32 productId = product_counter++;
            uint32 registration_id = registration_counter++;
            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[msg.sender]
                .participantAddress;
            products[productId].mfgTimeStamp = uint32(now);

            registrations[registration_id].productId = productId;
            registrations[registration_id].productOwner = msg.sender;
            registrations[registration_id].ownerAddress = msg.sender;
            registrations[registration_id].trxTimeStamp = uint32(now);
            productTrack[productId].push(registration_id);

            return productId;
        }

        return 0;
    }

    modifier onlyOwner(uint32 _productId) {
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

    function transferToOwner(
        address _user1Address,
        address _user2Address,
        uint32 _prodId
    ) public onlyOwner(_prodId) returns (bool) {
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

    function getProductTrack(uint32 _prodId)
        external
        view
        returns (uint32[] memory)
    {
        return productTrack[_prodId];
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
