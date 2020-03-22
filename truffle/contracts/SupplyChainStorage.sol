pragma solidity ^0.6.1;

contract SupplyChainStorage {
    address owner;
    uint32 public product_counter = 0; // Product ID
    uint32 public participant_counter = 0; // Participant ID
    uint32 public registration_counter = 0; // Registration ID
    constructor() public {
        owner = msg.sender;
    }
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
    modifier onlyOwner {
        require(msg.sender == owner, "Should be owner to invoke functions..");
        _;
    }

    function getProductTrack(uint32 _prodId)
        external
        view
        returns (uint32[] memory)
    {
        return productTrack[_prodId];
    }
}
