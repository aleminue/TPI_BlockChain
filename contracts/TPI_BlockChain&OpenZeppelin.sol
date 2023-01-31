// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TPI_BlockChain is Ownable{

    event LogWhitdrawTo(address fromWallet, address toWallet);

    receive() external payable {}

    function withdrawAll() external onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }

    function withdraw(uint256 _amount) external onlyOwner{
        require(address(this).balance >= _amount,"Sus fondos son insuficientes");
        payable(owner()).transfer(_amount);
    }

    function withdrawToWallet(address _wallet, uint256 _amount) external onlyOwner{
        require(address(this).balance >= _amount,"Sus fondos son insuficientes");
        payable(_wallet).transfer(_amount);
        emit LogWhitdrawTo(address(this), _wallet);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

}
