pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT_COLLECTION is ERC1155 {
    uint256 public constant Kyle = 1;
    uint256 public constant Stan = 2;
    uint256 public constant Cartman = 3;
    uint256 public constant Kenny = 4;

// Minting 4 different NFT Collections aka South Park NFTs
    constructor() ERC1155("https://ipfs://bafybeiggigltslc5342yu6o2zxhzvm5cgrb5np42q3pfgflwbs2yx6242u{id}.json") {
        _mint(msg.sender, Kyle, 1, "");
        _mint(msg.sender, Stan, 1, "");
        _mint(msg.sender, Cartman, 1, "");
        _mint(msg.sender, Kenny, 1, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs://bafybeiggigltslc5342yu6o2zxhzvm5cgrb5np42q3pfgflwbs2yx6242u/",
                Strings.toString(_tokenid),".json"
            )
        );
    }
}