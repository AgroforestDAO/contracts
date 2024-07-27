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

    constructor(
        string memory nameNFT,
        string memory symbolNFT,
        address ownerContract
    ) ERC721(nameNFT, symbolNFT) Owned(ownerContract) {
        operator = ownerContract;
    }

    function mint(
        uint256 tokenID,
        string memory tokenUri,
        address recipient
    ) external onlyOwner {
        _mint(tokenID, tokenUri, recipient);
    }

    function mintOperator(
        uint256 tokenID,
        string memory tokenUri,
        address recipient
    ) external {
        if (msg.sender == operator) {
            _mint(tokenID, tokenUri, recipient);
        } else {
            revert NotOperator();
        }
    }

    function transferOperator(address newOperator) public onlyOwner {
        operator = newOperator;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(_exists(tokenId), "CertificateNFT: invalid token ID");

        string memory _tokenURI = tokenURIs[tokenId];
        return _tokenURI;
    }

    function setTokenURI(
        uint256 tokenId,
        string memory tokenUri
    ) public onlyOwner {
        _setTokenURI(tokenId, tokenUri);
    }

    function burn(uint256 tokenId) public {
        require(_exists(tokenId), "CertificateNFT: invalid token ID");
        require(
            ownerOf(tokenId) == msg.sender,
            "CertificateNFT: only owner token can burn"
        );

        super._burn(tokenId);
        delete tokenURIs[tokenId];
    }

    function _mint(
        uint256 tokenID,
        string memory tokenUri,
        address recipient
    ) internal nonReentrant {
        _safeMint(recipient, tokenID);
        _setTokenURI(tokenID, tokenUri);
        emit Mint(recipient, tokenID);
    }

    function _setTokenURI(
        uint256 tokenID,
        string memory tokenUri
    ) internal virtual {
        require(
            _exists(tokenID),
            "CertificateNFT: URI set of nonexistent token"
        );
        tokenURIs[tokenID] = tokenUri;
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf[tokenId] != address(0);
    }
}
