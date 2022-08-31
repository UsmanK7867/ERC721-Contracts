// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.5.0/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721Enumerable.sol";


contract CyberShares is ERC721, ERC721URIStorage, ERC721Burnable, Ownable{
    address payable target1 = payable(0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC);
    address payable target2 = payable(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);
using SafeMath for uint;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 public cost = 0.05 ether;
     string public baseURI;
  string public baseExtension = ".json";
  mapping(address => bool) public whitelisted;
bool public reveal= false;
string privateRevealURI="https://gateway.pinata.cloud/ipfs/Qmch5v4XuNu6BpKuchYGiL2iVmAZw7gCSWpo7DV47PeGcZ";
    constructor() ERC721("CyberShares", "CS") {
//  setBaseURI(_initBaseURI);
// setBaseURI(privateRevealURI);
    // bulkMint(msg.sender, 10);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
    function setBaseURI(string memory _newBaseURI) public onlyOwner {

    baseURI = string(abi.encodePacked( _newBaseURI));
  }
    // function createToken(string memory uri) public onlyOwner {
    //     _tokenIdCounter.increment();
    //     uint256 tokenId = _tokenIdCounter.current();
    //     _safeMint(msg.sender, tokenId);
    //     _setTokenURI(tokenId, uri);
    // }

    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) onlyOwner {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
    { require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
//    return super.tokenURI(string(abi.encodePacked( Strings.toString(tokenId),baseExtension)));
        if(reveal == true){
        string memory currentBaseURI = _baseURI();

          return bytes(currentBaseURI).length > 0
                ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
                : "";
        }
        else {
            return privateRevealURI;
            
                // return super.tokenURI(tokenId);
        }
    }

  function getContractBalance() public view returns(uint){
    return address(this).balance;
  }  

function toggleReveal() public {
    reveal= !reveal;
}

    // Total Minted Tokens
    function totalTokens() public view returns (uint256) {
        return _tokenIdCounter.current();
    }
    // AirDrop
    function airDrop(address[] calldata _to, uint256[] calldata _id) public onlyOwner {
        require(_to.length == _id.length, "Number of receivers and ids have different length");
        for(uint256 i=0; i< _to.length; i++){
            safeTransferFrom(msg.sender, _to[i], _id[i]);
        }
    }

    function mint(address _to, uint256 _mintAmount) public payable {
    
    
    require(_mintAmount > 0);
    if (msg.sender != owner()) {
        if(whitelisted[msg.sender] != true) {
          // require(msg.value >= cost * _mintAmount);
          require(msg.value >= cost);
          uint per=(msg.value).div(10);
          payable(target1).transfer(per.div(2));
          payable(target2).transfer(per.div(2));
        }
    }
 
    for (uint256 i = 1; i <= _mintAmount; i++) {
         _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
      _safeMint(_to, tokenId);
    //   _setTokenURI(tokenId, uri);
    }
  }

  function whitelistUser(address _user) public onlyOwner {
    whitelisted[_user] = true;
  }
 
  function removeWhitelistUser(address _user) public onlyOwner {
    whitelisted[_user] = false;
  }
}
