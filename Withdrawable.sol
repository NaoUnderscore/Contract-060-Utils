pragma solidity ^0.6.6;

import "https://github.com/NaoUnderscore/Contract-060-Utils/blob/main/ERC20.sol";
import "https://github.com/NaoUnderscore/Contract-060-Utils/blob/main/SafeERC20.sol";
import "https://github.com/NaoUnderscore/Contract-060-Utils/blob/main/Ownable.sol";

/**
    Ensures that any contract that inherits from this contract is able to
    withdraw funds that are accidentally received or stuck.
 */
 
contract Withdrawable is Ownable {
    using SafeERC20 for ERC20;
    address constant ETHER = address(0);

    event LogWithdraw(
        address indexed _from,
        address indexed _assetAddress,
        uint amount
    );

    /**
     * @dev Withdraw asset.
     * @param _assetAddress Asset to be withdrawn.
     */
    function withdraw(address _assetAddress) public onlyOwner {
        uint assetBalance;
        if (_assetAddress == ETHER) {
            address self = address(this); // workaround for a possible solidity bug
            assetBalance = self.balance;
            msg.sender.transfer(assetBalance);
        } else {
            assetBalance = ERC20(_assetAddress).balanceOf(address(this));
            ERC20(_assetAddress).safeTransfer(msg.sender, assetBalance);
        }
        emit LogWithdraw(msg.sender, _assetAddress, assetBalance);
    }
}
