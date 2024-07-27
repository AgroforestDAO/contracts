// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.8.18;

import "solmate/src/tokens/ERC721.sol";
import "solmate/src/auth/Owned.sol";
import "solmate/src/utils/ReentrancyGuard.sol";

error NonExistentTokenURI();
error NotOperator();

contract AgroforestDAONests is ERC721, Owned, ReentrancyGuard {
    mapping(uint256 => string) private tokenURIs;
    address public operator;

    event Mint(address indexed to, uint256 indexed id);

