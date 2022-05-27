pragma solidity ^0.5.16;

import "./ERC721.sol";
/**

 */

 contract DeprecatedERC721 is ERC721 {
     function takeOwnership(uint256 _tokenId) public;
     function transfer(address _to, uint256 _tokenId) public;
     function tokenOf(address _owner) public view returns (uint256[] memory);
 }