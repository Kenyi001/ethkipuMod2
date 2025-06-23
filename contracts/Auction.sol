// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Subasta con extension de tiempo y reembolsos parciales
contract Auction {
    // --- Variables de estado ---
    address public owner;
    uint public endTime;
    uint public highestBid;
    address public highestBidder;
    uint constant MIN_INCREMENT_PCT = 5;    // 5%
    uint constant EXTEND_WINDOW = 10 minutes;
    uint constant COMMISSION_PCT = 2;       // 2%

    // Mapeo de depositos por participante
    mapping(address => uint[]) public bids;

    // Eventos
    event NewBid(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // --- Modificadores ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario");
        _;
    }

    modifier auctionActive() {
        require(block.timestamp < endTime, "Subasta finalizada");
        _;
    }

    modifier validIncrement(uint amount) {
        uint minRequired = highestBid + (highestBid * MIN_INCREMENT_PCT) / 100;
        require(amount >= minRequired, "Debe superar en 5 por ciento la mejor oferta");
        _;
    }

    // --- Constructor ---
    constructor(uint _durationMinutes, uint _startingBid) {
        owner = msg.sender;
        endTime = block.timestamp + (_durationMinutes * 1 minutes);
        highestBid = _startingBid;
    }

    // --- Funcion para ofertar ---
    function bid() external payable auctionActive validIncrement(msg.value) {
        // Guarda deposito
        bids[msg.sender].push(msg.value);

        // Si quedamos dentro de los ultimos 10 minutos, extendemos
        if (endTime - block.timestamp <= EXTEND_WINDOW) {
            endTime = block.timestamp + EXTEND_WINDOW;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        emit NewBid(msg.sender, msg.value);
    }

    // --- Reembolso parcial ---
    function refund(uint index) external {
        require(index < bids[msg.sender].length, "Indice invalido");
        uint amount = bids[msg.sender][index];
        // No permitir reembolso de la ultima oferta exitosa
        require(!(msg.sender == highestBidder && amount == highestBid), "No puede reembolsar la ultima oferta");
        // Elimina el deposito "index" (dejandolo en cero)
        bids[msg.sender][index] = 0;
        payable(msg.sender).transfer(amount);
    }

    // --- Finalizar subasta y repartir fondos ---
    function endAuction() external {
        require(block.timestamp >= endTime, "Aun activa");
        emit AuctionEnded(highestBidder, highestBid);

        // Comision
        uint commission = (highestBid * COMMISSION_PCT) / 100;
        uint payout = highestBid - commission;

        // Paga al owner
        payable(owner).transfer(payout);
        // La comision se queda en el contrato para retiro posterior
    }

    // --- Getters adicionales opcionales ---
    function getBids(address bidder) external view returns (uint[] memory) {
        return bids[bidder];
    }
}
