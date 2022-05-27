pragma solidity ^0.5.16;

import "./ERC721Basic.sol";

/**
 */

contract ERC721Enumerable is ERC721Basic {
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address _owner, uint _index) public view returns (uint256 _tokenId);
    function tokenByIndex(uint256 _index) public view returns (uint256);
}


/**
    *@title ERC-721 Non-Fungible Token Standard, optional metadata extensio
    *@dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */

 contract ERC721Metadata is ERC721Basic {
    function name() public view returns (string memory _name);
    function symbol() public view returns (string memory _symbol);
    function tokenUIR(uint256 _tokenId) public view returns (string memory);
 }

 /**
 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
  */

  contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
      
  }