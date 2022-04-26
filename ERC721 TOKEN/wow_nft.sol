pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract wow_nft is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("WOW NFT", "NFT") {
    }

    function mint(address recipient, string memory TokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, TokenURI);
        
        return (newItemId);
    }

}