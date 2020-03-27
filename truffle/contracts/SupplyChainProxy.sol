pragma solidity ^0.6.1;
import "./SupplyChainStorage.sol";


contract SupplyChainProxy is SupplyChainStorage {
    address target;

    function setLogicContract(address _target) public returns (address) {
        target = _target;

        return (target);
    }

    fallback() external {
        // bytes memory data = msg.data;
        address impl = target;

        assembly {
            // Copy the data sent to the memory address starting free mem position
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            // Proxy the call to the contract address with the provided gas and data
            let res := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)

            // Copy the data returned by the proxied call to memory
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            // Check what the result is, return and revert accordingly
            switch res
                case 0 {
                    revert(ptr, size)
                }
                default {
                    return(ptr, size)
                }
        }
    }

    function getProxy() public view returns (address) {
        return target;
    }

    function getAddress() public view returns (address) {
        return address(this);
    }
}
