pragma solidity ^0.8.7;

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarket is ReentrancyGuard {

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    address payable owner;
    uint listingPrice = 0.025 ether;

    constructor(){
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint itemId;
        address nftContract;
        uint tokenId;
        address payable seller;
        address payable owner;
        uint price;
        bool sold;

    }

    mapping(uint => MarketItem) private idTomMarketItem;

    event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint indexed tokenId,
        address seller,
        address owner,
        uint price,
        bool sold

    );

    function getListingPrice() public view returns(uint){
        return listingPrice;
    }

    function createMarketItem(address nftContract, uint tokenId, uint price) public payable nonReentrant {
        require(price > 0, "price must be at least 1 wei");
        require(msg.value == listingPrice, "Price must be equal to listing price");

        _itemIds.increment();
        uint itemId = _itemIds.current();

        idTomMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    emit MarketItemCreated (
        itemId,
        nftContract,
        tokenId,
        msg.sender,
        address(0),
        price,
        false 

    );
    }

    function createMarketSale(address nftContract, uint itemId) public payable nonReentrant {

        uint price = idTomMarketItem[itemId].price;
        uint tokenId = idTomMarketItem[itemId].tokenId;

        require(msg.value == price, "please submit the asked price");
        
        idTomMarketItem[itemId].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        idTomMarketItem[itemId].sold = true;
        _itemsSold.increment();
        payable(owner).transfer(listingPrice);
    }



}