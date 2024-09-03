# @version ^0.4

struct Chest:
    owner: address
    beneficiaries: DynArray[address, 3]
    openTimestamp: uint256
    chestMessage: String[512]

chestCount: uint256
idToChest: HashMap[uint256, Chest]

@deploy
def __init__() -> bool:
    self.chestCount = 0
    return True

@external
@view
def getChestDetails(_chestId: uint256) -> (address, DynArray[address, 3], uint256):
    return (self.idToChest[_chestId].owner, self.idToChest[_chestId].beneficiaries, self.idToChest[_chestId].openTimestamp)

@external
def createChest(_beneficiaries: DynArray[address, 3], _openTimestamp: uint256, _chestMessage: String[512]) -> uint256:
    chestId = self.chestCount
    self.idToChest[chestId].owner = msg.sender
    self.idToChest[chestId].beneficiaries = _beneficiaries
    self.idToChest[chestId].openTimestamp = _openTimestamp
    self.idToChest[chestId].chestMessage = _chestMessage
    self.chestCount += 1
    return chestId

@external
def extendChest(_chestId: uint256, _newOpenTimestamp: uint256):
    isOwner: msg.sender = self.idToChest[_chestId].owner
    assert isOwner, 'You are not chest owner'
    self.idToChest[_chestId][openTimestamp] = _newOpenTimestamp

@external
def claimChest(_chestId) -> String[512]:
    isBeneficiary: msg.sender in self.idToChest[_chestId].beneficiaries
    isOwner: msg.sender = self.idToChest[_chestId].owner
    assert isBeneficiary or isOwner, 'You are not chest beneficiary or owner'
    assert block.timestamp >= self.idToChest[_chestId], 'Not time yet'
    return self.idToChest[_chestId].chestMessage
