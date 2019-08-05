pragma solidity 0.5.2;

contract EthereumClaimsRegistry {

    mapping(bytes32 => bytes32) public registry;

    event ClaimSet(
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        bytes32 value,
        uint updatedAt);

    event ClaimRemoved(
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        uint removedAt);

    // create or update clams
    function setClaim(address subject, bytes32 key, bytes32 value) public {
        bytes32 encryptedBytes = keccak256(abi.encodePacked(subject, key, msg.sender));
        registry[encryptedBytes] = value;
        emit ClaimSet(msg.sender, subject, key, value, now);
    }

    function setSelfClaim(bytes32 key, bytes32 value) public {
        setClaim(msg.sender, key, value);
    }

    function getClaim(address issuer, address subject, bytes32 key) public view returns(bytes32) {
        bytes32 encryptedBytes = keccak256(abi.encodePacked(subject, key, issuer));
        return registry[encryptedBytes];
    }

    function removeClaim(address issuer, address subject, bytes32 key) public {
        require(msg.sender == issuer);
        bytes32 encryptedBytes = keccak256(abi.encodePacked(subject, key, msg.sender));
        delete registry[encryptedBytes];
        emit ClaimRemoved(msg.sender, subject, key, now);
    }
}